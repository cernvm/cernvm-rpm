#!/bin/sh
set -e

OSDIR=$1
DESTDIR=$2

OSDIR=${OSDIR:=/cvmfs/cernvm-devel.cern.ch/cvm3}
DESTDIR=${DESTDIR:=/cvmfs/cernvm-devel.cern.ch/update-packs/cvm3}

inspect_script() {
  local script=$1
  if [ ! -s $script ]; then
    rm -f $script
    return 0
  fi
  if [ "x$(cat $script)" = "x/sbin/ldconfig" ]; then
    rm -f $script
    return 0
  fi
}

version=$(rpm --root $OSDIR -q cernvm-system --qf "%{version}")
tempdir=$(mktemp -d)

for dir in conflicts provides scripts.postinstall scripts.postuninstall scripts.preinstall scripts.preuninstall; do
  mkdir -p ${tempdir}/update-pack-${version}/$dir
done
basedir=$tempdir/update-pack-${version}

pushd $basedir
rpm --root $OSDIR -qa | while read; do
  pkg=$REPLY
  rpm --root $OSDIR -q $pkg --provides > $pkg
  echo "@@@" >> $pkg
  rpm --root $OSDIR -q $pkg --conflicts >> $pkg
  echo "@@@" >> $pkg
  rpm --root $OSDIR -q $pkg --qf "\#\!%{postinprog}\n%{postin}\n@@@\n\#\!%{postunprog}\n%{postun}\n@@@\n\#\!%{preinprog}\n%{prein}\n@@@\n\#\!%{preunprog}\n%{preun}\n" >> $pkg
  sed -i -e '/^\(#!\)\?(none)$\|^$/d' $pkg
  csplit --quiet --prefix=$pkg $pkg /^@@@$/ {*}
  mv ${pkg}00 provides/$pkg
  tail -n+2 ${pkg}01 > conflicts/$pkg
  suffix=2
  for script in postinstall postuninstall preinstall preuninstall; do
    tail -n+2 ${pkg}$(printf "%02d" ${suffix}) > scripts.${script}/$pkg
    inspect_script scripts.${script}/$pkg
    suffix=$((1+$suffix))
  done

  rm -f ${pkg}*
done
popd

pushd $tempdir
tar cfvz update-pack-${version}.tar.gz update-pack-${version}
mv update-pack-${version}.tar.gz ${DESTDIR}/ 
echo "version=${version}" > ${DESTDIR}/latest
echo "update-pack=update-pack-${version}.tar.gz" >> ${DESTDIR}/latest
popd
rm -rf ${tempdir}

