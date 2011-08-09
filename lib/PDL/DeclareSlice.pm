package PDL::DeclareSlice;

use strict;
use warnings;

use Text::Balanced qw/extract_bracketed extract_variable/;

use Devel::Declare ();

my $verbose = 0;

my $keyword = 'sl';

sub import {
  my $class = shift;
  my $opts = shift;

  $verbose = $opts->{verbose} || 0;
  $keyword = defined $opts->{keyword} ? $opts->{keyword} : $keyword;

  my $caller = caller;

  Devel::Declare->setup_for(
      $caller,
      { $keyword => { const => \&parser } }
  );
  no strict 'refs';
  *{$caller.'::'.$keyword} = sub {return $_[0]};

}

sub parser {
  my $linestr = Devel::Declare::get_linestr;
  my ($before, $after) = split(/\b$keyword\b/, $linestr, 2);

  my $variable = extract_variable($after);
  my $parens = extract_bracketed($after, '()');

  unless( $parens =~ /\"/ ) {
    $parens =~ s/^\(/\(\"/;
    $parens =~ s/\)$/\"\)/;
  }

  my $final = $before . $keyword . '(' . $variable . '->slice' . $parens . ')' . $after;
  print $final if $verbose;

  Devel::Declare::set_linestr($final);
}

1;

__END__
__POD__

=head1 NAME

PDL::DeclareSlice - An alternative to L<PDL::NiceSlice> using L<Devel::Declare>.

=head1 SYNOPSIS

 use PDL
 use PDL::DeclareSlice;

 my $pdl = xvals(5);
 print sl $pdl(1:2); # prints [1 2]

=head1 DESCRIPTION

Adds a keyword (of your choosing, by default C<sl>) which triggers slicing of a PDL object. The slice spec will be enclosed in double quotes, so no quotes are needed.

=head1 PRE-ALPHA!!!

This is an early version of this module. It uses C<Devel::Declare> which while it is not a source filter still uses some deep magic which may have serious issues. You are invited to file bugs and patch. I also welcome any thoughts on how to improve it.

=head1 OPTIONS

Most of the magic in this module is performed when the module is loaded (C<use PDL::DeclareSlice>). Options may be passed at this point (or when calling the C<import> method). These options are passed as a hashref to the C<use> or C<import> (i.e., C<< use PDL::DeclareSlice {key => value} >>) method and are as follows:

=over

=item *

C<verbose> - If set to true will print (some) debug info, most importantly the post-parse resultant line of code. Defaults to false.

=item *

C<keyword> - String which will define the keyword which invokes the slice. By default this is C<sl>.

=back

=head1 SOURCE REPOSITORY

L<http://github.com/jberger/PDL-DeclareSlice>

=head1 AUTHOR

Joel Berger, E<lt>joel.a.berger@gmail.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2011 by Joel Berger

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut




