import ctypes
import pathlib

if __name__ == "__main__":
    # Load the shared library into ctypes
    libname = pathlib.Path().absolute() / "validator/validator.so"
    c_lib = ctypes.CDLL(libname)
    test_data = [0,0,2,0,0,0,0,2,0,0]
    N = 4
    R = 10
    arr_type = ctypes.c_float * R
    c_lib.verify.argtypes = [ctypes.c_float * 10, ctypes.c_int, ctypes.c_int]
    print(c_lib.verify(arr_type(*[0,0,2,0,0,0,0,2,0,0]), N, R))
