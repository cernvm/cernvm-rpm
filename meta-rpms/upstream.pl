# Definition of upstream repositories

'sl' => {
  'baseurl' => {
    'el7' => {
      'aarch64' => 'http://mirror.centos.org/altarch/7/os/aarch64',
    }
  },
  'extras' => 0,
  'active' => 1,
},
'sldbg' => {
  'baseurl' => {
    'el7' => {
      'aarch64' => 'http://debuginfo.centos.org/7/aarch64',
    },
  },
  'extras' => 0,
  'active' => 1,
},
'cvmfs' => {
  'baseurl' => {
    'el7' => {
      'aarch64' => 'http://cvmrepo.web.cern.ch/cvmrepo/yum/cvmfs-testing/EL/7/aarch64',
    },
  },
  'extras' => 0,
  'active' => 1,
},
'cvmextras' => {
  'baseurl' => {
    'el7' => {
      'aarch64' => 'http://localhost/data/yum/cernvm/extras/7/aarch64',
    }
  },
  'extras' => 1,
  'active' => 1,
},
