unit module Terminal::ANSIColor;

# these will be macros one day, yet macros can't be exported so far
my constant RESET         is export = "\e[0m";
my constant BOLD          is export = "\e[1m";
my constant ITALIC        is export = "\e[3m";
my constant UNDERLINE     is export = "\e[4m";
my constant INVERSE       is export = "\e[7m";
my constant BOLD_OFF      is export = "\e[22m";
my constant ITALIC_OFF    is export = "\e[23m";
my constant UNDERLINE_OFF is export = "\e[24m";
my constant INVERSE_OFF   is export = "\e[27m";

# legacy interface
my sub RESET()         is export { "\e[0m"  }
my sub BOLD()          is export { "\e[1m"  }
my sub ITALIC()        is export { "\e[3m"  }
my sub UNDERLINE()     is export { "\e[4m"  }
my sub INVERSE()       is export { "\e[7m"  }
my sub BOLD_OFF()      is export { "\e[22m" }
my sub ITALIC_OFF()    is export { "\e[23m" }
my sub UNDERLINE_OFF() is export { "\e[24m" }
my sub INVERSE_OFF()   is export { "\e[27m" }

my constant %attrs =
  reset         => "0",
  bold          => "1",
  italic        => "3",
  underline     => "4",
  inverse       => "7",
  bold_off      => "22",
  italic_off    => "23",
  underline_off => "24",
  inverse_off   => "27",
  black         => "30",
  red           => "31",
  green         => "32",
  yellow        => "33",
  blue          => "34",
  magenta       => "35",
  cyan          => "36",
  white         => "37",
  default       => "39",
  on_black      => "40",
  on_red        => "41",
  on_green      => "42",
  on_yellow     => "43",
  on_blue       => "44",
  on_magenta    => "45",
  on_cyan       => "46",
  on_white      => "47",
  on_default    => "49";

my sub color(Str $what) is export {
    my @res;
    my @a = $what.words;
    for @a -> $attr {
        if %attrs.EXISTS-KEY($attr) {
            @res.push: %attrs.AT-KEY($attr);
        }
        elsif $attr ~~ /^ ('on_'?) (\d+ [ ',' \d+ ',' \d+ ]?) $/ {
            @res.push: ~$0 ?? '48' !! '38';
            my @nums = $1.split(',');
            die("Invalid color value $_") unless +$_ <= 255 for @nums;
            @res.push: @nums == 3 ?? '2' !! '5';
            @res.append: @nums;
        }
        else {
            die("Invalid attribute name '$attr'")
        }
    }
    "\e[" ~ @res.join(';') ~ "m"
}

my sub colored (Str $what, Str $how) is export {
    color($how) ~ $what ~ color('reset');
}

my sub colorvalid (*@a) is export {
    for @a -> $el {
        return False
          unless %attrs{$el}:exists
            || $el ~~ /^ 'on_'? (\d+ [ ',' \d+ ',' \d+ ]?) $/
                 && all($0.split(',')) <= 255;
    }
    True
}

my sub colorstrip (*@a) is export {
    my @res;
    for @a -> $str {
        @res.push: $str.subst(/\e\[ <[0..9;]>+ m/, '', :g);
    }
    @res.join
}

my sub uncolor (Str $what) is export {
    my @res;
    my @list = $what.comb(/\d+/);
    my %inv = %attrs.invert;
    while @list {
        my $elem = @list.shift;
        if %inv{$elem}:exists {
            @res.push: %inv{$elem}
        }
        elsif $elem eq '38'|'48' {
            my $type = @list.shift;
            die("Bad extended color type $type") unless $type eq '5'|'2';
            my @nums = @list.splice(0, $type eq '5' ?? 1 !! 3);
            die("Invalid color value $_") unless +$_ <= 255 for @nums;
            @res.push: ('on_' if $elem eq '48') ~ @nums.join(',')
        }
        else {
            die("Bad escape sequence: {'\e[' ~ $elem ~ 'm'}")
        }
    }
    @res.join(' ')
}

=begin pod

=head1 NAME

Terminal::ANSIColor - Color screen output using ANSI escape sequences

=head1 SYNOPSIS

=begin code :lang<raku>

use Terminal::ANSIColor;

say color('bold'), "this is in bold", color('reset');
say colored('what a lovely colours!', 'underline red on_green');
say BOLD, 'good to be fat!', BOLD_OFF;
say 'ok' if colorvalid('magenta', 'on_black', 'inverse');
say '\e[36m is ', uncolor('\e36m');
say colorstrip("\e[1mThis is bold\e[0m");

=end code

=head1 DESCRIPTION

Terminal::ANSIColor provides an interface for using colored output
in terminals. The following functions are available:

=head2 color

Given a string with color names, the output produced by C<color()>
sets the terminal output so the text printed after it will be colored
as specified. The following color names are recognised:

    reset bold italic underline inverse
    bold_off italic_off underline_off inverse_off
    black red green yellow blue magenta cyan white
    default on_black on_red on_green on_yellow
    on_blue on_magenta on_cyan on_white on_default

The on_* family of colors correspond to the background colors.    One or
three numeric color values in the range 0..255 may also be specified:

    N     # 256-color map: 8 default + 8 bright + 216 rgb cube + 24 gray
    on_N  # Same, but background

    N,N,N     # 24-bit r,g,b foreground color
    on_N,N,N  # 24-bit r,g,b background color

=head2 colored

C<colored()> is similar to C<color()>. It takes two Str arguments,
where the first is the string to be colored, and the second is the
(space-separated) colors to be used. The C<reset> sequence is
automagically placed after the string.

=head2 colorvalid

C<colorvalid()> gets an array of color specifications (like those
passed to C<color()>) and returns true if all of them are valid,
false otherwise.

=head2 colorstrip

C<colorstrip>, given a string, removes all the color escape sequences
in it, leaving the plain text without color effects.

=head2 uncolor

Given escape sequences, C<uncolor()> returns a string with readable
color names. E.g. passing "\e[36;44m" will result in "cyan on_blue".

=head1 Constants

C<Terminal::ANSIColor> provides constants which are just strings of
appropriate escape sequences. The following constants are available:

    RESET BOLD ITALIC UNDERLINE INVERSE
    BOLD_OFF ITALIC_OFF UNDERLINE_OFF INVERSE_OFF

=head1 AUTHORS

Tadeusz “tadzik” Sośnierz

Elizabeth Mattijsen <liz@raku.rocks>

Source can be located at: https://github.com/tadzik/Terminal-ANSIColor .
Comments and Pull Requests are welcome.

If you like this module, or what I’m doing more generally, committing to a
L<small sponsorship|https://github.com/sponsors/lizmat/>  would mean a great
deal to me!

=head1 COPYRIGHT AND LICENSE

Copyright 2010 - 2018 Tadeusz “tadzik” Sośnierz

Copyright 2022 - 2023 Elizabeth Mattijsen

This library is free software; you can redistribute it and/or modify it under the MIT License.

=end pod

# vim: expandtab shiftwidth=4
