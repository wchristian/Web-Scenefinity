use strictures;

package Web::Scenefinity;

# VERSION

# ABSTRACT: web app to endlessly stream random demos

# COPYRIGHT

use Web::Simple;

use Web::SimpleX::Helper::ActionWithRender qw' mm action ';
use File::ShareDir 'module_file';
use Text::Xslate;

sub share_dir {
    eval { module_dir( __PACKAGE__ ) } || "../share/";
}

sub dispatch_request {
    ( "/" => mm( action "infinity" ) );
}

sub default_view { "Xslate" }

sub infinity {
    ['infinity'];
}

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

1;
