#!/bin/bash

gitconfig=~/.gitconfig
netrc=~/.netrc
sshdir=~/.ssh

flavor=dunfell

if [ -d ".ccache" ]; then
    echo ".ccache directory exists locally, using it."
else
    echo "creating .ccache directory."
    mkdir -p .ccache
fi

if [ -d "build" ]; then
    echo "build directory exists locally, using it."
else
    echo "creating build directory."
    mkdir -p build
fi

echo "Using ${gitconfig} for .gitconfig file."
echo "Using ${netrc} for .netrc file."
echo "Using ${sshdir} for .ssh directory."

docker run -ti \
    -v ${gitconfig}:/root/.gitconfig \
    -v ${netrc}:/root/.netrc \
    -v ${sshdir}:/root/.ssh \
    -v ./build:/root/build \
    -v ./.ccache:/root/.ccache \
    --rm yocto.${flavor} /bin/bash
