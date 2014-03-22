class base (
    $packages = ['git', 'emacs'],
) {
    package { $packages:
        ensure => installed,
    }
}
