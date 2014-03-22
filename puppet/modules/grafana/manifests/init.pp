class grafana (
    $install_dir = "/usr/share/grafana",
    $graphite_hostname = "graphite.example.org",
    $grafana_uri = "stats.example.org", 
) {
    vcsrepo { "${install_dir}":
        ensure => present,
        provider => git,
        source => "https://github.com/torkelo/grafana.git",
    }
    file { "${install_dir}/src/config.js":
        ensure => file,
        owner => root,
        group => root,
        mode => 0644,
        content => template("grafana/config.js"),
        require => Vcsrepo["${install_dir}"],
    }
}
