#!/bin/sh

NSL_CORE="$HOME/NSL/linux/i386"

usage() {
	"$CAT"<<EOS 1>&2
usage: nc.sh -f input_file_name [other nslc.exe options]
EOS
}

CAT='/bin/cat'
DATE='/bin/date'
ECHO='/bin/echo'
MKTEMP='/usr/bin/mktemp'
RM='/bin/rm'

NSLPP="$NSL_CORE/nslpp.exe"
NSLC="$NSL_CORE/nslc.exe"

# option existence check
for a in "$@"
do
	if [ "X$lastarg" = 'X-f' ]
	then
		ifile="$a"
	fi
	lastarg="$a"
done
unset lastarg
if [ "X$ifile" = 'X' ]
then
	usage
	exit 2
fi

# file existence check
if [ -f "$ifile" ]
then
else
	"$ECHO" 'nc.sh: "'"$ifile"'" No such regular file' 1>&2
	exit 2
fi

# prepare tempfile
tmpl=`"$DATE" -u "+ncsh%Y%m%dT%H%M%SZ_$$"`
tmpfile=`"$MKTEMP" -t "$tmpl"`
unset tmpl

# remove tempfile in atexit
trap atexit EXIT
trap 'result=$?; trap - EXIT; atexit; exit "$result"' SIGHUP SIGINT SIGQUIT SIGABRT SIGALRM SIGTERM
atexit() {
	[ "X$tmpfile" != 'X' -a -f "$tmpfile" ] && "$RM" "$tmpfile"
}

# run nslpp
"$NSLPP" "$ifile" > "$tmpfile"
nslpp_stat=$?
if [ "X$nslpp_stat" != 'X0' ]
then
	exit "$nslpp_stat"
fi
unset nslpp_stat
unset ifile

# mangle args
nslcargs=''
for a in "$@"
do
	if [ "X$lastarg" = 'X-f' ]
	then
		nslcargs="$nslcargs '$tmpfile'"
	else
		nslcargs="$nslcargs '$a'"
	fi
	lastarg="$a"
done
unset lastarg
eval set - "$nslcargs"
unset nslcargs

# run nslc
"$NSLC" "$@"
nslc_stat=$?
if [ "X$nslc_stat" != 'X0' ]
then
	exit "$nslc_stat"
fi
unset nslc_stat

# successful fin
exit 0
