use strictures;

package Web::Scenefinity::Role::Configuration;

use Web::Scenefinity::Schema;
use YAML 'Load';
use IO::All;

use Moo::Role;

sub {
    has $_ => ( is => 'lazy' ) for qw( db config );
  }
  ->();

sub config_path {
    my $file = ".scenefinity";
    return $file if -f $file;
    my $home_dir = File::HomeDir->my_home || '';
    return "$home_dir/$file" if -f "$home_dir/$file";
    die "no config file found in . or ~";
}

sub _build_config { Load io( shift->config_path )->all }

sub _build_db {
    my ( $self ) = @_;
    my $db       = $self->config->{db};
    my $schema   = Web::Scenefinity::Schema->connect( $db );
    return $schema;
}

1;