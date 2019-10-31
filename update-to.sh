#!/bin/bash

if [ $# != 1 ] ; then
        echo "usage $0 [<version>|latest]"
        exit 1
fi

VERSION=$1

if [ "$VERSION" == "latest" ] ; then        
        # update to latest version
        mkdir -p upgrade
        cd upgrade
        rm -f jenkins-cli.jar
        wget http://127.0.0.1:8080/jnlpJars/jenkins-cli.jar
        CURRENT_VERSION=$( java -jar jenkins-cli.jar -s http://127.0.0.1:8080/ version);

        # get the latest stable jenkins release 
        rm -f jenkins.war
        wget  wget http://mirrors.jenkins.io/war-stable/latest/jenkins.war
        LATEST_VERSION=$( java -jar jenkins.war --version );
        
        if [ $CURRENT_VERSION == $LATEST_VERSION ]; then
                echo "No updates available"
                exit 0
        fi

        VERSION=$LATEST_VERSION

else
        # update to specific version        
        if [ -d $VERSION ] ; then
                echo "Version already downloaded"
                exit 1
        fi
        mkdir -p upgrade
        cd upgrade
        wget http://updates.jenkins-ci.org/download/war/$VERSION/jenkins.war
        
fi

cd ..
mkdir $VERSION
mv upgrade/jenkins.war $VERSION
rm -rf upgrade


if [ ! -f $VERSION/jenkins.war ] ; then
        echo "Problem while downloading version, exiting"
        exit 1
fi

# remove and re-create symbolic link
rm jenkins.war
ln -s $VERSION/jenkins.war jenkins.war

echo "New version downloaded, now restart jenkins service"
