FROM python:3.8
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
ENV BASE_URL="https://download.acestream.media/linux"
ENV ACE_VERSION="3.1.75rc4_ubuntu_18.04_x86_64_py3.8"
RUN useradd --shell /bin/bash --home-dir /srv/ace --create-home ace
USER ace
WORKDIR /srv/ace
RUN curl --progress-bar $BASE_URL/acestream_$ACE_VERSION.tar.gz | tar xzf -;\
    pip install --no-cache-dir --upgrade --requirement requirements.txt
CMD mkdir /dev/shm/.ACEStream;                 \
    ln -s /dev/shm/.ACEStream .ACEStream;      \
    ./start-engine                             \
        --client-console                       \
        --live-cache-type memory
