use strictures;

package Web::Scenefinity;

# VERSION

# ABSTRACT: web app to endlessly stream random demos

# COPYRIGHT

use Web::Simple;

use Web::SimpleX::Helper::ActionWithRender qw' mm action ';
use File::ShareDir::ProjectDistDir 'dist_dir';
use Text::Xslate;
use JSON 'to_json';
use YAML 'Load';
use List::Util qw( shuffle );
use Web::Scenefinity::Schema;
use File::Slurp 'read_file';

sub {
    has $_ => ( is => 'lazy' ) for qw( db config );
  }
  ->();

sub config_path {
    my $file = ".scenefinity";
    return $file if -f $file;
    my $home_dir = File::HomeDir->my_home || '';
    return "$home_dir$file" if -f "$home_dir$file";
    die "no config file found in . or ~";
}

sub _build_config { Load read_file( shift->config_path ) }

sub _build_db {
    my ( $self ) = @_;
    my $db       = $self->config->{db};
    my $schema   = Web::Scenefinity::Schema->connect( $db );
    return $schema;
}

sub dispatch_request {
    (
        "/"           => mm( action "infinity" ),
        "/youtube.js" => mm( action "youtube_js" ),
        "/more_demos" => mm( action "more_demos", "json" ),
    );
}

sub default_view { "Xslate" }

sub more_demos {
    my ( $self ) = @_;
    my @videos = $self->db->resultset( 'Video' )->rand( 10 );
    my @ids = map $_->yt_id, @videos;
    return \@ids;
}

sub infinity   { ['infinity.html'] }
sub youtube_js { ["youtube.js"] }

sub render_Xslate {
    my ( $self, $result ) = @_;
    my $content = Text::Xslate->new( path => dist_dir( "Web-Scenefinity" ) )->render( @{$result} );
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
