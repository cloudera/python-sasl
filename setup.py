#!/usr/bin/env python

"""
setup.py file for SWIG example
"""

from distutils.core import setup, Extension


sasl_module = Extension('_saslwrapper',
                           sources=['sasl/saslwrapper.cpp', "sasl/saslwrapper.i"],
                           swig_opts=["-c++"],
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
       # Necessary to workaround a distutils bug in earlier pythons:
       # http://mail.python.org/pipermail/distutils-sig/2005-November/005387.html
       options = { 'build_ext': {'swig_opts':'-c++'} }
       )

