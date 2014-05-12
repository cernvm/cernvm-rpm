# Definition of upstream repositories

'sl' => {
  'baseurl' => {
    'el4' => {
      'x86_64' => 'http://cvm-storage00/yum/sl4/os/x86_64/RPMS', 
      'i386' => 'http://cvm-storage00/yum/sl4/os/i386/RPMS',
    },
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
    'el4' => {
      'x86_64' => 'http://cvm-storage00/yum/sl4/fastbugs/x86_64',
      'i386' => 'http://cvm-storage00/yum/sl4/fastbugs/i386',
    },
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
'epel' => {
  'baseurl' => {
    'el4' => {
      'i386' => 'http://cvm-storage00.cern.ch/yum/sl4/epel/i386',
    },
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
'cvmfs' => {
  'baseurl' => {
    'el4' => {
      'i386' => 'http://cvmrepo.web.cern.ch/cvmrepo/yum/cvmfs-testing/EL/4/i386',
    },
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
'cvmextras' => {
  'baseurl' => {
    'el4' => {
      'x86_64' => 'htp://cvm-storage00.cern.ch/yum/cernvm/extras/4/x86_64',
      'i386' => 'http://cvm-storage00.cern.ch/yum/cernvm/extras/4/i386',
    },
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
