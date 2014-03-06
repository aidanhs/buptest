cd ../bup/lib/bup
python <<EOF
import cStringIO
import _hashsplit
cstr = cStringIO.StringIO(open("midx.py").read())
cstr.reset()
files = [open("hashsplit.py"), cstr, open("../../../buptest/test/00.rnd")]
print [(x,len(y)) for (x,y) in enumerate(_hashsplit.readfile_iter(files, None))]
EOF
