from setuptools import setup, Extension

sfc_module = Extension('validator', sources = ['validator.c'])

setup(
    name='validator',
    version='1.0',
    description='Package to validate a given function',
    ext_modules=[sfc_module]
)