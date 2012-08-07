use strictures;

package Web::Scenefinity;

# VERSION

# ABSTRACT: web app to endlessly stream random demos

# COPYRIGHT

use Web::Simple;

use Web::SimpleX::Helper::ActionWithRender qw' mm action ';
use File::ShareDir 'dist_dir';
use Text::Xslate;
use JSON qw' from_json to_json ';
use HTTP::Tiny;
use Data::Dumper;
use List::Util qw( shuffle );

sub share_dir {
    eval { dist_dir( "Web-Scenefinity" ) } || "../share/";
}

sub dispatch_request {
    (
        "/"           => mm( action "infinity" ),
        "/youtube.js" => mm( action "youtube_js" ),
        "/more_demos" => mm( action "more_demos", "json" ),
    );
}

sub default_view { "Xslate" }

sub jget {
    my ( $url ) = @_;
    my $res = HTTP::Tiny->new->get( $url );
    die Dumper( $res ) unless $res->{success};
    return from_json( $res->{content} );
}

sub author_all_videos {
    my ( $author ) = @_;
    my $base =
      "http://gdata.youtube.com/feeds/api/videos?author=%s&v=2&format=5&start-index=%d&max-results=%d&alt=json";
    my @videos;
    my $i = 1;
    while ( 1 ) {
        my $all = jget sprintf $base, $author, $i, 50;
        last if !$all->{feed}{entry};
        push @videos, @{ $all->{feed}{entry} };
        $i += 50;
    }
    return @videos;
}

sub more_demos {
    my @videos = author_all_videos( "Annikras" );
    @videos = shuffle @videos;
    @videos = grep $_, @videos[ 0 .. 9 ];
    my @ids = map $_->{id}{'$t'}, @videos;
    $_ =~ s/.*video:(.*)/$1/ for @ids;

    return \@ids;
}

sub infinity   { ['infinity.html'] }
sub youtube_js { ["youtube.js"] }

sub render_Xslate {
    my ( $self, $result ) = @_;
    my $content = Text::Xslate->new( path => $self->share_dir )->render( @{$result} );
    [ 200, [ "Content-Type" => "text/html; charset=utf-8" ], [$content], ];
}

sub view_error_Xslate {
    my ( $self, $error ) = @_;
    my $msg = "An error happened during rendering of the page.<br><pre>$error</pre>";
    [ 500, [ "Content-Type" => "text/html; charset=utf-8" ], [$msg], ];
}

sub render_json {
    my ( $self, $result ) = @_;
    my $content = to_json $result;
    [ 200, [ "Content-Type" => "text/html; charset=utf-8" ], [$content], ];
}

sub action_error_json { die $_[1] }

sub view_error_json {
    my ( $self, $error ) = @_;
    my $msg = "An error happened during rendering of the page.<br><pre>$error</pre>";
    [ 500, [ "Content-Type" => "text/html; charset=utf-8" ], [$msg], ];
}

1;
