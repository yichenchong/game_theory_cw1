from invoke import task, Context, run
import sys


on_win = sys.platform.startswith("win")


@task
def build(c, path=None):
    """Build the shared library for the sample C code"""
    c: Context
    if on_win:
        if not path:
            print("Path is missing")
        else:
            # Using c.cd didn't work with paths that have spaces :/
            path = f'"{path}vcvars32.bat" x86'  # Enter the VS venv
            path += f'&& cd "{os.getcwd()}"'  # Change to current dir
            path += "&& cl /LD validator\\validator.c"  # Compile
            # Uncomment line below, to suppress stdout
            # path = path.replace("&&", " >nul &&") + " >nul"
            c.run(path)
    else:
        print("Building C Library")
        cmd = "gcc -c -fpic validator/**.c"
        run(cmd)
        run("gcc -shared -o validator/validator.so validator/validator.o")
        print("* Complete")
