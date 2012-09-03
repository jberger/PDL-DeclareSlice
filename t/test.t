use Test::More;

use PDL;
use PDL::DeclareSlice;

my $stuff = xvals(5);

ok( all( $stuff->slice("1:2") == sl $stuff(1:2) ), "Basic slice works" );

my $slice = eval 'my $pdl = zeros(5,5); sl $pdl(,(0))';
warn $@ if $@;

ok(!$@, "Eval succeeded");
isa_ok( $slice, 'PDL' );
is_deeply([$slice->dims], [5], "Eval'ed slice");

done_testing();

