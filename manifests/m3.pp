group { "puppet":
  ensure => "present"
}

class { '::mysql::server':

  override_options => {
    'mysqld' => {
      'log_bin'         => 'mysql-bin',
      'server-id'       => '3',
      'bind_address'    => '192.168.30.103'
    }
  },
  users => {
    'root@192.168.30.1' => {
       ensure => 'present'
    }
  },
  grants => {
    'root@192.168.30.1' => {
       ensure => 'present',
       options => ['GRANT'],
       privileges => ['ALL'],
       table => '*.*',
       user => 'root@192.168.30.1'
    }
  }
}

$packagelist = [
  'libmysqlclient15-dev',
  'wget',
  'vim'
]

package { $packagelist:
  ensure => installed
}