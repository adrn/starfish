#!/usr/bin/env python

from setuptools import setup

# Hackishly inject a constant into builtins to enable importing of the
# package before the dependencies are installed.
import builtins
builtins.__STARFISH_SETUP__ = True
import starfish

setup(
    name="starfish",
    version='0.1',
    author="Adrian Price-Whelan",
    author_email="adrianmpw@gmail.com",
    url="https://github.com/adrn/starfish",
    packages=["starfish"],
    description="Distribution function modeling.",
    long_description=open("README.md").read(),
    package_data={"": ["README.md", "LICENSE"]},
    include_package_data=True,
    install_requires=["astropy", "numpy", "matplotlib"],
)
