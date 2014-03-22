class graphite (
    $packages = ['graphite-web', 'httpd24'],
    $django_secret_key = '12345',
    $conf_dir = '/etc/graphite-web',
    $storage_dir = '/var/lib/graphite-web',
    $whisper_storage_dir = '/var/lig/cabon/whisper',
    $rrd_storage_dir = '/var/lib/carbon/rrd',
    $apache_user = 'apache',
    $graphite_hostname = 'graphite.example.org',
) {
    package { $packages:
        ensure => installed,
    }
    file { "${conf_dir}/local_settings.py":
        ensure => file,
        owner => root,
        group => root,
        mode => 644,
        content => template("graphite/local_settings.py"),
        require => Package[$packages],
    }
    file { "${storage_dir}/initial_data.json":
        ensure => file,
        owner => root,
        group => root,
        mode => 0600,
        replace => false,
        source => "puppet:///modules/graphite/initial_data.json",
        require => File["${conf_dir}/local_settings.py"],
    }
    exec { "create-django-db":
        cwd => "${storage_dir}",
        command => "python /usr/lib/python2.6/site-packages/graphite/manage.py syncdb --noinput",
        #creates => "${storage_dir}/graphite.db",
        require => File["${storage_dir}/initial_data.json"],
        notify => Exec["chown-django-db"],
    }
    exec { "chown-django-db":
        command => "chown apache.root ${storage_dir}/graphite.db",
        unless => "test $(stat -c %U ${storage_dir}/graphite.db) == \"${apache_user}\"",
    }
    file { "/etc/httpd/conf.d/graphite-web.conf":
        ensure => file,
        owner => root,
        group => root,
        mode => 0644,
        content => template("graphite/graphite-web.conf"),
        require => Package[$packages],
        notify => Service["httpd"],
    }
    file { "/etc/httpd/conf.d/welcome.conf":
        ensure => absent,
        notify => Service["httpd"],
    }
    service { "httpd":
        enable => true,
        ensure => running,
        require => Package[$packages],
    }
}
