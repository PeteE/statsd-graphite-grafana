class statsd (
    $packages = ['nodejs', 'npm', 'daemonize'],
    $install_dir = "/usr/share/statsd",
    $graphite_host = "localhost",
    $graphite_port = "2003",
    $statsd_port = "8125",
    $statsd_user = "statsd",
) {
    package { $packages:
        ensure => installed,
    }
    vcsrepo { "${install_dir}":
        ensure => present,
        provider => git,
        source => "https://github.com/etsy/statsd.git",
    }
    user { "statsd":
        ensure => present,
        comment => "StatsD user",
        shell => "/sbin/nologin",
        system => true,
        home => "${install_dir}",
        require => Vcsrepo["${install_dir}"],
    }
    file { "${install_dir}/local.js":
        ensure => file,
        owner => root,
        group => root,
        mode => 0644,
        content => template("statsd/local.js"),
        require => Vcsrepo["${install_dir}"],
    }

    file { "/etc/init.d/statsd":
        ensure => file,
        owner => root,
        group => root,
        mode => 0755,
        content => template("statsd/statsd.init"),
        require => [File["${install_dir}/local.js"], User["${statsd_user}"]],
    }
    service { "statsd":
        enable => true,
        ensure => running,
        require => [Package[$packages], File["/etc/init.d/statsd"]],
    }
}
