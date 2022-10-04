FROM alpine:3.15.0
SHELL ["/bin/ash", "-o", "pipefail", "-c"]
RUN apk update &&                                                             \
    apk add --no-cache python2=2.7.18-r4 py2-setuptools=44.0.0-r0             \
    libxslt=1.1.35-r0 net-tools=1.60_git20140218-r2 curl=7.80.0-r3            \
    gcompat=1.0.0-r4 sudo=1.9.8_p2-r1 git=2.34.4-r0 alpine-sdk=1.0-r1;        \
    sed '/PACKAGER=/c\PACKAGER="Vladimir Stavrinov <vstavrinov@gmail.com>"'   \
        -i /etc/abuild.conf;                                                  \
    git clone --depth 1 --branch                                              \
        v"$(awk -F= '/VERSION_ID/ {print $2}' /etc/os-release)"               \
        git://git.alpinelinux.org/aports /srv/aports;                         \
    abuild-keygen -ani; SRC="/srv/aports/main/openssl";                       \
    TEST1="test/recipes/30-test_afalg.t";                                     \
    TEST2="test/recipes/80-test_ssl_new.t";                                   \
    sed -e 's/no-ec2m//' -e 's/^pkgrel=.*/&0/' -i $SRC/APKBUILD;              \
    sed -i "s%rm -f $TEST1%&\n\trm -f $TEST2%" $SRC/APKBUILD;                 \
    cd $SRC || exit 1; abuild -F checksum; abuild -P /srv/packages -Fr;       \
    apk --no-cache add /srv/packages/main/x86_64/libcrypto1.1-*.apk;          \
    rm /srv/packages/main/x86_64/APKINDEX.tar.gz;                             \
    cp -a /srv/aports/testing/py3-apsw /srv/aports/main/py2-apsw;             \
    SRC="/srv/aports/main/py2-apsw";                                          \
    sed -e 's/py3/py2/' -e 's/python3/python2/' -e 's/^pkgrel=.*/&0/' -i      \
    $SRC/APKBUILD;                                                            \
    cd $SRC || exit 1; abuild -F checksum; abuild -P /srv/packages -Fr;       \
    apk add --no-cache -uX /srv/packages/main py2-apsw=3.36.0-r00;            \
    mkdir /srv/acestream; ACE_VERSION="3.1.74_debian_10.5_x86_64";            \
    curl https://download.acestream.media/linux/acestream_$ACE_VERSION.tar.gz|\
    tar xzf - -C /srv/acestream;                                              \
    curl https://bootstrap.pypa.io/pip/2.7/get-pip.py -o get-pip.py &&        \
    python get-pip.py && rm get-pip.py; pip install --no-cache-dir            \
    requests==2.27.1 isodate==0.6.1 pycryptodome==3.15.0;                     \
    apk del git alpine-sdk net-tools curl sudo;                               \
    rm -fr /root/.cache /srv/packages /srv/aports
