unit module Terminal::ANSIColor;

# these will be macros one day, yet macros can't be exported so far
my constant RESET         is export = "\e[0m";
my constant BOLD          is export = "\e[1m";
my constant FAINT         is export = "\e[2m";
my constant ITALIC        is export = "\e[3m";
my constant UNDERLINE     is export = "\e[4m";
my constant BLINK         is export = "\e[5m";
my constant INVERSE       is export = "\e[7m";
my constant CONCEAL       is export = "\e[8m";
my constant STRIKE        is export = "\e[9m";
my constant DUNDERLINE    is export = "\e[21m";
my constant BOLD_OFF      is export = "\e[22m";
my constant ITALIC_OFF    is export = "\e[23m";
my constant UNDERLINE_OFF is export = "\e[24m";
my constant BLINK_OFF     is export = "\e[25m";
my constant INVERSE_OFF   is export = "\e[27m";
my constant CONCEAL_OFF   is export = "\e[28m";
my constant STRIKE_OFF    is export = "\e[29m";
my constant OVERLINE      is export = "\e[53m";
my constant OVERLINE_OFF  is export = "\e[55m";

# legacy interface
my sub RESET()         is export { "\e[0m"  }
my sub BOLD()          is export { "\e[1m"  }
my sub FAINT()         is export { "\e[2m"  }
my sub ITALIC()        is export { "\e[3m"  }
my sub UNDERLINE()     is export { "\e[4m"  }
my sub BLINK()         is export { "\e[5m"  }
my sub INVERSE()       is export { "\e[7m"  }
my sub CONCEAL()       is export { "\e[8m"  }
my sub STRIKE()        is export { "\e[9m"  }
my sub DUNDERLINE()    is export { "\e[21m" }
my sub BOLD_OFF()      is export { "\e[22m" }
my sub ITALIC_OFF()    is export { "\e[23m" }
my sub UNDERLINE_OFF() is export { "\e[24m" }
my sub BLINK_OFF()     is export { "\e[25m" }
my sub INVERSE_OFF()   is export { "\e[27m" }
my sub CONCEAL_OFF()   is export { "\e[28m" }
my sub STRIKE_OFF()    is export { "\e[29m" }
my sub OVERLINE()      is export { "\e[53m" }
my sub OVERLINE_OFF()  is export { "\e[55m" }

my constant %attrs =
  reset         => "0",
  bold          => "1",
  faint         => "2",
  italic        => "3",
  underline     => "4",
  blink         => "5",
  inverse       => "7",
  conceal       => "8",
  strike        => "9",
  dunderline    => "21",
  bold_off      => "22",
  italic_off    => "23",
  underline_off => "24",
  blink_off     => "25",
  inverse_off   => "27",
  conceal_off   => "28",
  strike_off    => "29",
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
  on_default    => "49",
  overline      => "53",
  overline_off  => "55",
;

my constant %inverted = %attrs.kv.reverse;

my sub color(Str:D $what) is export {
    my @res;
    for $what.words -> $attr {
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

my sub colored (str $what, str $how) is export {
    color($how) ~ $what ~ RESET;
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
    @a.map({ .subst(/\e\[ <[0..9;]>+ m/, '', :g) }).join
}

my sub uncolor (Str:D $what) is export {
    my @res;
    my @list = $what.comb(/\d+/);
    while @list {
        my $elem = @list.shift;
        if %inverted{$elem} -> $inverted  {
            @res.push: $inverted
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

# vim: expandtab shiftwidth=4
