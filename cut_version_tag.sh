#!/usr/bin/env bash

echo "checking out master branch"
git checkout master
echo "pulling latest changes"
git pull

VERSION=`cat alphafold/version.py | grep version | grep -o "\d*\.\d*\.\d*"`
CUDA_VERSION=`cat docker/Dockerfile | grep CUDA | ggrep -oP '(?<=CUDA=)\d*(\.\d+)*'`
OS_VERSION=`cat docker/Dockerfile | grep nvidia/cuda | ggrep -oP 'ubuntu\K[0-9]+\.[0-9]+' | sed 's/^/ubuntu /' | sed 's/ /-/'`
FULL_TAG="$VERSION-cuda-$CUDA_VERSION-$OS_VERSION"

echo "current git HEAD is \"$(git log --oneline |head -1)\""
read -p "Would you like to create and push the tag ${FULL_TAG} at the current head of the master branch? (y/n)" proceed

if [[ ${proceed} == "y" ]]; then
    git tag "${$FULL_TAG}"
    git push --tags
fi