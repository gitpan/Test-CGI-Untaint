#!/usr/bin/perl -w

###
# testing local extraction handler
###

package CGI::Untaint::metasyntatic;
use base qw(CGI::Untaint::object);
use strict;

# define the regex
sub _untaint_re { qr/(foo)/i };

# fool perl that we've loaded properly
# will this work on windows?
$INC{"CGI/Untaint/metasyntatic.pm"} = 1;

####
# tests
####

package main;
use strict;

use Test::Builder::Tester tests => 6;
use Test::CGI::Untaint;

# is_extractable

test_out("ok 1 - 'foo' extractable as metasyntatic");
is_extractable("foo","foo","metasyntatic");
test_test("is_extractable works");

test_out("ok 1 - custom");
is_extractable("foo","foo","metasyntatic", "custom");
test_test("is_extractable custom text");

test_out("not ok 1 - 'bar' extractable as metasyntatic");
test_fail(+3);
test_diag("         got: undef");
test_diag("    expected: 'foo'");
is_extractable("bar","foo","metasyntatic");
test_test("is_extractable fails ok");

# unextractable

test_out("ok 1 - 'bar' unextractable as metasyntatic");
unextractable("bar","metasyntatic");
test_test("unextractable works");

test_out("ok 1 - custom");
unextractable("bar","metasyntatic", "custom");
test_test("unextractable custom text");

test_out("not ok 1 - 'bar' extractable as metasyntatic");
test_fail(+3);
test_diag("         got: undef");
test_diag("    expected: 'foo'");
is_extractable("bar","foo","metasyntatic");
test_test("is_extractable fails ok");


