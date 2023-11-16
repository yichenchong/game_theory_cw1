# Game Theory Coursework 1
*Module*: MATH60141 Introduction to Game Theory\
*Department*: Department of Mathematics / Department of Computing\
*School*: Imperial College London \
*Authors*: Yi Chen Chong, Ranchen Li, and Yichang Qin

## Summary
The Election Game is a discrete variation on the classic Hotelling-Downs Model, in which $N$ politicians decide where along a (discrete) political spectrum of $R$ positions to place themselves to attract the most voters, with voters voting for the closest candidate. Other than the trivial variants, ($N = 0$ and $N = 1$), the $N = 2$ variant is also relatively simple, with politicians generally gravitating towards the one or two median positions, as expected via the median voter theorem. However, more surprising behaviours arise for $N \geq 3$. This paper describes an original method used to find all pure strategy equilibria for each $N > 0$ with the original posited $R = 10$ that theoretically carries over to all $R$ (pure strategy equilibria for all $R <= 12$ have been computed). The paper also takes a sample of and analyses the sets of pure strategy equilibria for some different values of $R$ and $N$ using the same methods.

## Contents of the Repository
### Directories
- `data` - The data generated in the coursework
- `validator` - C binding containing efficient validation algorithm
### Code Files
- `validate_solution.py`: A Python implementation of the naive algorithm, designed to be verbose, to examine individual scenarios and determine why or why not it is an equilibrium
- `tasks.py`: An `invoke` compiler for the `validator` library
- `generate_equilibria`: Script used to generate the set of equilibria for given $N, R$
- ``
- `emd.py`: An invoke compiler


## Usage of Code in Repository
*Note*: Unfortunately, not all code available is usable in Windows at the moment. The `invoke` compiler for the `validator` library, located at `tasks.py`, does not work with Windows, and `generate_equilibria.py` relies on the compiled shared object library. As such, the only way to run it on Windows is to manually compile the `validator` using a Windows version of GCC, and modify the `ctypes` line near the top of `generate_equilibria.py` to load in a Windows DLL instead.

**To complete installation of dependencies (after installing Python):**
```shell
pip install -r requirements.txt
```
**To generate the equilibria data:**
```shell
# build the validator library
invoke build
# run the generator
python generate_equilibria.py
```
*Note that the last few lines of `generate_equilibria.py` can be modified to generate equilibria for arbitrary $N$, $R$.*

**To calculate the earth mover distance data (note: requires the equilibria data to be generated):**
```shell
python emd.py
```
*Note that the `all_d` and `all_e` functions can be modified to compute and output different ranges of $N$ and $R$*
