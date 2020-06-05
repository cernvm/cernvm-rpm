# Definition of upstream repositories

'sl' => {
  'baseurl' => {
    'el6' => {
      'i686' => 'http://ftp.scientificlinux.org/linux/scientific/6x/i386/os',
    },
  },
  'extras' => 0,
  'active' => 1,
},
'fastbugs' => {
  'baseurl' => {
    'el6' => {
      'i686' => 'http://ftp.scientificlinux.org/linux/scientific/6x/i386/updates/fastbugs',
    },
  },
  'extras' => 0,
  'active' => 1,
},
'security' => {
  'baseurl' => {
    'el6' => {
      'i686' => 'http://ftp.scientificlinux.org/linux/scientific/6x/i386/updates/security',
    },
  },
  'extras' => 0,
  'active' => 1,
},
'slcx' => {
  'baseurl' => {
    'el6' => {
      'i686' => 'http://linuxsoft.cern.ch/cern/slc6X/i386/yum/extras'
    }
  },
  'extras' => 0,
  'active' => 1,
},
'rhcommon' => {
  'baseurl' => {
    'el6' => {
      'i686' => 'http://linuxsoft.cern.ch/cern/rhcommon/slc6X/i386/yum/rhcommon',
    },
  },
  'extras' => 0,
  'active' => 0,
},
'slc_os' => {
  'baseurl' => {
    'el6' => {
      'i686' => 'http://linuxsoft.cern.ch/cern/slc6X/i686/yum/os'
    }
  },
  'extras' => 0,
  'active' => 0,
},
'slc_updates' => {
  'baseurl' => {
    'el6' => {
      'i686' => 'http://linuxsoft.cern.ch/cern/slc6X/i386/yum/updates'
    }
  },
  'extras' => 0,
  'active' => 0,
},
'epel' => {
  'baseurl' => {
    'el6' => {
      'i686' => 'http://linuxsoft.cern.ch/epel/6/i386',
    },
  },
  'extras' => 0,
  'active' => 1,
},
'openstack' => {
  'baseurl' => {
    'el6' => {
      'i686' => 'http://linuxsoft.cern.ch/internal/repos/iaas6-icehouse-stable/i386/os',
    },
  },
  'extras' => 0,
  'active' => 1,
},
'cvmfs' => {
  'baseurl' => {
    'el6' => {
      'i686' => 'http://cvmrepo.web.cern.ch/cvmrepo/yum/cvmfs-testing/EL/6/i386',
    },
  },
  'extras' => 0,
  'active' => 1,
},
'cloudinit' => {
  'baseurl' => {
    'el6' => {
      'i686' => 'https://cern-cloudinit-modules.web.cern.ch/cern-cloudinit-modules',
    },
  },
  'extras' => 0,
  'active' => 1,
},
'xrootd' => {
  'baseurl' => {
    'el6' => {
      'i686' => 'http://xrootd.org/binaries/stable/slc/6/i386',
    },
  },
  'extras' => 0,
  'active' => 0,  # no SQlite meta data
},
'eos' => {
  'baseurl' => {
    'el6' => {
      'i686' => 'http://eos.cern.ch/rpms/eos-0.2/slc-6-i386',
    },
  },
  'extras' => 0,
  'active' => 0, # no SQlite meta data
},
'cvmextras' => {
  'baseurl' => {
    'el6' => {
      'i686' => 'http://localhost/data/yum/cernvm/extras/6/i686',
    },
  },
  'extras' => 1,
  'active' => 1,
},
'condor' => {
  'baseurl' => {
    'el6' => {
      'i686' => 'http://research.cs.wisc.edu/htcondor/yum/stable/rhel6'
    },
  },
  'extras' => 0,
  'active' => 1,
},
