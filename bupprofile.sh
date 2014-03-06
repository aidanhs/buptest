[ $# != 1 ] && exit 1
cd test
(export BUP_DIR=./.bup && rm -f ../profile$1.prof && ../../bup/bup --profile split --noop file)
