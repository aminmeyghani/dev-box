$ar_databases = ['vagrant']
$as_vagrant   = 'sudo -u vagrant -H bash -l -c'
$home         = '/home/vagrant'

Exec {
  path => ['/usr/sbin', '/usr/bin', '/sbin', '/bin', '/home/vagrant']
}

# --- Preinstall Stage ---------------------------------------------------------

stage { 'preinstall':
  before => Stage['main']
}

# update and the pre-install folders.
class update_and_preinstall {

  # exec { 'Update Aptitude sources':
  #   command => 'apt-get update'
  # }
  exec { 'apt-get update': }

  # create a the shell scripts directory.      
  file { "/home/vagrant/scripts":
      ensure => "directory"
  }
  # set up shared folder
  file { "/home/vagrant/shared_folder":
      ensure => "directory",
  }

  # set up the log file
  file { "/home/vagrant/puppetlog.txt":
      ensure => "present",
      group => "vagrant",
      mode => 0777
  }
  # add the rails install script
  file { "/home/vagrant/scripts/install-rails.sh":
    source => "/vagrant/puppet/files/install-rails.sh",
    owner => "vagrant", group => "vagrant", mode => 0755;
  }
  # install node.
  file {
    "/home/vagrant/scripts/install-node.sh":
    source => "/vagrant/puppet/files/install-node.sh",
    owner => "vagrant", group => "vagrant", mode => 0755;
  }
  # copy over the uninstall node scropt
  file {
    "/home/vagrant/scripts/uninstall-node.sh":
    source => "/vagrant/puppet/files/uninstall-node.sh",
    owner => "vagrant", group => "vagrant", mode => 0755;
  }
  # copy over the install grunt shell script.
  file {
    "/home/vagrant/scripts/install-grunt.sh":
    source => "/vagrant/puppet/files/install-grunt.sh",
    owner => "vagrant", group => "vagrant", mode => 0755;
  }
  # set up the www symbolic link to /var/www
  file { "/home/vagrant/shared_folder/www":
      ensure => "directory",
  }

  # set the symlink only if the apache script is ran.
  file { '/var/www':
     ensure => 'link',
     target => '/home/vagrant/shared_folder/www',
     force => true,
  }

  # copy over the install php + apache.
  file { "/home/vagrant/scripts/install-lamp.sh":
    source => "/vagrant/puppet/files/install-lamp.sh",
    owner => "vagrant", group => "vagrant", mode => 0755;
  }
}
class { 'update_and_preinstall':
  stage => preinstall
}

# --- Installing node. ---------------------------------------------------------
# copy over the install node script.

class installnode {
  exec { '/home/vagrant/scripts/install-node.sh': 
    require => File['/home/vagrant/scripts/install-node.sh']
  }
}
class { 'installnode': }

# # # --- Installing grunt. ---------------------------------------------------------

class installgrunt {
  require installnode
  exec { '/home/vagrant/scripts/install-grunt.sh': 
    require => File['/home/vagrant/scripts/install-grunt.sh']
  }
}
class { 'installgrunt': }

# # # --- Packages -----------------------------------------------------------------

package { 'curl':
  ensure => installed
}

package { 'build-essential':
  ensure => installed
}

package { 'git-core':
  ensure => installed
}

# vim is not obviously required.
package { 'vim':
  ensure => installed
}

# # # --- SQLite -------------------------------------------------------------------

package { ['sqlite3', 'libsqlite3-dev']:
  ensure => installed;
}

# # --- MySQL --------------------------------------------------------------------

class install_mysql {
  class { 'mysql': }

  class { 'mysql::server':
    config_hash => { 'root_password' => '' }
  }

  database { $ar_databases:
    ensure  => present,
    charset => 'utf8',
    require => Class['mysql::server']
  }

  database_user { 'rails@localhost':
    ensure  => present,
    require => Class['mysql::server']
  }

  database_grant { ['rails@localhost/activerecord_unittest', 'rails@localhost/activerecord_unittest2']:
    privileges => ['all'],
    require    => Database_user['rails@localhost']
  }

  package { 'libmysqlclient15-dev':
    ensure => installed
  }
}
class { 'install_mysql': }

# # --- PHP + APACHE ---------------------------------------------------------------  

class installlamp {
  # require apt_get_update
  # require install_mysql
  exec { '/home/vagrant/scripts/install-lamp.sh': 
    require => File['/home/vagrant/scripts/install-lamp.sh'] 
  }
}
class { 'installlamp': }


# # --- PostgreSQL ---------------------------------------------------------------

# # class install_postgres {
# #   class { 'postgresql': }

# #   class { 'postgresql::server': }

# #   pg_database { $ar_databases:
# #     ensure   => present,
# #     encoding => 'UTF8',
# #     require  => Class['postgresql::server']
# #   }

# #   pg_user { 'rails':
# #     ensure  => present,
# #     require => Class['postgresql::server']
# #   }

# #   pg_user { 'vagrant':
# #     ensure    => present,
# #     superuser => true,
# #     require   => Class['postgresql::server']
# #   }

# #   package { 'libpq-dev':
# #     ensure => installed
# #   }
# # }
# # class { 'install_postgres': }

# # --- Memcached ----------------------------------------------------------------

# # class { 'memcached': }

# # Nokogiri dependencies.
# # package { ['libxml2', 'libxml2-dev', 'libxslt1-dev']:
# #   ensure => installed
# # }

# # --- Ruby and Rails using rbenv ---------------------------------------------------------------------

# Installs rbenv
exec { 'install_rbenv':
  command => "${as_vagrant} 'curl https://raw.githubusercontent.com/fesplugas/rbenv-installer/master/bin/rbenv-installer | bash'",
  creates => "${home}/.rbenv",
  require => Package['curl']
}

# Installing Ruby.
exec { 'install_ruby':
  command => "${as_vagrant} '${home}/.rbenv/bin/rbenv install 2.1.0'",
  creates => "${home}/.rbenv/versions/2.1.0",
  # in case the build takes a while.
  timeout => 0,
  require => Exec['install_rbenv']
}

# Set Ruby 2.1.0 as global.
exec { 'setruby_global':
  command => "${as_vagrant} '${home}/.rbenv/bin/rbenv global 2.1.0'",
  require => Exec['install_ruby']
}

# Installing rails
exec { "${as_vagrant} 'gem install rails --no-rdoc --no-ri'":
  creates => "${home}/.rbenv/shims/rails",
  timeout => 0,
  require => Exec['setruby_global']
}

# Sets the path for rbenv.
file {
  "/etc/profile.d/set_rbenv_path.sh":
  source => "/vagrant/puppet/files/set_rbenv_path.sh",
  owner => "vagrant", 
  group => "vagrant", 
  ensure => "present",
  mode => 0755;
}


# ----------using notificaton test----------------------------
# using notification
# notify { 'some-command':
#   message => 'some-command is going to be executed now'
# }

# exec { 'some-command':
#   command => 'echo hello',
# }

# Notify['some-command'] -> Exec['some-command']