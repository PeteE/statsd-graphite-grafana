class carbon (
    $packages = ['python-whisper', 'python-carbon'],
    $logdir = "/var/log/carbon",
    $config = "/etc/carbon/carbon.conf",
    $storage_dir = "/var/lib/carbon/",
    $local_data_dir = "/var/lib/carbon/whisper/",
) { 
    package { $packages:
        ensure => installed,
    }
    file { "/etc/sysconfig/carbon":
        ensure => file,
        owner => root,
        group => root,
        mode => 0644,
        content => template("carbon/carbon.sysconfig"),
        require => Package[$packages],
    }
    file { "${config}":
        ensure => file,
        owner => root,
        group => root,
        mode => 0644,
        content => template("carbon/carbon.conf"),
        require => Package[$packages],
    }
    service { "carbon-cache":
        enable => true,
        ensure => running,
        require => File["${config}"],
    }
}

class carbon::memcached (
    $packages = ['memcached', 'python-memcached'],
    $maxconn = 1024,
    $cachesize = 64,
) {
    package { $packages: 
        ensure => installed,
    }
    file { "/etc/sysconfig/memcached":
        ensure => file,
        owner => root,
        group => root,
        mode => 0644,
        content => template("carbon/memcached.sysconfig"),
        require => Package[$packages],
    }
    service { "memcached":
        enable => true,
        ensure => running,
        require => File["/etc/sysconfig/memcached"],
    }
}
