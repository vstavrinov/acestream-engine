FROM alpine
WORKDIR /srv/acestream
ENV COLUMNS=116
ENV ACE_VERSION="3.1.74_debian_10.5_x86_64"
RUN apk update &&                                                                      \
    apk add                                                                            \
        python2 py2-setuptools net-tools curl gcompat sudo git alpine-sdk;             \
    sed '/PACKAGER=/c\PACKAGER="Vladimir Stavrinov <vstavrinov@gmail.com>"'            \
        -i /etc/abuild.conf;                                                           \
    git clone --depth 1 --branch v$(awk -F= '/VERSION_ID/ {print $2}' /etc/os-release) \
        git://git.alpinelinux.org/aports /srv/aports;                                  \
    abuild-keygen -ani;                                                                \
    cd /srv/aports/main/openssl;                                                       \
    sed -e 's/no-ec2m//' -e 's/^pkgrel=.*/&0/' -i APKBUILD;                            \
    sed -i                                                                             \
    's%rm -f test/recipes/30-test_afalg.t%&\n\trm -f test/recipes/80-test_ssl_new.t%'  \
    APKBUILD;                                                                          \
    abuild -F checksum; abuild -P /srv/packages -Fr;                                   \
    apk add /srv/packages/main/x86_64/libcrypto1.1-*.apk;                              \
    rm /srv/packages/main/x86_64/APKINDEX.tar.gz;                                      \
    cp -a /srv/aports/testing/py3-apsw /srv/aports/main/py2-apsw;                      \
    cd /srv/aports/main/py2-apsw;                                                      \
    sed -e 's/py3/py2/' -e 's/python3/python2/' -e 's/^pkgrel=.*/&0/' -i APKBUILD;     \
    abuild -F checksum; abuild -P /srv/packages -Fr;                                   \
    apk add -uX /srv/packages/main py2-apsw; cd /srv/acestream;                        \
    curl https://download.acestream.media/linux/acestream_$ACE_VERSION.tar.gz |        \
    tar xzf -;                                                                         \
    curl https://bootstrap.pypa.io/pip/2.7/get-pip.py -o get-pip.py &&                 \
    python get-pip.py && rm get-pip.py;                                                \
    pip install requests isodate pycryptodome;                                         \
    apk del git alpine-sdk net-tools curl sudo;                                        \
    rm -fr /root/.cache /var/cache/apk/*; rm -fr /srv/packages /srv/aports;            \
    adduser -D -h /srv/acestream acestream; chown -R acestream /srv/acestream;         \
    ln -s /srv/acestream/acestreamengine /bin/acestream
