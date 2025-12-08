# syntax=docker/dockerfile:1
FROM python:3.10-slim AS build

LABEL org.opencontainers.image.source=https://github.com/justdan96/acestream-engine
LABEL org.opencontainers.image.licenses=GPL-3.0-only
LABEL org.opencontainers.image.description="Minimal Docker image for AceStream Engine on Linux"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
ENV BASE_URL="https://download.acestream.media/linux"
ENV ACE_VERSION="3.2.11_ubuntu_22.04_x86_64_py3.10"
ENV PYTHONDONTWRITEBYTECODE=0
ENV TMPDIR=/dev/shm

# install dependencies
ADD clean-install /usr/bin/clean-install
RUN chmod +x /usr/bin/clean-install
RUN clean-install curl unzip strace

# cleanup
RUN apt-get --assume-yes --allow-remove-essential purge aptitude bash-completion perl perl-base

RUN systemd-tmpfiles --clean ; systemd-tmpfiles --remove ; apt-get --assume-yes autoremove ; apt-get --assume-yes clean
RUN find /var/cache -type f -exec rm -rvf {} \;
RUN find /var/log -type f -exec truncate --size=0 {} \;
RUN cd /sbin && ls --hide=useradd | xargs -d '\n' rm
RUN cd /usr/bin && ls --hide=python --hide mkdir --hide pip --hide curl --hide bash --hide ln --hide ls --hide rm \
    --hide tar --hide gzip --hide unzip --hide strace --hide dirname --hide readlink | xargs -d '\n' rm

# add Acestream user and setup Acestream
RUN useradd --shell /bin/bash --home-dir /srv/ace --create-home ace
USER ace
WORKDIR /srv/ace
ADD setup.cfg .
RUN curl --progress-bar $BASE_URL/acestream_$ACE_VERSION.tar.gz | tar xzf -; \
    cd lib; unzip \*.egg; rm *.egg; cd;                                      \
    ln --symbolic /dev/shm/.ACEStream .ACEStream;                            \
    ln --symbolic /dev/shm/engine_runtime.json . ;                           \
    pip install --no-cache-dir --upgrade --requirement requirements.txt

CMD mkdir /dev/shm/.ACEStream; \
    cd /srv/ace && \
    /usr/bin/strace /bin/bash ./start-engine \
        --client-console \
        --live-cache-type memory
      