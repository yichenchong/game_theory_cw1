import csv

import numpy as np


def emd(arr1: np.array, arr2: np.array):
    d = np.zeros(len(arr1) + 1)
    for i in range(len(arr1)):
        d[i + 1] = d[i] + arr1[i] - arr2[i]
    return int(np.sum(np.abs(d)))


def normalised_emd(arr1: np.array, arr2: np.array):
    return emd(arr1, arr2) / np.sum(arr1) / arr1.size


def generate_random_array(n: int, r: int, generator: np.random.Generator = np.random.default_rng(12345)) -> np.array:
    arr = np.zeros(r, dtype=int)
    for _ in range(n):
        arr[generator.integers(0, r)] += 1
    # print(arr)
    return arr


def average_normalised_emd(n: int, r: int, samples: int,
                           generator: np.random.Generator = np.random.default_rng(12345)) -> float:
    sum_emd = 0
    for _ in range(samples):
        arr1 = generate_random_array(n, r, generator=generator)
        arr2 = generate_random_array(n, r, generator=generator)
        sum_emd += normalised_emd(arr1, arr2)
    return sum_emd / samples


def diameter(arrs: np.array):
    if len(arrs) <= 1:
        return 0
    dists = np.zeros((len(arrs), len(arrs)))
    for i in range(len(arrs)):
        for j in range(i + 1, len(arrs)):
            dists[i, j] = normalised_emd(arrs[i], arrs[j])
    return np.max(dists)


def average_dist(arrs: np.array):
    if len(arrs) <= 1:
        return 0
    dists = np.zeros((len(arrs), len(arrs)))
    for i in range(len(arrs)):
        for j in range(i + 1, len(arrs)):
            dists[i, j] = normalised_emd(arrs[i], arrs[j])
    return np.sum(dists) / (len(arrs) * (len(arrs) - 1) / 2)


def list_repr_to_arr_repr(r, list_repr: list) -> np.array:
    arr_repr = np.zeros(r, dtype=int)
    for i in range(len(list_repr)):
        arr_repr[list_repr[i] - 1] += 1
    return arr_repr


def all_e():
    e = []
    for r in range(3, 10):
        e_row = []
        for n in range(3, r):
            data = []
            with open(f'data/r10equilibria/{n}.csv', newline='') as csvfile:
                spamreader = csv.reader(csvfile, delimiter=',')
                for row in spamreader:
                    data.append(list_repr_to_arr_repr(r, [int(i) for i in row]))
            e_row.append(average_dist(data))
        e.append(e_row)
    with open('data/emd/e.csv', 'w', newline='') as csvfile:
        spamwriter = csv.writer(csvfile, delimiter=',')
        for row in data:
            spamwriter.writerow(row)


def all_d():
    d = []
    for r in range(3, 10):
        d_row = [average_normalised_emd(9, 10, 10000, generator=np.random.default_rng(i)) for i in range(100)]

        d.append(d_row)


if __name__ == "__main__":
    all_d()
    all_e()

