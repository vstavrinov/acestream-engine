FROM python:3.10
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
ENV BASE_URL="https://download.acestream.media/linux"
ENV ACE_VERSION="3.2.3_ubuntu_22.04_x86_64_py3.10"
ENV PYTHONDONTWRITEBYTECODE=0
RUN useradd --shell /bin/bash --home-dir /srv/ace --create-home ace
USER ace
WORKDIR /srv/ace
ADD setup.cfg .
RUN curl --progress-bar $BASE_URL/acestream_$ACE_VERSION.tar.gz | tar xzf -; \
    cd lib; unzip \*.egg; rm *.egg; cd;                                      \
    ln -s /dev/shm/.ACEStream .ACEStream;                                    \
    pip install --no-cache-dir --upgrade --requirement requirements.txt
CMD mkdir /dev/shm/.ACEStream; \
    ./start-engine             \
        --client-console       \
        --live-cache-type memory
