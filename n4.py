from z3 import *
import pathlib
import timeit

s = Solver()

libname = pathlib.Path().absolute() / "validator/validator.so"
c_lib = ctypes.CDLL(libname)

def main():
    a, b, c, d = [Int(chr(ord('a') + i)) for i in range(4)]
    dv = [a, b, c, d]
    s.add(*[dv[i] <= dv[i + 1] for i in range(3)])
    s.add(a > 0)
    s.add(d <= 10)
    s.add(a <= 3)
    s.add(d >= 8)
    s.add(b - a < 2)
    s.add(d - c < 2)
    s.add(c - b < 6)

    map_solutions(dv, verify)


def map_solutions(dv: list, f: Function = print):
    solver = s.__deepcopy__()
    while solver.check() == sat:
        f([solver.model()[i].as_long() for i in dv])
        solver.add(Or(*[i != solver.model()[i] for i in dv]))


def verify(solution: list):
    start_time = timeit.default_timer()
    R = 10
    N = 4
    arr_type = ctypes.c_int * R
    c_lib.verify_list_repr.argtypes = [arr_type, ctypes.c_int, ctypes.c_int]
    if c_lib.verify_list_repr(arr_type(*solution), N, R):
        print(solution)
    t = timeit.default_timer() - start_time

if __name__ == "__main__":
    main()
