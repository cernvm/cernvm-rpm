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
