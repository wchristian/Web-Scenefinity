use strictures;

package Web::SimpleX::Helper::ActionWithRender;

use Sub::Exporter::Simple qw'action mm';
use Try::Tiny;
use Scalar::Util 'blessed';

sub mm {
    my @args = @_;
    unshift @args, 'GET' if ref $args[0];
    for my $match ( @args ) {
        next if ref $match;
        next if $match =~ /HEAD/;
        $match =~ s/GET/GET|HEAD/;
    }
    return sub { @args };
}

sub action {
    my ( $action, $view ) = @_;

    return sub {
        my ( $self, @args ) = @_;

        $view ||= do {
            if ( my $meth = $self->can( 'default_view' ) ) {
                $self->$meth;
            }
            else {
                'template';
            }
        };

        my $view_args = try {
            while ( ref $action and ref $action eq 'CODE' ) {
                $action = $action->( $self, $view );
            }
            $self->$action( @args );
        }
        catch {
            my $action_error = "action_error_$view";
            $self->$action_error( $_ );
        };

        my $plack_response = try {
            while ( ref $view_args and ref $view_args eq 'CODE' ) {
                $view_args = $view_args->( $self );
            }
            return $view_args->finalize if blessed( $view_args ) and $view_args->isa( "Plack::Response" );
            my $render = "render_$view";
            return $self->$render( $view_args );
        }
        catch {
            my $error_view = "view_error_$view";
            $self->$error_view( $_ );
        };

        return $plack_response;
    };
}

1;
