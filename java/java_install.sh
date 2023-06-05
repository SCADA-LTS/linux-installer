#!/bin/bash
export JAVA_HOME="$1/jdk"
export JAVA_BIN_HOME="$JAVA_HOME/bin"

export JAVA_VERSION_ENCODED="11.0.19%2B7"
export JAVA_VERSION="11.0.19_7"
export JDK_DEST="jdk-11.0.19+7"

export JDK_TAR_GZ_FILE="OpenJDK11U-jdk_x64_linux_hotspot_"$JAVA_VERSION".tar.gz"

if [ ! -d "$JAVA_BIN_HOME" ]; then
    cd "$JAVA_HOME"
    wget https://github.com/adoptium/temurin11-binaries/releases/download/jdk-$JAVA_VERSION_ENCODED/$JDK_TAR_GZ_FILE
    tar -xvf $JDK_TAR_GZ_FILE -C "$JAVA_HOME"
    cd "$JAVA_HOME/$JDK_DEST"
    mv * "$JAVA_HOME"
    cd ..
    rm -rf $JDK_DEST
    rm -f $JDK_TAR_GZ_FILE
fi

