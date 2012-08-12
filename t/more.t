use strictures;

package more;

use Test::More;
use Test::InDistDir;

use lib 't/lib';
use TestSchema;
use Web::Scenefinity;

run();
done_testing;

sub run {
    my $schema = TestSchema->deploy_or_connect;
    $schema->prepopulate;

    my $app = Web::Scenefinity->new( db => $schema );
    my $more = $app->more_demos;
    is_deeply [ sort @{$more} ], [qw( a b c )], 'results from more_demos look useful';
    return;
}
