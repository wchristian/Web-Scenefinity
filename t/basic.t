use strictures;

package basic_test;

use Test::InDistDir;
use Test::More;

use Web::Scenefinity;

run();
done_testing;
exit;

sub run {
    ok( 1, "loads" );
    return;
}
