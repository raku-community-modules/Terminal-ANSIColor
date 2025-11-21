[![Actions Status](https://github.com/raku-community-modules/Terminal-ANSIColor/actions/workflows/linux.yml/badge.svg)](https://github.com/raku-community-modules/Terminal-ANSIColor/actions) [![Actions Status](https://github.com/raku-community-modules/Terminal-ANSIColor/actions/workflows/macos.yml/badge.svg)](https://github.com/raku-community-modules/Terminal-ANSIColor/actions) [![Actions Status](https://github.com/raku-community-modules/Terminal-ANSIColor/actions/workflows/windows.yml/badge.svg)](https://github.com/raku-community-modules/Terminal-ANSIColor/actions)

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

    reset bold faint italic blink inverse conceal
    strike underline dunderline overline

    bold_off italic_off blink_off inverse_off conceal_off
    strike_off underline_off overline_off

    black red green yellow blue magenta cyan white default

    on_black on_red on_green on_yellow on_blue
    on_magenta on_cyan on_white on_default

Note a few special cases:

  * `reset`         - Turns off all other attributes/colors
  * `bold_off`      - Turns off both `bold` and `faint`
  * `underline_off` - Turns off both `underline` and `dunderline` (double underline)

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

    RESET BOLD FAINT ITALIC BLINK INVERSE CONCEAL
    STRIKE UNDERLINE DUNDERLINE OVERLINE

    BOLD_OFF ITALIC_OFF BLINK_OFF INVERSE_OFF CONCEAL_OFF
    STRIKE_OFF UNDERLINE_OFF OVERLINE_OFF

As with the equivalents used by `color()`:

  * `RESET`         - Turns off all other attributes/colors
  * `BOLD_OFF`      - Turns off both `BOLD` and `FAINT`
  * `UNDERLINE_OFF` - Turns off both `UNDERLINE` and `DUNDERLINE` (double underline)


AUTHORS
=======

  * Tadeusz “tadzik” Sośnierz

  * Elizabeth Mattijsen

  * Geoffrey Broadwell

Source can be located at: https://github.com/raku-community-modules/Terminal-ANSIColor . Comments and Pull Requests are welcome.

COPYRIGHT AND LICENSE
=====================

Copyright 2010 - 2018 Tadeusz “tadzik” Sośnierz

Copyright 2022 - 2024 Elizabeth Mattijsen

Copyright 2025 Raku Community

This library is free software; you can redistribute it and/or modify it under the MIT License.

