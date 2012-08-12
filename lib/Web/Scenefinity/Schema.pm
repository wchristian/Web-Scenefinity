use strictures;

package Web::Scenefinity::Schema;
use base 'DBIx::Class::Schema::Config';

our $VERSION = 1;
__PACKAGE__->load_namespaces;

sub install_defaults {}

1;
