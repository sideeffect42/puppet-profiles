class profiles::zookeeper {

    unless defined(Package['java']) {
        include ::java
    }

    include ::zookeeper
    include ::zookeeper::server

    Class['zookeeper'] -> Class['zookeeper::server']

}
