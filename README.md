# puppet-borg

[![Build Status](https://github.com/voxpupuli/puppet-borg/workflows/CI/badge.svg)](https://github.com/voxpupuli/puppet-borg/actions?query=workflow%3ACI)
[![Release](https://github.com/voxpupuli/puppet-borg/actions/workflows/release.yml/badge.svg)](https://github.com/voxpupuli/puppet-borg/actions/workflows/release.yml)
[![Puppet Forge](https://img.shields.io/puppetforge/v/puppet/borg.svg)](https://forge.puppetlabs.com/puppet/borg)
[![Puppet Forge - downloads](https://img.shields.io/puppetforge/dt/puppet/borg.svg)](https://forge.puppetlabs.com/puppet/borg)
[![Puppet Forge - endorsement](https://img.shields.io/puppetforge/e/puppet/borg.svg)](https://forge.puppetlabs.com/puppet/borg)
[![Puppet Forge - scores](https://img.shields.io/puppetforge/f/puppet/borg.svg)](https://forge.puppetlabs.com/puppet/borg)
[![puppetmodule.info docs](http://www.puppetmodule.info/images/badge.png)](http://www.puppetmodule.info/m/puppet-borg)
[![AGPL v3 License](https://img.shields.io/github/license/voxpupuli/puppet-borg.svg)](LICENSE)

## Table of contents

* [Borg Setup](#borg-setup)
  * [Examples](#examples)
* [Restore Script](#restore-script)
* [Prometheus Exporter](#prometheus-exporter)
* [Limitations](#limitations)
* [Tests](#tests)
* [Contributions](#contributions)
* [License and Author](#license-and-author)

## Borg Setup

[Borg](https://borgbackup.readthedocs.io/en/stable/) is a client that creates
local backups, encrypts them, and saves them at a given location. A possible
location is the local filesystem, a mount of a remote storage (like CIFS),
certain storage protocols it directly can interact with or another borg binary.
The latter is the preferred option. You can place the borg binary on a remote
linux system and create an ssh account that cannot allocate a PTY and has
`ForceCommand` set to `borg serve`. Such u user can only send and receive
backups to the binary via ssh. A possible configuration for the sshd server
looks like this (won't be handled by this module):

```
# /etc/ssh/sshd_config
AcceptEnv LANG LC_*
ChallengeResponseAuthentication no
PasswordAuthentication no
PrintMotd no
Subsystem sftp /usr/libexec/sftp-server
UsePAM yes
X11Forwarding yes
Match Group borgusers
    AllowAgentForwarding no
    AllowTcpForwarding no
    AuthorizedKeysFile %h/%u/.ssh/authorized_keys
    ForceCommand borg serve
    PasswordAuthentication no
    PermitTTY no
    PermitUserRC no
    X11Forwarding no
```

This module will provide a borg backup script that works with such a setup. We
will also configure a systemd service and a timer to execute it on a regular
basis. Borg doesn't automatically prune old backups, our script has parameters
for this.

Please have a look at our [REFERENCE.d](REFERENCE.md). All parameters are
documented in that file.

### Examples

The only parameter you really need to set is FQDN of the remote server:

```puppet
class{'borg':
  backupserver => 'myawesomebackupmachine.org'
}
```

We assume that your ssh username is the hostname from the client. You maybe
want to overwrite this assumption:

```puppet
class{'borg':
  backupserver => 'myawesomebackupmachine.org',
  username => 'notmyhostname',
}
```

We need to tell the script what we want to do with every mountpoint, backup it
or ignore it. We can also exclude specific paths. The defaults are stored in
the [manifests/init.pp](https://github.com/voxpupuli/puppet-borg/blob/master/manifests/init.pp)
with os-specific overrides in [data/](https://github.com/voxpupuli/puppet-borg/blob/master/data/).

## Restore Script

Figuring out from which backup archive you want to restore a certain file can
be quite time-consuming with just borg alone. When listing the contents of each
backup archive, the client will talk to the remote server a lot during the
generation of the list. To speed this up, Florian Pritz developed a helper. This
will be executed after every backup. The script talks to the server and fetches
a list of all files from the last backup. The information are stored in a local
sqlite database. You can do restores directly via this script. You can find the
upstream documentation (including examples) at [metacpan.org](https://metacpan.org/pod/distribution/App-BorgRestore/script/borg-restore.pl)

## Prometheus Exporter

More and more people use prometheus. We vendor a bash script that can provide
you metrics about your backups in the prometheus format. They are written to
disk and the node\_exporter can collect them.

## Limitations

On CentOS 8, the PowerTools repository needs to be enabled by the user.
Packages from EPEL8 require the repository but it's disabled by default. For
more information see:
* [CentOS 8 bug report about borgbackup](https://bugzilla.redhat.com/show_bug.cgi?id=1993287)
* [EPEL8 setup guidelines](https://fedoraproject.org/wiki/EPEL#Quickstart)

borgbackup before 1.1.17 didn't depend on packages from PowerTools so this
worked by accident.

## Tests

This module has several unit tests and linters configured. You can execute them
by running:

```sh
bundle exec rake test
```

Detailed instructions are in the [CONTRIBUTING.md](.github/CONTRIBUTING.md)
file.

## Contributions

Contribution is fairly easy:

* Fork the module into your namespace
* Create a new branch
* Commit your bugfix or enhancement
* Write a test for it (maybe start with the test first)
* Create a pull request

Detailed instructions are in the [CONTRIBUTING.md](.github/CONTRIBUTING.md)
file.

## License and Author

This module was originally written by [Tim Meusel](https://github.com/bastelfreak).
It's licensed with [AGPL version 3](LICENSE).
