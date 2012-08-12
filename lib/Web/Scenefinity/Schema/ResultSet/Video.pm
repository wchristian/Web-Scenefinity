use strictures;

package Web::Scenefinity::Schema::ResultSet::Video;

use DBIx::Class::Helper::ResultSet::Random;

use base 'DBIx::Class::ResultSet';

__PACKAGE__->load_components( 'Helper::ResultSet::Random' );

1;
