#!/bin/sh

verbose=false
while test $# -gt 0
do
    case "$1" in
        --verbose) verbose=true
            ;;
        -v) verbose=true
            ;;
        *) filename=`pwd`/$1
            ;;
    esac
    shift
done

if [ -z "$filename" ]; then
  echo "Missing jar file"
  exit 1
fi

trap cleanup INT

function cleanup() {
  rm -rf _tempJarDebugTest
}


mkdir _tempJarDebugTest 2>/dev/null
cd _tempJarDebugTest
unzip $filename >/dev/null

classes=(`find . -name "*.class"`)

num=0
for class in ${classes[@]}; do
    tmp=`javap -l $class | grep line | wc -l | tr -d ' '`
    num=$(($num+$tmp))
    if [ $verbose == "true" ]; then
      echo "File: $class number of lines: $num"
    fi
done

if [ $num -eq 0 ]; then
  echo "Without Debug Informations"
else
  echo "Debug Information found!"
fi
cd ..
cleanup

