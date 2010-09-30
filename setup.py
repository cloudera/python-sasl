#!/usr/bin/env python

"""
setup.py file for SWIG example
"""

from setuptools import setup, Extension

sasl_module = Extension('_saslwrapper',
                           sources=['sasl/saslwrapper.cpp', "sasl/saslwrapper_wrap.cxx"],
                           include_dirs=["sasl"],
                           libraries=["sasl2"],
                           language="c++",
                           )

setup (name = 'sasl',
       version = '0.1',
       author      = "sasl",
       description = """sasl""",
       ext_modules = [sasl_module],
       py_modules = ["sasl.saslwrapper"],
       )

