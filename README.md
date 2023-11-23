[![Actions Status](https://github.com/lizmat/Terminal-ANSIColor/actions/workflows/test.yml/badge.svg)](https://github.com/lizmat/Terminal-ANSIColor/actions)

NAME
====

Terminal::ANSIColor - Color screen output using ANSI escape sequences

SYNOPSIS
========

```raku
use Terminal::ANSIColor;

say color('bold'), "this is in bold", color('reset');
say colored('what a lovely colours!', 'underline red on_green');
say BOLD, 'good to be fat!', BOLD_OFF;
say 'ok' if colorvalid('magenta', 'on_black', 'inverse');
say '\e[36m is ', uncolor('\e36m');
say colorstrip("\e[1mThis is bold\e[0m");
```

DESCRIPTION
===========

Terminal::ANSIColor provides an interface for using colored output in terminals. The following functions are available:

color
-----

Given a string with color names, the output produced by `color()` sets the terminal output so the text printed after it will be colored as specified. The following color names are recognised:

    reset bold italic underline inverse
    bold_off italic_off underline_off inverse_off
    black red green yellow blue magenta cyan white
    default on_black on_red on_green on_yellow
    on_blue on_magenta on_cyan on_white on_default

The on_* family of colors correspond to the background colors. One or three numeric color values in the range 0..255 may also be specified:

    N     # 256-color map: 8 default + 8 bright + 216 rgb cube + 24 gray
    on_N  # Same, but background

    N,N,N     # 24-bit r,g,b foreground color
    on_N,N,N  # 24-bit r,g,b background color

colored
-------

`colored()` is similar to `color()`. It takes two Str arguments, where the first is the string to be colored, and the second is the (space-separated) colors to be used. The `reset` sequence is automagically placed after the string.

colorvalid
----------

`colorvalid()` gets an array of color specifications (like those passed to `color()`) and returns true if all of them are valid, false otherwise.

colorstrip
----------

`colorstrip`, given a string, removes all the color escape sequences in it, leaving the plain text without color effects.

uncolor
-------

Given escape sequences, `uncolor()` returns a string with readable color names. E.g. passing "\e[36;44m" will result in "cyan on_blue".

Constants
=========

`Terminal::ANSIColor` provides constants which are just strings of appropriate escape sequences. The following constants are available:

    RESET BOLD ITALIC UNDERLINE INVERSE
    BOLD_OFF ITALIC_OFF UNDERLINE_OFF INVERSE_OFF

AUTHORS
=======

Tadeusz “tadzik” Sośnierz

Elizabeth Mattijsen <liz@raku.rocks>

Source can be located at: https://github.com/tadzik/Terminal-ANSIColor . Comments and Pull Requests are welcome.

If you like this module, or what I’m doing more generally, committing to a [small sponsorship](https://github.com/sponsors/lizmat/) would mean a great deal to me!

COPYRIGHT AND LICENSE
=====================

Copyright 2010 - 2018 Tadeusz “tadzik” Sośnierz

Copyright 2022 - 2023 Elizabeth Mattijsen

This library is free software; you can redistribute it and/or modify it under the MIT License.

