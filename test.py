from z3 import *
# import timeit
import ctypes
import pathlib
import numpy as np

s = Solver()
R = int(input("What is the value of R? "))
N = int(input("What is the value of N? "))
libname = pathlib.Path().absolute() / "validator/validator.so"
c_lib = ctypes.CDLL(libname)


def list_to_array_repr(l: list) -> list:
    arr = [0 for _ in range(0, R)]
    for i in l:
        arr[i - 1] += 1
    return arr

def ngtr_create_solution(solution: list):
    new_solution = [N // R for _ in range(0, R)]
    for num in solution:
        new_solution[num - 1] += 1
    print(new_solution)
    print()

def main():
    if N == 0:
        print([])
    elif N == 1:
        mat = np.identity(R, dtype=np.int32)
        for i in mat:
            print(list(i))
    elif N < R or (N == R and R <= 4):
        # decision variables: number of candidates at each position
        dv = [Int('dv' + str(i)) for i in range(0, N)]
        # trivial constraints
        s.add(*[i > 0 for i in dv])
        s.add(*[i <= R for i in dv])
        for i in range(0, N - 1):
            s.add(dv[i] <= dv[i + 1])

        # constraint that there aren't r // n + 1 gaps at the start or end
        s.add(dv[0] <= R // N + 1)
        s.add(R - dv[N - 1] <= R // N)
        # no gaps of twice that size in the middle either
        for i in range(1, N):
            s.add(dv[i] - dv[i - 1] <= 2 * (R // N + 1))
        # no gap between first and second or penultimate and ultimate
        s.add(dv[1] - dv[0] <= 1)
        s.add(dv[N - 1] - dv[N - 2] <= 1)
        # generate solution space and map it
        map_solutions(dv, verify)
    elif N == R:
        solutions = np.ones((4, R), dtype=np.int32)
        for i in range(4):
            if (i & 2):
                solutions[i, 0] = 0
                solutions[i, 1] = 2
            if (i & 1):
                solutions[i, -1] = 0
                solutions[i, -2] = 2
        for i in solutions:
            print(list(i))
    else:
        dv = [Int('dv' + str(i)) for i in range(0, N % R)]
        s.add(*[i > 0 for i in dv])
        s.add(*[i <= R for i in dv])
        for i in range(0, N % R - 1):
            s.add(dv[i] < dv[i + 1])
        map_solutions(dv, ngtr_create_solution)


def map_solutions(dv: list, f: Function = print):
    solver = s.__deepcopy__()
    while solver.check() == sat:
        f([solver.model()[i].as_long() for i in dv])
        solver.add(Or(*[i != solver.model()[i] for i in dv]))


def verify(solution: list):
    def arr_print(arr):
        print(str(arr)[1:-1])

    # start_time = timeit.default_timer()
    arr_type = ctypes.c_int * R
    c_lib.verify_list_repr.argtypes = [arr_type, ctypes.c_int, ctypes.c_int]
    if c_lib.verify_list_repr(arr_type(*solution), N, R):
        arr_print(solution)
        # print(list_to_array_repr(solution))
        # print()
    # t = timeit.default_timer() - start_time
    # print(t)
    # print()


def output_solutions(solutions: list):
    def arr_print(arr):
        print(str(arr)[1:-1])
    for solution in solutions:
        arr_print(solution)
        # arr_print(list_to_array_repr(solution))
        # arr_print()


if __name__ == "__main__":
    main()
