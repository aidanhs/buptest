set -e

[ $# != 1 ] && exit 1
valid=0

if [ "x$1" = "xsmall" ]; then
    valid=1
    count=40000
    size=$((10*1024))
fi

if [ $valid = 1 ]; then
    mkdir -p test/$1
    cd test/$1

    filecount=$(find . -name '*.tmp' | wc -l)
    # Loop through all .tmp files and check they're the correct size. The
    # complexity in the loop is in taking it in steps of a few files at a time
    # to reduce the number of calls to the stat program
    if [ $filecount -gt 0 ]; then
        echo "checking any existing files"
        filenum=0
        step=50
        files=""
        for f in *.tmp; do
            files="$files $f"
            filenum=$(($filenum+1))
            if [ $(($filenum%$step)) = 0 -o $((filecount-filenum)) -lt $step ]; then
                name=""
                for x in $(stat -c '%n %s' $files); do
                    if [ "x$name" = "x" ]; then
                        name=$x
                    else
                        if [ $x != $size ]; then
                            rm $name
                        fi
                        echo -en "$filenum/$filecount files checked"'\r'
                        name=""
                    fi
                done
                files=""
            fi
        done
    fi
    echo

    echo "creating files"
    for n in $(eval "echo {1..$count}"); do
        if [ ! -f $n.tmp ]; then
            dd if=/dev/urandom bs=$size count=1 of=$n.tmp >/dev/null 2>&1
        fi
        echo -en "$n/$count files of size $size"'\r'
    done
    echo

fi
