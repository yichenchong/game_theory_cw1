from z3 import *

s = Solver()

# decision variables: number of candidates at each position
dv = [Int('p' + str(i)) for i in range(1, 11)]
# trivial constraint
s.add(*[i >= 0 for i in dv])


def main(n: int = 5):
    # constraint that the sum of candidates is equal to n
    s.add(sum(dv) == n)

    # constraint that there aren't 10 // n + 1 gaps at the start or end
    s.add(Or(*[dv[i] > 0 for i in range(10 // n + 1)]))
    s.add(Or(*[dv[i] > 0 for i in range(9 - 10 // n, 10)]))
    print(s.assertions())

    # generate all possible solutions
    print_all_solutions(dv)


def print_all_solutions(dv: list):
    solver = s.__deepcopy__()
    while solver.check() == sat:
        print([solver.model()[i] for i in dv])
        solver.add(Or(*[i != solver.model()[i] for i in dv]))


if __name__ == "__main__":
    main()
