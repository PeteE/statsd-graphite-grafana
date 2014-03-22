Description
===========
scripts for installing statsd/graphite/grafana on an Amazon Linux AMI.

Launch/configure via Packer
==============
$ brew tap homebrew/binary
$ brew install packer

Create box
==============
#!/bin/bash
packer build \
    -debug \
    -var 'aws_access_key=your_aws_key' \
    -var 'aws_secret_key=your_aws_secret' \
    statsd.json


This will do the following:
* launch instance 
* run shell provisioner to bootstrap puppet
* run puppet to install graphite, statsd, memcache, grafana
* bundle the box as an EBS AMI which can be launched later
* creates a temporary ssh key `ec2_amazon-ebs.pem` so you can `ssh -i ec2_amazon-ebs.pem ec2-user@ip.address`

Notes
======
If you don't wnat to use packer you can launch image `ami-bba18dd`, clone the git repo, run the commands sited in the shell provisioner and run puppet with:

`puppet apply --hiera_config hiera_config.yaml --modulepath puppet/modules puppet/manifests/statsd.pp`

You'll also want to open the appropriate firewall rules:
* 80 (tcp) - httpd
* 2003 (tcp) - graphite
* 8125 (udp) - statsd
* 9200 (tcp) - elasticsearch 

By default the apache VirtualHosts are set to:
* stats.example.org -- grafana
* graphite.example.org -- graphite
These can be changed in hieradata/common.yaml

* Only tested on Amazon Linux 2013.09.2
