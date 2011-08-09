use Test::More;

use_ok( 'PDL' );
use PDL::DeclareSlice;

my $stuff = xvals(5);

ok( all( $stuff->slice("1:2") == sl $stuff(1:2) ), "Basic slice works" );

done_testing();

