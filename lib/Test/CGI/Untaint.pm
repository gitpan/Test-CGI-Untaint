package Test::CGI::Untaint;

# turn on perl's safety features
use strict;
#use warnings;
use Carp qw(croak);

# use test builder
use Test::Builder;
my $Test = Test::Builder->new();

# the stuff to test
use CGI;
use CGI::Untaint;

# export the test functions
use Exporter;
use vars qw(@ISA @EXPORT @EXPORT_OK %EXPORT_TAGS $config_vars $VERSION);
@ISA         = qw( Exporter );
@EXPORT      = qw( is_extractable unextractable );
@EXPORT_OK   = qw( config_vars );
%EXPORT_TAGS = ("all" => [ @EXPORT, @EXPORT_OK ]);

# set the version
$VERSION = 1.00;

=head1 NAME

Test::CGI::Untaint - Test CGI::Untaint Local Extraction Handlers

=head1 SYNOPSIS

  use Test::More tests => 2;
  use Test::CGI::Untaint;

  # see that 'red' is extracted from 'Red'
  is_extractable("Red","red","validcolor");

  # see that validcolor fails
  unextractable("tree","validcolor");

=head1 DESCRIPTION

The B<CGI::Untaint> module can be extended with "Local Extraction
Handlers" that can be used define new ways of untainting data.

This module is designed to test these data extraction modules.  It
does this with the following two methods:

=over 4

=item is_extractable

Tests that first value passed has the second value passed extracted
from it when the local extraction handler named in the third argument
is called.  An optional name for the test may be passed in the
forth argument.  For example:

  # check that "Buffy" is extracted from "Buffy Summers" with
  # the CGI::Untaint::slayer local extraction handler
  is_extractable("Buffy Summers","Buffy", "slayer");

=cut

sub is_extractable
{
  # extract the params, have a default test name
  my ($data, $wanted, $func, $name) = @_;

  # debug info
  # { no warnings;
  # print STDERR "data   is '$data'\n";
  # print STDERR "wanted is '$wanted'\n";
  # print STDERR "func   is '$func'\n";
  # print STDERR "name   is '$name'\n";
  # }

  # default name
  $name ||= "'$data' extractable as $func";

  # create a CGI::Untaint object
  my $untaint = CGI::Untaint->new(config_vars(),
				  data => $data);

  # check that the extracted value is equal
  $Test->is_eq(
     scalar($untaint->extract("-as_$func" => "data")),
     $wanted,
     $name
  );
}

=item unextractable

Checks that nothing is extracted from the first argument passed with
the local extraction handler named in the second argument.  For
example:

  # check that nothing is extracted from "Willow Rosenberg"
  # with the CGI::Untaint::slayer local extraction handler
  unextractable("Willow Rosenberg", "slayer");

The third argument may optionally contain a name for the test.

=cut

sub unextractable
{
  # extract the params, have a default test name
  my ($data, $func, $name) = @_;

  # work out what it's called
  $name ||= "'$data' unextractable as $func";

  # create a CGI::Untaint object
  my $untaint = CGI::Untaint->new(config_vars(),
				  data => $data);

  # try extracting it
  my $result = $untaint->extract("-as_$func" => "data");
  unless($Test->ok(!defined $result, $name))
  {
    $Test->diag("expected data to unextractable, but got: ");
    $Test->diag(" '$result'");
  }
  return !$result;
}

=back

And that's that all there is to it, apart from the one function that
can be used to configure the test suite.  It's not exported by default
(though you may optionally import it if you want.)

=over 4

=item config_vars

The config_vars function is a get/set function that can be used to set
the hashref that will be passed to the creation of the CGI::Untaint
object used for testing.  For example, if you need to instruct
CGI::Untaint to use a custom prefix for your local extraction
handlers, you can do so like so:

  use Test::CGI::Untaint qw(:all);
  config_vars({ INCLUDE_PATH => "Profero" });

=cut

sub config_vars
{
  # setting?
  if (@_)
  {
    croak "Argument to 'config_vars' must be a hashref"
      unless ref $_[0] eq "HASH";
    $config_vars = shift;
  }

  # return the current value or a default value
  return $config_vars || {};
}

=back

=head1 BUGS

None known.

Bugs (and requests for new features) can be reported to the open
source development team at Profero though the CPAN RT system:
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Test-CGI-Untaint>

=head1 AUTHOR

Written By Mark Fowler E<lt>mark@twoshortplanks.comE<gt>.

Copyright Profero 2003

This program is free software; you can redistribute it
and/or modify it under the same terms as Perl itself.

=head1 SEE ALSO

L<Test::More>, L<CGI::Untaint>

=cut

1;
