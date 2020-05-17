# NAME

Regex::Chain - Chain multiple regexps to modify strings

# SYNOPSIS

    #!/usr/bin/env perl
    use Regex::Chain;

    my $string = "string.to.be.Formatted.2020";
    my $chain = Regex::Chain->new;
    $chain->add({
       rule => '.',
       replace => ' ',
       global => 1
    });

    $chain->add({
       rule => '(\d{4})$',
       replace => '($1)',
       expression => 1,
    });

    $chain->add({
       rule => '\b(.)',
       replace => '"\u$1"', # Note the use of double quotes
       eval => 1,
       global => 1,
    });

    print($chain->run($string)); # 'String To Be Formatted (2020)'

# AUTHOR

Christian Segundo <chn2guevara@gmail.com>.

# DISCLAIMER OF WARRANTIES

THIS PACKAGE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED
WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF
MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
