use strictures;

package Web::Scenefinity::Import;

use HTTP::Tiny;
use Data::Dumper;
use JSON 'from_json';

use Moo;

with "Web::Scenefinity::Role::Configuration";

sub run {
    my ( $self ) = @_;

    my @ids = map $self->yt_ids_for_account( $_ ), $self->yt_accounts;

    my $db     = $self->db;
    my $videos = $db->resultset( "Video" );
    $db->txn_do(
        sub {
            $videos->find_or_create( { yt_id => $_ } ) for @ids;
        }
    );

    return;
}

sub yt_accounts { qw( Annikras demosceneM0d TMCrole ReclusiveLemming ) }

sub jget {
    my ( $url ) = @_;
    my $res = HTTP::Tiny->new->get( $url );
    die Dumper( $res ) unless $res->{success};
    return from_json( $res->{content} );
}

sub yt_ids_for_account {
    my ( $self, $account ) = @_;
    my $base = "http://gdata.youtube.com/feeds/api/users/%s/uploads?start-index=1&max-results=50&alt=json";
    my @videos;
    my $i = 1;
    while ( 1 ) {
        my $all = jget sprintf $base, $account, $i, 50;
        my $entries = $all->{feed}{entry};
        last if !$entries or !@{$entries};
        push @videos, @{$entries};
        $i += 50;
    }
    my @ids = map $_->{id}{'$t'}, @videos;
    $_ =~ s/.*\/([\w\-]+)$/$1/ for @ids;
    return @ids;
}

1;
