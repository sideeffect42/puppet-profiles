class profiles::omd_agent {

    class {'omdagent':
        install_xinetd => true,
        start_xinetd   => true,
    }
}
