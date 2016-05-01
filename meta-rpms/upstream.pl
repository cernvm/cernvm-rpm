# Definition of upstream repositories

'sl' => {
  'baseurl' => {
    'el5' => {
      'x86_64' => 'http://ftp.scientificlinux.org/linux/scientific/5x/x86_64/SL',
      'i386' => 'http://ftp.scientificlinux.org/linux/scientific/5x/i386/SL',
    },
    'el6' => {
      'x86_64' => 'http://ftp.scientificlinux.org/linux/scientific/6x/x86_64/os',
      'i386' => 'http://ftp.scientificlinux.org/linux/scientific/6x/i386/os',
    },
  },
  'extras' => 0,
  'active' => 1,
},
'fastbugs' => {
  'baseurl' => {
    'el5' => {
      'x86_64' => 'http://ftp.scientificlinux.org/linux/scientific/5x/x86_64/updates/fastbugs',
      'i386' => 'http://ftp.scientificlinux.org/linux/scientific/5x/i386/updates/fastbugs',
    },
    'el6' => {
      'x86_64' => 'http://ftp.scientificlinux.org/linux/scientific/6x/x86_64/updates/fastbugs',
      'i386' => 'http://ftp.scientificlinux.org/linux/scientific/6x/i386/updates/fastbugs',
    },
  },
  'extras' => 0,
  'active' => 1,
},
'security' => {
  'baseurl' => {
    'el5' => {
      'x86_64' => 'http://ftp.scientificlinux.org/linux/scientific/5x/x86_64/updates/security',
      'i386' => 'http://ftp.scientificlinux.org/linux/scientific/5x/i386/updates/security',
    },
    'el6' => {
      'x86_64' => 'http://ftp.scientificlinux.org/linux/scientific/6x/x86_64/updates/security',
      'i386' => 'http://ftp.scientificlinux.org/linux/scientific/6x/i386/updates/security',
    },
  },
  'extras' => 0,
  'active' => 1,
},
'slcx' => {
  'baseurl' => {
    'el5' => {
      'x86_64' => 'http://linuxsoft.cern.ch/cern/slc5X/x86_64/yum/extras',
      'i386' => 'http://linuxsoft.cern.ch/cern/slc5X/i386/yum/extras',
    },
    'el6' => {
      'x86_64' => 'http://linuxsoft.cern.ch/cern/slc6X/x86_64/yum/extras',
      'i386' => 'http://linuxsoft.cern.ch/cern/slc6X/i386/yum/extras'
    }
  },
  'extras' => 0,
  'active' => 1,
},
'oslibs' => {
  'baseurl' => {
    'el5' => {
      'x86_64' => 'http://linuxsoft.cern.ch/wlcg/sl5/x86_64',
      'i386' => 'http://linuxsoft.cern.ch/wlcg/sl5/i386',
    },
    'el6' => {
      'x86_64' => 'http://linuxsoft.cern.ch/wlcg/sl6/x86_64',
      'i386' => 'http://linuxsoft.cern.ch/wlcg/sl6/i386',
    },
  },
  'extras' => 0,
  'active' => 1,
},
'rhcommon' => {
  'baseurl' => {
    'el6' => {
      'x86_64' => 'http://linuxsoft.cern.ch/cern/rhcommon/slc6X/x86_64/yum/rhcommon',
    },
  },
  'extras' => 0,
  'active' => 0,
},
'slc_os' => {
  'baseurl' => {
    'el5' => { 
      'x86_64' => 'http://linuxsoft.cern.ch/cern/slc5X/x86_64/yum/os',
      'i386' => 'http://linuxsoft.cern.ch/cern/slc5X/i386/yum/os',
    },
    'el6' => {
      'x86_64' => 'http://linuxsoft.cern.ch/cern/slc6X/x86_64/yum/os',
      'i386' => 'http://linuxsoft.cern.ch/cern/slc6X/i386/yum/os'
    }
  },
  'extras' => 0,
  'active' => 0,
},
'slc_updates' => {
  'baseurl' => {
    'el5' => { 
      'x86_64' => 'http://linuxsoft.cern.ch/cern/slc5X/x86_64/yum/updates',
      'i386' => 'http://linuxsoft.cern.ch/cern/slc5X/i386/yum/updates',
    },
    'el6' => {
      'x86_64' => 'http://linuxsoft.cern.ch/cern/slc6X/x86_64/yum/updates',
      'i386' => 'http://linuxsoft.cern.ch/cern/slc6X/i386/yum/updates'
    }
  },
  'extras' => 0,
  'active' => 0,
},
'epel' => {
  'baseurl' => {
    'el5' => {
      'x86_64' => 'http://linuxsoft.cern.ch/epel/5/x86_64',
      'i386' => 'http://linuxsoft.cern.ch/epel/5/i386',
    },
    'el6' => {
      'x86_64' => 'http://linuxsoft.cern.ch/epel/6/x86_64',
      'i386' => 'http://linuxsoft.cern.ch/epel/6/i386',
    },
  },
  'extras' => 0,
  'active' => 1,
},
'openstack' => {
  'baseurl' => {
    'el6' => {
      'x86_64' => 'http://linuxsoft.cern.ch/rdo/rdo-x86_64-stable/RPMS.openstack-rdo-icehouse-epel-6',
    },
  },
  'extras' => 0,
  'active' => 1,
},
'cvmfs' => {
  'baseurl' => {
    'el5' => {
      'x86_64' => 'http://cvmrepo.web.cern.ch/cvmrepo/yum/cvmfs-testing/EL/5/x86_64',
      'i386' => 'http://cvmrepo.web.cern.ch/cvmrepo/yum/cvmfs-testing/EL/5/i386',
    },
    'el6' => {
      'x86_64' => 'http://cvmrepo.web.cern.ch/cvmrepo/yum/cvmfs-testing/EL/6/x86_64',
      'i386' => 'http://cvmrepo.web.cern.ch/cvmrepo/yum/cvmfs-testing/EL/6/i386',
    },
  },
  'extras' => 0,
  'active' => 1,
},
'cloudinit' => {
  'baseurl' => {
    'el6' => {
      'x86_64' => 'https://cern-cloudinit-modules.web.cern.ch/cern-cloudinit-modules',
    },
  },
  'extras' => 0,
  'active' => 1,
},
'cernai' => {
  'baseurl' => {
    'el6' => {
      'x86_64' => 'http://linuxsoft.cern.ch/internal/repos/ai6-stable/x86_64/os',
    },
  },
  'extras' => 0,
  'active' => 1,
},
'xrootd' => {
  'baseurl' => {
    'el5' => {   
      'x86_64' => 'http://xrootd.org/binaries/stable/slc/5/x86_64',
      'i386' => 'http://xrootd.org/binaries/stable/slc/5/i386',
    },
    'el6' => {
      'x86_64' => 'http://xrootd.org/binaries/stable/slc/6/x86_64',
      'i386' => 'http://xrootd.org/binaries/stable/slc/6/i386',
    },
  },
  'extras' => 0,
  'active' => 0,  # no SQlite meta data
},
'eos' => {
  'baseurl' => {
    'el5' => {
      'x86_64' => 'http://eos.cern.ch/rpms/eos-0.2/slc-5-x86_64',
      'i386' => 'http://eos.cern.ch/rpms/eos-0.2/slc-5-i386',
    },
    'el6' => {
      'x86_64' => 'http://eos.cern.ch/rpms/eos-0.2/slc-6-x86_64',
      'i386' => 'http://eos.cern.ch/rpms/eos-0.2/slc-6-i386',
    },
  },
  'extras' => 0,
  'active' => 0, # no SQlite meta data
},
'cvmextras' => {
  'baseurl' => {
    'el5' => {
      'x86_64' => 'http://cvm-storage00.cern.ch/yum/cernvm/extras/5/x86_64',
      'i386' => 'http://cvm-storage00.cern.ch/yum/cernvm/extras/5/i386',
    },
    'el6' => {
      'x86_64' => 'http://cvm-storage00.cern.ch/yum/cernvm/extras/6/x86_64',
      'i386' => 'http://cvm-storage00.cern.ch/yum/cernvm/extras/6/i386',
    },
  },
  'extras' => 1,
  'active' => 1,
},
'condor' => {
  'baseurl' => {
    'el6' => {
      'x86_64' => 'http://research.cs.wisc.edu/htcondor/yum/stable/rhel6'
    },
  },
  'extras' => 0,
  'active' => 1,
},
'afs' => {
  'baseurl' => {
    'el6' => {
      'x86_64' => 'http://www.openafs.org/dl/openafs/1.6.17/rhel6/x86_64',
    },
  },
  'extras' => 0,
  'active' => 1,
},
'devtools' => {
  'baseurl' => {
    'el6' => {
      'x86_64' => 'http://ftp.scientificlinux.org/linux/scientific/6x/external_products/devtoolset/x86_64/2',
    },
  },
  'extras' => 0,
  'active' => 1,
},
'shoal' => {
  'baseurl' => {
    'el6' => {
      'x86_64' => 'http://shoal.heprc.uvic.ca/repo/prod/sl/6X/x86_64',
    },
  },
  'extras' => 0,
  'active' => 0,
},
