from multiprocessing import Process, Lock
from multiprocessing.sharedctypes import Value, Array, RawArray
from ctypes import Structure, c_double, c_char, sizeof

class Point(Structure):
    _fields_ = [('x', c_double), ('y', c_double)]

def modify(n, x, s, A, C, Cn, f):
    n.value **= 2
    x.value **= 2
    s.value = s.value.upper()
    for a in A:
        a.x **= 2
        a.y **= 2
    abc = open('rand').readinto(C)
    Cn.value = abc
    print f.read()

if __name__ == '__main__':
    lock = Lock()

    n = Value('i', 7)
    x = Value(c_double, 1.0/3.0, lock=False)
    s = Array('c', 'hello world', lock=lock)
    A = Array(Point, [(1.875,-6.25), (-5.75,2.0), (2.375,9.5)], lock=lock)
    C = RawArray(c_char, 512)
    Cn = Value('i', 0)
    f = open('rand')

    p = Process(target=modify, args=(n, x, s, A, C, Cn, f))
    p.start()
    p.join()

    print n.value
    print x.value
    print s.value
    print [(a.x, a.y) for a in A]
    print sizeof(C), len(C.value), repr(C.raw)
    print Cn.value
