# Copyright 2023 David Miller

#!/bin/sh

LAZNAM=`ls |grep lazarus`
tput setaf 2
echo
echo
echo "The lazarus version is $LAZNAM"
echo
echo 
tar --strip-components=5 -xf $LAZNAM lazarus/lcl/interfaces/qt5/cbindings/Qt5Pas.pro
echo
echo "This is the libqt5pas version available from the $LAZNAM source archive"
echo 
cat Qt5Pas.pro |grep "Binding Release Version"
echo
echo
echo "This is the actual libqt5pas library version that gets compiled"
echo
cat Qt5Pas.pro |grep "VERSION ="
echo
echo "Use the Binding release version number to edit libqt5pas.SlackBuild VERSION=${VERSION:-x.x.x}"
echo
echo
echo
tput setaf 7
echo 
rm Qt5Pas.pro
