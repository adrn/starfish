try:
    __STARFISH_SETUP__
except NameError:
    __STARFISH_SETUP__ = False

if not __STARFISH_SETUP__:
    # __all__ = ['initial_conditions']

    from .initial_conditions import *
