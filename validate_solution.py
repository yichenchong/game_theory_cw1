from typing import List, Tuple
import numpy as np
import timeit

r = 5

# a python naive implementation of the verification algorithm
# used in quickly checking my work (very verbose and quite slow)


def choice_list_to_list_repr(choice_list: List[int]) -> np.array:
    list_repr = np.zeros(10, dtype=int)
    for i in choice_list:
        list_repr[i - 1] += 1
    return list_repr


def construct_chains(list_repr: List[int]) -> List[List[Tuple[int, int]]]:
    """
    Construct a list of tuples representing the chains in the list representation.
    :param list_repr: a list representing the number of candidates on position i for i in range(1, 11)
    :return: a list of tuples representing the chain representation (number, position)
    """
    main_chain = []
    chains = [[] for i in list_repr if i > 0]
    count = 0
    for i in range(len(list_repr)):
        if list_repr[i] > 0:
            main_chain.append((list_repr[i], i + 1))
            for j in range(len(chains)):
                if count != j:
                    chains[j].append((list_repr[i] + 1, i + 1))
                elif list_repr[i] > 1:
                    chains[j].append((list_repr[i], i + 1))
            count += 1
    chains.insert(0, main_chain)
    return chains


def chain_to_diff_list(chain: List[Tuple[int, int]]) -> Tuple[np.array, np.array]:
    x1 = chain[0][1]
    window_list = [-1, 2 * x1 - 1, 0]
    window_sum = 2 * x1 - 2
    diff_list = [window_sum]
    weight_list = [1, chain[0][0], 1]

    def slide_window(elem: int, ws: int) -> int:
        ws += elem
        ws -= window_list.pop(0)
        window_list.append(elem)
        diff_list.append(ws)
        return ws

    for i in range(1, len(chain)):
        window_sum = slide_window(chain[i][1] - chain[i - 1][1], window_sum)
        window_sum = slide_window(0, window_sum)
        weight_list.append(chain[i][0])
        weight_list.append(1)

    window_sum = slide_window(2 * (r + 1 - chain[-1][1]) - 1, window_sum)
    slide_window(-1, window_sum)
    return np.array(diff_list), np.array(weight_list)


def calc_payouts(diff_list: np.array, weight_list: np.array) -> np.array:
    return diff_list / weight_list * (diff_list != 1)


def node_payouts(diff_list: np.array, weight_list: np.array) -> np.array:
    return calc_payouts(diff_list, weight_list)[1::2]


def max_payout(diff_list: np.array, weight_list: np.array) -> float:
    print(calc_payouts(diff_list, weight_list))
    return np.max(calc_payouts(diff_list, weight_list))


if __name__ == "__main__":
    # data = choice_list_to_list_repr([2, 2, 3, 4, 5, 6, 7, 8, 9, 10])
    data = [0, 2, 0, 2, 0]
    print(data)
    start_time = timeit.default_timer()
    cc = construct_chains(data)
    t1 = timeit.default_timer() - start_time
    print(t1)
    print(cc)
    start_time = timeit.default_timer()
    dl = chain_to_diff_list(cc[0])
    t2 = timeit.default_timer() - start_time
    print(t2)
    print(dl)
    start_time = timeit.default_timer()
    cp = node_payouts(dl[0], dl[1])
    t3 = timeit.default_timer() - start_time
    print(t3)
    print(cp)
    start_time = timeit.default_timer()
    dls = [chain_to_diff_list(c) for c in cc[1:]]
    t4 = timeit.default_timer() - start_time
    print(t4)
    print(dls)
    start_time = timeit.default_timer()
    cps = [max_payout(dl[0], dl[1]) for dl in dls]
    t5 = timeit.default_timer() - start_time
    print(t5)
    print(cps)
    start_time = timeit.default_timer()
    for i in range(len(cp)):
        if cp[i] < cps[i]:
            print(f"Node {i + 1 } is not optimal. Can increase payout to {cps[i]}. Current payout is {cp[i]}.")
    t6 = timeit.default_timer() - start_time
    print(t6)
    print(t1 + t2 + t3 + t4 + t5 + t6)

