Exec { path => [ '/bin', '/sbin', '/usr/bin', '/usr/sbin' ] }

node default { 
    stage { [pre, post, last]: }
    Stage[pre] -> Stage[main] -> Stage[post] -> Stage[last]

    class {
        'base': stage => pre;
        'graphite': stage => main;  
        'carbon': stage => main;
        'carbon::memcached': stage => main;
        'elasticsearch': stage => main;
        'statsd': stage => main;
        'grafana': stage => main;
    }
}
