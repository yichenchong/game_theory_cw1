import ctypes
import pathlib

if __name__ == "__main__":
    # Load the shared library into ctypes
    libname = pathlib.Path().absolute() / "validator/libcmult.dll"
    c_lib = ctypes.WinDLL(libname)