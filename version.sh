#!/bin/sh
git_commit_id=`git show | head -n 1 | cut -d' ' -f2`
HEADER_CODE="
const NSString *ntlniph_version = @\"$git_commit_id\";
"
echo $HEADER_CODE > Classes/version.h

