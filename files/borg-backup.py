#!/usr/bin/env python3

#
# THIS FILE IS MANAGED BY PUPPET
#

# Written by Thore Bödecker <me@foxxx0.de>

import argparse, os, pprint, shutil, signal, subprocess, sys, yaml
from datetime import datetime
from tempfile import mkdtemp

debug_enabled = False

def main(config):
    # create tempdir
    msg('Creating tempdir')
    temp_dir = mkdtemp(prefix='borg-backup.py_')
    debug('temp_dir: {d}'.format(d=temp_dir))

    # ensure cleanup of tempdir
    try:
        # grab some potentially useful data for full restores
        msg('Gathering disk and mount information')
        backup_data_dir = '/root/backup-data'
        if not os.path.exists(backup_data_dir):
            os.makedirs(backup_data_dir)
        gather_diskinfo(backup_data_dir)

        # Check if /boot is a separate partition / filesystem
        separate_boot = False
        if run(cmd='mountpoint', args=['-q', '/boot']).returncode == 0:
            separate_boot = True
            msg('Separate /boot filesystem detected')

        # check for (unknown) mountpoints that are neither included nor excluded
        check_mountpoints(config)

        # make sure BORG_REPO is mounted if it's mountpoint (config)
        if config.borg.repo.type == 'filesystem':
            if config.borg.repo.filesystem.requires_mount:
                repo_path = config.borg.repo.filesystem.path
                if run(cmd='mountpoint', args=['-q', repo_path]).returncode != 0:
                    msg2('BORG_REPO is mountpoint but not mounted, aborting.')
                    sys.exit(4)

        # generate exclude list using defined globs and excluded mountpoints
        msg('Building borg exclude list')
        exclude = gen_exclude_list(config, temp_dir)
        debug('exclude_list contents:')
        debug(run(cmd='cat', args = [exclude]).stdout)

        # TODO: dump databases if any
        # msg('Dumping databases')

        # create and mount snapshots
        try:
            if config.lvm.use_snapshots:
                msg('Creating snapshots')
                snapshots = {}
                create_snapshots(config, separate_boot, snapshots)
                debug('snapshots: {s}'.format(s=snapshots))
        except ExternalProcError as err:
            leftover = cleanup_snapshots(snapshots, separate_boot)
            debug('leftover mounted snapshots: {l}'.format(l=leftover))
            raise

        # after we have created and mounted the snapshots, ensure cleanup of those
        try:
            # do the actual borg backup
            msg('Running borg (BORG_REPO={r})'.format(r=config.borg.dest))
            with cd(config.backup_root) as cwd:
                debug('changed cwd to {x}'.format(x=cwd.newPath))
                borg_backup(config, '.', exclude)

            # prune old backups
            msg('Pruning old backups')
            borg_prune(config)

            # TODO: run borg-restore.pl -u if desired/installed (config?!)
        finally:
            if config.lvm.use_snapshots:
                # cleanup snapshots
                msg('Cleaning up snapshots')
                leftover = cleanup_snapshots(config, snapshots, separate_boot)
                debug('leftover mounted snapshots: {l}'.format(l=leftover))
    finally:
        # cleanup tempdir
        msg('Removing tempdir')
        shutil.rmtree(temp_dir)

    msg('Finished')
    return True


def check_mountpoints(config):
    unknown = []
    with open('/etc/mtab', 'r') as f:
        for line in f.readlines():
            try:
                mpoint = line.strip().split(' ')[1].replace('\\040', ' ')
            except IndexError as e:
                msg2('Unexpected input when trying to parse /etc/mtab')
                msg2(e)
                sys.exit(2)
            if not mpoint in config.include.mountpoints:
                if not any([mpoint.startswith(x) for x in config.exclude.mountpoints]):
                    unknown.append(mpoint)

    if len(unknown) > 0:
        for mpoint in unknown:
            msg2('mountpoint neither excluded nor included: {m}'.format(m=mpoint))
        raise UnknownMountpoint(unknown)
    else:
        return True


def borg_backup(config, src, exclude):
    opts = ['--verbose',
            '--numeric-owner',
            '--compression', 'lz4',
            '--stats',
            '--exclude-from', exclude]

    tstamp = datetime.now().strftime('%Y%m%d-%H%M%S')
    archive = '{dst}::backup-{ts}'.format(dst=config.borg.dest, ts=tstamp)

    borg_args = ['create'] + opts + [archive, src]

    debug('running "borg {args}"'.format(args=' '.join(borg_args)))

    result = run(cmd = 'borg', args = borg_args)
    msg('BORG returncode: {ret}'.format(ret=result.returncode))
    msg('BORG stdout:\n{x}'.format(x=result.stdout))
    msg('BORG stderr:\n{x}'.format(x=result.stderr))
    return result

def borg_prune(config):
    borg_prune_opts = []
    for arg in config.borg.prune:
        borg_prune_opts.append('--{arg}'.format(arg=arg))
        borg_prune_opts.append(config.borg.prune[arg])

    borg_args = ['prune'] + borg_prune_opts + [config.borg.dest]

    debug('running "borg {args}"'.format(args=' '.join(borg_args)))

    return run(cmd='borg', args=borg_args)


def create_snapshots(config, separate_boot, snapshots):
    found_root = False
    backup_root = config.backup_root
    backup_volumes = config.lvm.volumes
    snap_suffix = config.lvm.snapshot_suffix
    snapmount_base = config.lvm.snapshot_mount_base
    for path in backup_volumes:
        msg('  + {p}'.format(p=path))
        vg, lv = path.split('-')
        size = backup_volumes[path]['snap_size']
        mpoint = backup_volumes[path]['mount_point']
        snap_name = '{lv}snap{suff}'.format(lv=lv, suff=snap_suffix)

        # create the snapshot
        run(cmd='lvcreate',
            args=['-L', size, '-s', '-n', snap_name,
                  '{vg}/{lv}'.format(vg=vg, lv=lv)],
            raise_err=True)
        snapshot = '/dev/{vg}/{n}'.format(vg=vg, n=snap_name)

        # ensure mountpoint exists
        target = '{b}/{vg}-{n}'.format(b=snapmount_base, vg=vg, n=snap_name)
        if not os.path.exists(target):
            os.makedirs(target)

        # mount it
        debug('mounting {snap} on {dst}'.format(snap=snapshot, dst=target))
        run(cmd='mount',
            args=['-o', 'ro,sync,noatime,nodiratime', snapshot, target], raise_err=True)

        snap_id = '{vg}/{snap}'.format(vg=vg, snap=snap_name)
        snapshots[snap_id] = {}
        snapshots[snap_id]['dev'] = snapshot
        snapshots[snap_id]['mount_point'] = target
        snapshots[snap_id]['bind_mount'] = mpoint

        # if we're '/' go ahead and bind-mount backup_root
        if mpoint == '/':
            debug('bind-mounting {src} on {dst}'.format(src=target, dst=backup_root))
            run(cmd='mount', args=['--bind', target, backup_root], raise_err=True)
            found_root = True

    if not found_root:
        msg2('Unable to find root snapshot for bind-mounts, aborting.')
        sys.exit(1)

    # re-iterate through remaining snapshots and bind-mount them too
    for snap_id in snapshots:
        vg, snap = snap_id.split('/')
        mpoint = snapshots[snap_id]['mount_point']
        bindmount = snapshots[snap_id]['bind_mount']
        if bindmount != '/':
            target = '{b}/{p}'.format(b=backup_root, p=bindmount.lstrip('/'))
            debug('bind-mounting {src} on {dst}'.format(src=mpoint, dst=target))
            run(cmd='mount', args=['--bind', mpoint, target], raise_err=True)

    # don't forget /boot!
    if separate_boot:
        target = '{b}/boot'.format(b=backup_root)
        debug('bind-mounting {src} on {dst}'.format(src='/boot', dst=target))
        run(cmd='mount', args=['--bind', '/boot', target], raise_err=True)

    return snapshots

def cleanup_snapshots(config, snapshots, separate_boot):
    backup_root = config.backup_root
    leftover = snapshots.copy()
    for snap_id in snapshots:
        vg, snap = snap_id.split('/')
        snap_dev = snapshots[snap_id]['dev']
        mpoint = snapshots[snap_id]['mount_point']
        bindmount = snapshots[snap_id]['bind_mount']
        target = '{b}/{p}'.format(b=backup_root, p=bindmount.lstrip('/'))
        # root needs to be unmounted last (obviously...)
        if bindmount != '/':
            msg('  + {snap_id}'.format(snap_id=snap_id))
            # unmount the bindmount
            debug('unmounting bind-mount {mp}'.format(mp=target))
            result = run(cmd='umount', args=[target])
            debug('stdout: {o}, stderr: {e}'.format(o=result.stdout, e=result.stderr))
            # unmount the snapshot
            debug('unmounting snapshot {snap}'.format(snap=snap_dev))
            result = run(cmd='umount', args=[snap_dev])
            debug('stdout: {o}, stderr: {e}'.format(o=result.stdout, e=result.stderr))
            # remove the snapshot
            debug('removing snapshot {snap}'.format(snap=snap_id))
            result = run(cmd='lvremove', args=['-f', snap_id])
            debug('stdout: {o}, stderr: {e}'.format(o=result.stdout, e=result.stderr))
            if result.returncode == 0:
                leftover.pop(snap_id, None)

    # don't forget /boot!
    if separate_boot:
        target = '{b}/boot'.format(b=backup_root)
        debug('unmounting bind-mount {mp}'.format(mp=target))
        result = run(cmd='umount', args=[target])
        debug('stdout: {o}, stderr: {e}'.format(o=result.stdout, e=result.stderr))

    debug('leftover mounts after first loop: {l}'.format(l=' '.join(leftover)))

    # cleanup root
    for snap_id in dict(leftover):
        vg, snap = snap_id.split('/')
        snap_dev = snapshots[snap_id]['dev']
        mpoint = snapshots[snap_id]['mount_point']
        bindmount = snapshots[snap_id]['bind_mount']
        target = backup_root
        # root needs to be unmounted last (obviously...)
        if bindmount == '/':
            msg('  + {snap_id}'.format(snap_id=snap_id))
            # unmount the bindmount
            debug('unmounting bind-mount {mp}'.format(mp=target))
            result = run(cmd='umount', args=[target])
            debug('stdout: {o}, stderr: {e}'.format(o=result.stdout, e=result.stderr))
            # unmount the snapshot
            debug('unmounting snapshot {snap}'.format(snap=snap_dev))
            result = run(cmd='umount', args=[snap_dev])
            debug('stdout: {o}, stderr: {e}'.format(o=result.stdout, e=result.stderr))
            # remove the snapshot
            debug('removing snapshot {snap}'.format(snap=snap_id))
            result = run(cmd='lvremove', args=['-f', snap_id])
            debug('stdout: {o}, stderr: {e}'.format(o=result.stdout, e=result.stderr))
            if result.returncode == 0:
                leftover.pop(snap_id, None)

    return leftover


def msg(line=''):
    tstamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    print('[{ts}] {l}'.format(ts=tstamp, l=line))

def eprint(*args, **kwargs):
    print(*args, file=sys.stderr, **kwargs)

def msg2(line=''):
    tstamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    eprint('[{ts}] ERROR: {l}'.format(ts=tstamp, l=line))

def debug(line=''):
    if debug_enabled:
        print('DEBUG: {l}'.format(l=line))

def pp(obj):
    pp = pprint.PrettyPrinter(stream=sys.stdout)
    pp.pprint(obj)

def pp2(obj):
    pp2 = pprint.PrettyPrinter(stream=sys.stderr)
    pp2.pprint(obj)

# https://stackoverflow.com/questions/431684/how-do-i-change-directory-cd-in-python/13197763#13197763
class cd:
    """ Context manager for changing the current working directory """
    def __init__(self, newPath):
        self.newPath = os.path.expanduser(newPath)

    def __enter__(self):
        self.savedPath = os.getcwd()
        os.chdir(self.newPath)
        return self

    def __exit__(self, etype, value, traceback):
        os.chdir(self.savedPath)

class UnknownMountpoint(Exception):
    """ Raised when a mountpoint is neither excluded nor included """
    pass

class ExternalProcError(Exception):
    """ Raised for unsuccessful external commands if desired """
    pass

""" Allow access to dict member as object properties """
class objdict(dict):
    def __getattr__(self, name):
        if name in self:
            elem = self[name]
            if isinstance(elem, dict):
                return objdict(elem)
            else:
                return elem
        else:
            raise AttributeError('No such attribute: {attr}'.format(attr=name))

""" Returned by run() to have a well defined object """
class Proc(object):
    def __init__(self, stdout, stderr, returncode):
        self.stdout = stdout
        self.stderr = stderr
        self.returncode = returncode

""" Wrapper to ease running external commands """
def run(cmd='true', args=[], shell=False, raise_err=False,
        stdout=subprocess.PIPE, stderr=subprocess.PIPE):
    p = subprocess.Popen(
        [cmd] + args,
        shell = shell,
        stdout=stdout,
        stderr=stderr
    )
    stdout, stderr = p.communicate()
    p.wait()
    result = Proc(stdout.decode().strip(),
                  stderr.decode().strip(),
                  p.returncode)
    if raise_err and result.returncode != 0:
        raise ExternalProcError(
                'Something went wrong here: {c} exited with {e} ({err}).'.format(
                    c=cmd, e=result.returncode, err=result.stderr))
    return result


def gen_exclude_list(config, temp_dir):
    # write the exclude list as shell globs for borg
    borg_exclude = 'exclude-list-borg'
    filename = '{tmp}/{file}'.format(tmp=temp_dir, file=borg_exclude)

    patterns = config.exclude.paths
    patterns += [s + '/*' for s in config.exclude.mountpoints]
    with open(filename, 'w') as outf:
        for path in patterns:
            # always use relativ path
            if not path.startswith('.'):
                path = '.' + path
            outf.write('sh:{p}\n'.format(p=path))
    return filename


def gather_diskinfo(outdir):
    for cmd in [['fdisk', '-l'], ['pvdisplay'], ['vgdisplay'], ['lvdisplay'],
                ['df', '-Tha'], ['findmnt', '-l']]:
        result = run(cmd=cmd[0], args=cmd[1:])
        with open('{base}/{f}'.format(base=outdir, f=cmd[0]), 'w') as outf:
            outf.write(result.stdout)

def signal_handler(sig, frame):
    msg2('Aborting due to {s} by user'.format(s=signal.Signals(sig).name))
    sys.exit(0)

# catch ^C and TERM
signal.signal(signal.SIGINT, signal_handler)
signal.signal(signal.SIGTERM, signal_handler)

if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        formatter_class=argparse.ArgumentDefaultsHelpFormatter
    )
    parser.add_argument('-c', '--config', required=True, type=str,
                        metavar='CONFIG', help='configuration file')
    parser.add_argument('-d', '--debug', required=False, action='store_true',
                        help='enable debug output')
    args = parser.parse_args()

    with open(args.config, 'r') as f:
        config = objdict(yaml.safe_load(f))
    #  pp(config)
    debug_enabled = args.debug

    if config.borg.repo.type == 'filesystem':
        backup_dest = config.borg.repo.filesystem.path
    elif config.borg.repo.type == 'borgserver':
        backup_dest = '{server}:{remote_dir}'.format(
                server = config.borg.repo.server.hostname,
                remote_dir = config.borg.repo.server.remote_dir
        )
    else:
        msg2('Invalid configuration.')
        msg2('Please specify borg.repo.type as either "filesystem" or "borgserver"')
        sys.exit(3)

    config['borg']['dest'] = backup_dest

    if config.lvm.use_snapshots:
        # ensure backup_root mountpoint exists
        backup_root = '{b}/backup_root'.format(b=config.lvm.snapshot_mount_base)
        if not os.path.exists(backup_root):
            os.makedirs(backup_root)
    else:
        backup_root = '/'
    config['backup_root'] = backup_root

    main(config)
