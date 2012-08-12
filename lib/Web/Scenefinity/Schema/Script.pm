use strictures;

package Web::Scenefinity::Schema::Script;

use Web::Scenefinity::Schema;
use DBIx::Class::DeploymentHandler;
use File::ShareDir::ProjectDistDir 'dist_dir';

use Moose;
use MooseX::AttributeShortcuts;

with 'MooseX::Getopt';

has connection_name => (
    traits      => ['Getopt'],
    is          => 'ro',
    isa         => 'Str',
    required    => 1,
    cmd_aliases => 'c',
    default     => sub { 'development' },
);

has force => (
    is      => 'ro',
    isa     => 'Bool',
    default => sub { 0 }
);

has _dh => ( is => 'lazy' );

sub _build__dh {
    my ( $self ) = @_;
    my $args = {
        schema           => Web::Scenefinity::Schema->connect( $self->connection_name ),
        force_overwrite  => $self->force,
        script_directory => dist_dir( "Web-Scenefinity" ) . '/ddl',
        databases        => [ 'PostgreSQL', 'SQLite', 'MySQL' ],
    };
    DBIx::Class::DeploymentHandler->new( $args );
}

sub cmd_write_ddl {
    my ( $self ) = @_;
    $self->_dh->prepare_install;
    my $v = $self->_dh->schema_version;
    if ( $v > 1 ) {
        $self->_dh->prepare_upgrade(
            {
                from_version => $v - 1,
                to_version   => $v
            }
        );
    }
}

sub cmd_install {
    my $self = shift;
    $self->_dh->install;
    $self->_dh->schema->install_defaults;
}

sub cmd_upgrade { shift->_dh->upgrade }

sub run {
    my ( $self ) = @_;
    my ( $cmd, @what ) = @{ $self->extra_argv };
    die "Must supply a command\n" unless $cmd;
    die "Extra argv detected - command only please\n" if @what;
    die "No such command ${cmd}\n" unless $self->can( "cmd_${cmd}" );
    $self ->${ \"cmd_${cmd}" };
}

1;
