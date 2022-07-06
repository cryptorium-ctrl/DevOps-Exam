$packages = [ 'httpd', 'php', 'php-mysqlnd']

#install packages
package { $packages: }

#vhost files
file { '/etc/httpd/conf.d/vhost-app1.conf': 
    ensure => present,
    source => "/vagrant/config/vhost-app1.conf",
}

file { '/etc/httpd/conf.d/vhost-app2.conf': 
    ensure => present,
    source => "/vagrant/config/vhost-app2.conf",
}

#create directory
file { '/var/www/app1':
    ensure => 'directory',
}

file { '/var/www/app2':
    ensure => 'directory',
}

#app files rooting
file { '/var/www/app1/index.php': 
    ensure => present,
    source => "/vagrant/apps/app1/web/index.php",
}

file { '/var/www/app1/config.php': 
    ensure => present,
    source => "/vagrant/apps/app1/web/index.php",
}

file { '/var/www/app1/vote.php': 
    ensure => present,
    source => "/vagrant/apps/app1/web/vote.php",
}

file { '/var/www/app1/result.php': 
    ensure => present,
    source => "/vagrant/apps/app1/web/result.php",
}

file { '/var/www/app2/index.php': 
    ensure => present,
    source => "/vagrant/apps/app2/web/index.php",
}

file { '/var/www/app2/config.php': 
    ensure => present,
    source => "/vagrant/apps/app2/web/index.php",
}

file { '/var/www/app2/bulgaria-map.png': 
    ensure => present,
    source => "/vagrant/apps/app2/web/bulgaria-map.png",
}

#firewall config
class { 'firewall':}

firewall { '000 accept 8081/tcp': 
    action => 'accept',
    dport => 8081,
    proto => 'tcp',
}

firewall { '000 accept 8082/tcp': 
    action => 'accept',
    dport => 8082,
    proto => 'tcp',
}

#selinux to connect machines
class { selinux : 
    mode => 'permissive',
}

file_line { 'hosts-web':
    ensure => present,
    path => '/etc/hosts',
    line => '192.168.99.101 web.do2.lab web',
    match => '^192.168.99.101',  
}

file_line { 'hosts-db':
    ensure => present,
    path => '/etc/hosts',
    line => '192.168.99.102 db.do2.lab db',
    match => '^192.168.99.102',
}

#start php
service { httpd:
    ensure => running,
    enable => true,
}
