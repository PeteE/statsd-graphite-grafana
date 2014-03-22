class elasticsearch (
    $java_package = 'java-1.7.0-openjdk',
    $elasticsearch_rpm_download_uri = 'https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.0.1.noarch.rpm',
) {
    package { "${java_package}":
        ensure => installed,
        notify => Exec["update-java-alternatives"],
    }

    exec { "update-java-alternatives":
        command => "update-alternatives --set java /usr/lib/jvm/jre-1.7.0-openjdk.x86_64/bin/java",
        refreshonly => true,
    }

    file { "/opt/packages":
        ensure => directory,
        owner => root,
        group => root,
        mode => 0755,
    }

    exec { "download-elasticsearch":
        command => "wget -O /opt/packages/elasticsearch.rpm ${elasticsearch_rpm_download_uri}",
        creates => "/opt/packages/elasticsearch.rpm",
        require => File["/opt/packages"],
    }

    package { "elasticsearch":
        ensure => installed,
        provider => rpm,
        source => "/opt/packages/elasticsearch.rpm",
        require => [Package["${java_package}"], Exec["download-elasticsearch"]],
    }

    service { "elasticsearch":
        enable => true,
        ensure => running,
        require => Package["elasticsearch"],
    }
}
