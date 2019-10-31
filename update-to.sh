#!/bin/bash

if [ $# != 1 ] ; then
        echo "usage $0 <version>"
        exit 1
fi

VERSION=$1

if [ -d $VERSION ] ; then
        echo "Version already downloaded"
        exit 1
fi

mkdir $1
cd $1
wget http://updates.jenkins-ci.org/download/war/$VERSION/jenkins.war
cd ..

if [ ! -f $VERSION/jenkins.war ] ; then
        echo "Problem while downloading version, exiting"
        exit 1
fi

rm jenkins.war
ln -s $VERSION/jenkins.war jenkins.war

echo "New version downloaded, now restart jenkins service"
