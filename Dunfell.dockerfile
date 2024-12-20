FROM ubuntu:18.04

# Default to root
ENV USER_ID=0
ENV GROUP_ID=0

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
    gosu \
    iputils-ping  \
    make \
    perl-doc \
    socat  \
    unzip \
    vim \
    wget \
    xterm \
    xz-utils  \
    \
    libegl1-mesa  \
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
    python3.6 \
    python3-distutils \
    python3-pip  \
    python3-pexpect  \
    python3-git  \
    python3-jinja2  \
    pylint3

# Install repo
COPY repo /usr/bin/repo
RUN chmod a+x /usr/bin/repo
RUN ln -s /usr/bin/python2.7 /usr/bin/python

# Setup the nonRoot user
RUN echo "dash dash/sh boolean false" | debconf-set-selections
RUN DEBIAN_FRONTEND=noninteractive dpkg-reconfigure dash
RUN useradd -m notRoot

RUN mkdir -p /home/notRoot/work/rdk
RUN chown -R notRoot:notRoot /home/notRoot

# Setup the libxml stuff for video
RUN su notRoot -c "cpan install XML::LibXML"

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
