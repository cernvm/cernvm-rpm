#!/bin/sh

cat << EOF
RPMS_DIR = .
CURL = wget
CURLFLAGS =

all: all-rpms
EOF

while read;
do
  if [ "x$REPLY" != "x_EXTRAS_" ]; then
    url=$REPLY
    rpm=$(basename $url)
    RPMS="$RPMS \$(RPMS_DIR)/$rpm"
    cat << EOF
\$(RPMS_DIR)/$rpm:
	\$(CURL) \$(CURLFLAGS) -O \$(RPMS_DIR)/${rpm}~ $url
	rpm -K --nosignature \$(RPMS_DIR)/${rpm}~
	mv \$(RPMS_DIR)/${rpm}~ \$(RPMS_DIR)/$rpm
EOF
  fi
done
echo "all-rpms: $RPMS"
