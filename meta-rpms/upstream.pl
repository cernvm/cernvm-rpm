# Definition of upstream repositories

'sl' => {
  'baseurl' => {
    'el7' => {
      'x86_64' => 'http://ftp.scientificlinux.org/linux/scientific/7x/x86_64/os',
      #'x86_64' => 'http://anorien.csc.warwick.ac.uk/mirrors/scientific/7x/x86_64/os',
    }
  },
  'extras' => 0,
  'active' => 1,
},
'sldbg' => {
  'baseurl' => {
    'el7' => {
      'x86_64' => 'http://ftp.scientificlinux.org/linux/scientific/7x/archive/debuginfo/',
    },
  },
  'extras' => 0,
  'active' => 1,
},
'fastbugs' => {
  'baseurl' => {
    'el7' => {
      'x86_64' => 'http://ftp.scientificlinux.org/linux/scientific/7x/x86_64/updates/fastbugs'
      #'x86_64' => 'http://anorien.csc.warwick.ac.uk/mirrors/scientific/7x/x86_64/updates/fastbugs',
    },
  },
  'extras' => 0,
  'active' => 1,
},
'security' => {
  'baseurl' => {
    'el7' => {
      'x86_64' => 'http://ftp.scientificlinux.org/linux/scientific/7x/x86_64/updates/security',
      #'x86_64' => 'http://anorien.csc.warwick.ac.uk/mirrors/scientific/7x/x86_64/updates/security',
    },
  },
  'extras' => 0,
  'active' => 1,
},
'oslibs' => {
  'baseurl' => {
    'el7' => {
      'x86_64' => 'http://linuxsoft.cern.ch/wlcg/centos7/x86_64',
    },
  },
  'extras' => 0,
  'active' => 1,
},
'epel' => {
  'baseurl' => {
    'el7' => {
      'x86_64' => 'file:///data/yum/cernvm/mirror/7/x86_64/epel',
    },
  },
  'extras' => 0,
  'active' => 1,
},
'cvmfs' => {
  'baseurl' => {
    'el7' => {
      'x86_64' => 'http://cvmrepo.web.cern.ch/cvmrepo/yum/cvmfs-testing/EL/7/x86_64',
    },
  },
  'extras' => 0,
  'active' => 1,
},
'eos' => {
  'baseurl' => {
    'el7' => {
      #'x86_64' => 'http://storage-ci.web.cern.ch/storage-ci/eos/citrine/tag/el-7/x86_64',
      'x86_64' => 'file:///data/yum/cernvm/mirror/7/x86_64/eos',
    },
  },
  'extras' => 0,
  'active' => 1,
},
'eosdep' => {
  'baseurl' => {
    'el7' => {
      #'x86_64' => 'http://storage-ci.web.cern.ch/storage-ci/eos/citrine-depend/el-7/x86_64',
      'x86_64' => 'file:///data/yum/cernvm/mirror/7/x86_64/eosdep',
    },
  },
  'extras' => 0,
  'active' => 1,
},
'cvmextras' => {
  'baseurl' => {
    'el7' => {
      'x86_64' => 'file:///data/yum/cernvm/extras/7/x86_64',
    }
  },
  'extras' => 1,
  'active' => 1,
},
'condor' => {
  'baseurl' => {
    'el7' => {
      'x86_64' => 'https://research.cs.wisc.edu/htcondor/yum/stable/8.8/rhel7'
    },
  },
  'extras' => 0,
  'active' => 1,
},
