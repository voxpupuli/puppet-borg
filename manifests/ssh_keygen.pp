# Define: ssh_keygen
# @param user
#   The user that will own they key
#
# @param type
#   the openssh key type
#
# @param bits
#   The key length
#
# @param home
#   The homedir where we will store the key
#
# @param filename
#   The filename for the new key
#
# @param comment
#   Comments that should be added to the key
#
# @param options
#   Additional ssh-keygen paramters and options
#
# this is based on https://github.com/maestrodev/puppet-ssh_keygen/blob/master/manifests/init.pp
define borg::ssh_keygen (
  $user     = undef,
  $type     = undef,
  $bits     = undef,
  $home     = undef,
  $filename = undef,
  $comment  = undef,
  $options  = undef,
) {

  Exec { path => '/bin:/usr/bin' }

  $user_real = $user ? {
    undef   => $name,
    default => $user,
  }

  $type_real = $type ? {
    undef   => 'ed25519',
    default => $type,
  }

  $home_real = $home ? {
    undef   => $user_real ? {
      'root'  => "/${user_real}",
      default => "/home/${user_real}",
    },
    default => $home,
  }

  $filename_real = $filename ? {
    undef   => "${home_real}/.ssh/id_${type_real}",
    default => $filename,
  }

  $type_opt = " -t ${type_real}"
  if $bits {
    $bits_opt = " -b ${bits}"
  } else {
    $bits_opt = ''
  }
  $filename_opt = " -f '${filename_real}'"
  $n_passphrase_opt = " -N ''"
  if $comment {
    $comment_opt = " -C '${comment}'"
  } else {
    $comment_opt = ''
  }
  $options_opt = $options ? {
    undef   => undef,
    default => " ${options}",
  }

  exec { "ssh_keygen-${name}":
    command => "ssh-keygen${type_opt}${bits_opt}${filename_opt}${n_passphrase_opt}${comment_opt}${options_opt}",
    user    => $user_real,
    creates => $filename_real,
  }

}
