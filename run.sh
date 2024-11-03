#!/bin/bash

gitconfig=~/.gitconfig*
netrc=~/.netrc
sshdir=~/.ssh
userdirectory=/home/notRoot
workingdirectory=${userdirectory}/work/rdk

flavor=dunfell

wdcli="-w ${workingdirectory}"

interactive=
if [[ -n "${INTERACTIVE_MODE+x}" ]]; then
    interactive="-it"
    wdcli=
fi

if [ ! -d ".ccache" ]; then
    echo "creating a local .ccache directory."
    mkdir -p .ccache
fi

if [ ! -d ".repo" ]; then
    echo "creating a local .repo directory."
fi

if [ ! -d "build" ]; then
    echo "creating a local build directory."
    mkdir -p build
fi

# Loop over each file matching the pattern
gitconfigvolumes=""
for file in $gitconfig; do
  # Check if the file exists to avoid errors with non-matching patterns
  if [[ -f "$file" ]]; then
    # Extract the filename from the full path
    filename=$(basename "$file")
    # Add the volume mount string to volumes
    gitconfigvolumes+="-v ${file}:${userdirectory}/${filename}:ro "
    echo "~/${filename} --> ${file} (read-only)"
  fi
done

echo "~/.netrc --> ${netrc} (read-only)"
echo "~/.ssh --> ${sshdir} (read-only)"
echo ".ccache --> ./.ccache"
echo ".repo --> ./.repo"
echo "build --> ./build"

#set -x

docker run ${interactive} --rm \
    -e USER_ID=$(id -u) -e GROUP_ID=$(id -g) \
    ${gitconfigvolumes} \
    -v ${sshdir}:/.ssh:ro \
    -v ${netrc}:${userdirectory}/.netrc:ro \
    -v ./.ccache:${workingdirectory}/.ccache \
    -v ./.repo:${workingdirectory}/.repo \
    -v ./build:${workingdirectory}/build \
    ${wdcli} \
    yocto.${flavor} \
    $@
