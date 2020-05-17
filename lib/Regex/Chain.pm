package Regex::Chain;

use Moo;
use strictures 2;
use namespace::clean;
use Types::Standard qw( Str ArrayRef InstanceOf Bool Any );
use Data::Dumper;
# ABSTRACT: Regex::Chain apply multiple regexps to a string

has p_regex => (
  is  => 'ro',
  isa => ArrayRef[InstanceOf['Regex::Chain::Link']],
  default  => sub { return [] },
);

has debug => (
  is => 'ro',
  isa => ArrayRef[Any],
  clearer => 1,
  lazy  => 1,
  default  => sub { return [] },
);

sub _debug {
  my $self = shift;
  push @{$self->debug}, shift;
}

sub add {
  my $self = shift;
  my $obj = shift;
  push @{$self->p_regex}, $obj;
}

sub run {
  my $self = shift;
  my $str = shift;

  $self->clear_debug;
 
  $self->_debug("String: $str");
  foreach my $rule (@{$self->p_regex}) {
    $self->_debug($rule);
    if($rule->{'expression'} || $rule->{'eval'}) { $rule->{'regexp'} = 1; }

    if (!$rule->{'regexp'} && $rule->{'global'} && $rule->{'ignorecase'}) { $str =~ s/\Q$rule->{'rule'}\E/$rule->{'replace'}/gi; }
    elsif (!$rule->{'regexp'} && !$rule->{'global'} && $rule->{'ignorecase'}) { $str =~ s/\Q$rule->{'rule'}\E/$rule->{'replace'}/i; }
    elsif (!$rule->{'regexp'} && !$rule->{'global'} && !$rule->{'ignorecase'}) { $str =~ s/\Q$rule->{'rule'}\E/$rule->{'replace'}/; }
    elsif (!$rule->{'regexp'} && $rule->{'global'} && !$rule->{'ignorecase'}) { $str =~ s/\Q$rule->{'rule'}\E/$rule->{'replace'}/g; }
    else {
        if ($rule->{'expression'}) {
           if($rule->{'global'} && $rule->{'ignorecase'}) { $str =~ s/$rule->{'rule'}/_safeval($rule->{'replace'})/egi; }
           elsif(!$rule->{'global'} && $rule->{'ignorecase'}) { $str =~ s/$rule->{'rule'}/_safeval($rule->{'replace'})/ei; }
           elsif(!$rule->{'global'} && !$rule->{'ignorecase'}) { $str =~ s/$rule->{'rule'}/_safeval($rule->{'replace'})/e; }
           elsif($rule->{'global'} && !$rule->{'ignorecase'}) { $str =~ s/$rule->{'rule'}/_safeval($rule->{'replace'})/eg; }
         }
        elsif ($rule->{'eval'}) {
           if($rule->{'global'} && $rule->{'ignorecase'}) { $str =~ s/$rule->{'rule'}/$rule->{'replace'}/eegi; }
           elsif(!$rule->{'global'} && $rule->{'ignorecase'}) { $str =~ s/$rule->{'rule'}/$rule->{'replace'}/eei; }
           elsif(!$rule->{'global'} && !$rule->{'ignorecase'}) { $str =~ s/$rule->{'rule'}/$rule->{'replace'}/ee; }
           elsif($rule->{'global'} && !$rule->{'ignorecase'}) { $str =~ s/$rule->{'rule'}/$rule->{'replace'}/eeg; }
         }

        else { $str =~ s/$rule->{'rule'}/$rule->{'replace'}/gi; }
    }
  }
  return $str;
}

sub _safeval {
        my @i = (undef,$1,$2,$3,$4,$5,$6,$7,$8,$9);
        $_[0] =~ s/\$(\d)/$i[$1]/g;
        $_[0];
}

1;

__END__

=pod

=encoding utf-8

=head1 NAME

Regex::Chain - Chain multiple regexps to modify strings

=head1 SYNOPSIS

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

=head1 AUTHOR

Christian Segundo E<lt>chn2guevara@gmail.comE<gt>.

=head1 DISCLAIMER OF WARRANTIES

THIS PACKAGE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED
WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF
MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
