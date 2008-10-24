#!/bin/sh
svn_revision=`svn info 2> /dev/null | grep Revision | cut -d' ' -f2`
HEADER_CODE="
const NSString *ntlniph_version = @\"r$svn_revision\";
"
echo $HEADER_CODE > Classes/version.h

