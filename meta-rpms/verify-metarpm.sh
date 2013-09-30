#!/bin/sh

ROOT_PATH=$1
VERSION=$2

[ -z "$ROOT_PATH" ] && exit 1
[ -z "$VERSION" ] && exit 1

RPM_OPTIONS="--root=${ROOT_PATH} -q"
RPM_QUERY_FORMAT='--queryformat=%{name}=%{epoch}:%{version}-%{release}\n'

TEMP_DIR=$(mktemp -d)
rpm ${RPM_OPTIONS} -a $RPM_QUERY_FORMAT | sed 's/(none):/0:/' | sort > ${TEMP_DIR}/pkg_installed 

rpm ${RPM_OPTIONS} cernvm-system-${VERSION} ${RPM_QUERY_FORMAT} | sed 's/(none):/0:/' > ${TEMP_DIR}/pkg_expected.in_progress
rpm ${RPM_OPTIONS} cernvm-system-${VERSION} --requires | grep -v '^/' | grep -v '^rpmlib(' | tr -d " " >> ${TEMP_DIR}/pkg_expected.in_progress
sort ${TEMP_DIR}/pkg_expected.in_progress > ${TEMP_DIR}/pkg_expected

diff ${TEMP_DIR}/pkg_expected ${TEMP_DIR}/pkg_installed
RETVAL=$?

rm -rf ${TEMP_DIR}
exit $RETVAL
