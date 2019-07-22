#!/bin/bash

if [ "$(ls -A /data/svn/)" ]; then 
	echo "svn dir not empty. skip setup"
else
	echo "svn dir empty, setting new svn repo"
	mkdir /data/svn/repos
	mkdir /data/svn/svnroot
        mkdir /data/svn/trash
	touch /data/svn/svn.access
	touch /data/svn/svn.passwd
	svnadmin create /data/svn/repos/test
	chown -R apache:apache /data/svn
	#chown -R apache:subversion /data/svn
	exit
fi

rm -rf /run/httpd/* /tmp/httpd*
