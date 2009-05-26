#!/bin/bash
#

App_MacPath="./${1}.app/Contents"

if [ `uname` == "Darwin" ] ; then
    mkdir -p ${App_MacPath}/MacOS
    ln -f ${1} ${App_MacPath}/MacOS/${1}
    if [ ! -e ${App_MacPath}/Info.plist ] ; then 
	cp ../../config/Info.plist ${App_MacPath}
	SEDCMD=s/__APPNAME__/${1}/
	sed -i "" ${SEDCMD} ${App_MacPath}/Info.plist
    fi
    ${App_MacPath}/MacOS/${1}
else
    ./${1}
fi
