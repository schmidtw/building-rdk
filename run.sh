#!/bin/bash

gitconfig=~/.gitconfig
gitconfigrdk=~/.gitconfig-rdk
netrc=~/.netrc
sshdir=~/.ssh

flavor=dunfell

if [ -d ".ccache" ]; then
    echo ".ccache directory exists locally, using it."
else
    echo "creating .ccache directory."
    mkdir -p .ccache
fi

if [ -d ".repo" ]; then
    echo ".repo directory exists locally, using it."
else
    echo "creating .repo directory."
fi

if [ -d "build" ]; then
    echo "build directory exists locally, using it."
else
    echo "creating build directory."
    mkdir -p build
fi

echo "Using ${gitconfig} for .gitconfig file."
echo "Using ${netrc} for .netrc file."
echo "Using ${sshdir} for the .ssh dir."

#
#docker run -ti \
#    -v ${gitconfig}:/root/.gitconfig \
#    -v ${netrc}:/root/.netrc \
#    -v ${sshdir}:/root/.ssh \
#    -v ./build:/root/build \
#    -v ./.ccache:/root/.ccache \
#    --rm yocto.${flavor} /bin/bash

docker run --rm \
    -v /run/user/$(id -u)/ssh-auth.sock:/ssh-auth.sock \
    -v ${gitconfig}:/root/.gitconfig:ro \
    -v ${gitconfigrdk}:/root/.gitconfig-rdk:ro \
    -v ${netrc}:/root/.netrc:ro \
    -v ${sshdir}:/.ssh:ro \
    -v ./.ccache:/root/.ccache \
    -v ./.repo:/root/.repo \
    -e SSH_AUTH_SOCK=/ssh-auth.sock \
    -v ./build:/root/build \
    -w /root/work/rdk \
    yocto.${flavor} \
    $@
