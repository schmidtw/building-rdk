FROM ubuntu:20.04

RUN apt-get -y update

# Setup the locales first
RUN apt-get -y install locales
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

# Ensure non-interactive mode is configured.
RUN echo "debconf debconf/frontend select Noninteractive" | debconf-set-selections
RUN echo "apt-setup/mirror/select_internet select true" | debconf-set-selections
RUN echo "apt-setup/mirror/hostname select archive.ubuntu.com" | debconf-set-selections

RUN apt-get -y install \
    bison  \
    chrpath \
    cpio \
    curl \
    debianutils  \
    dos2unix \
    diffstat \
    gawk \
    git \
    git-core \
    git-lfs \
    iputils-ping  \
    make \
    ninja-build \
    perl-doc \
    socat  \
    unzip \
    vim \
    wget \
    xterm \
    xz-utils  \
    \
    libegl1-mesa  \
    liblz4-tool \
    libsdl1.2-dev  \
    \
    libxml2-dev \
    zlib1g-dev \
    \
    build-essential \
    \
    gcc \
    gcc-multilib  \
    \
    g++ \
    g++-multilib  \
    \
    python2.7 \
    python3.8 \
    python3-distutils \
    python3-pip  \
    python3-pexpect  \
    python3-git  \
    python3-jinja2  \
    pylint3

# Install repo
RUN curl http://commondatastorage.googleapis.com/git-repo-downloads/repo > /usr/bin/repo
RUN chmod a+x /usr/bin/repo
RUN ln -s /usr/bin/python2.7 /usr/bin/python

# Setup the nonRoot user
RUN echo "dash dash/sh boolean false" | debconf-set-selections
RUN DEBIAN_FRONTEND=noninteractive dpkg-reconfigure dash
RUN useradd -m notRoot

# Setup the libxml stuff for video
RUN cpan install XML::LibXML

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

RUN mkdir -p /root/work/rdk
