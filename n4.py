from z3 import *


s = Solver()


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

    print_all_solutions(dv)


def print_all_solutions(dv: list):
    solver = s.__deepcopy__()
    while solver.check() == sat:
        print([solver.model()[i] for i in dv])
        solver.add(Or(*[i != solver.model()[i] for i in dv]))


if __name__ == "__main__":
    main()
