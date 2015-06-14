use strictures;

package Web::Scenefinity::Import;

use HTTP::Tiny;
use Data::Dumper;
use JSON 'from_json';
use IO::All;
use IO::All::HTTP;
use XML::Twig;

use Moo;

with "Web::Scenefinity::Role::Configuration";

sub run {
    my ( $self ) = @_;

    my @ids = grep $_, map $self->$_, qw( youtube_ids );

    my $db     = $self->db;
    my $videos = $db->resultset( "Video" );
    $db->txn_do(
        sub {
            $videos->find_or_create( { yt_id => $_ } ) for @ids;
        }
    );

    return;
}

sub youtube_ids { map $_[0]->yt_ids_for_account( $_ ), $_[0]->yt_accounts }

sub yt_accounts { qw( Annikras demosceneM0d TMCrole ) } # ReclusiveLemming

sub jget { from_json io( $_[0] )->all }

sub yt_ids_for_account {
    my ( $self, $account ) = @_;
    my $base = "http://gdata.youtube.com/feeds/api/users/%s/uploads?start-index=%s&max-results=%s&alt=json";
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

sub pouet_ids {
    map $_[0]->clean_pouet( $_ ),
      map XML::Twig->parse( $_ )->get_xpath( "/feed/prod/youtube" ),
      io( "http://pouet.net/export/youtube.php" )->all;
}

sub clean_pouet {
    $_[1]->text =~ /.*\?v=([\w\-]+)$/;
    return $1;
}

1;
