use strictures;

package Web::Scenefinity::Schema::Result::Video;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table( 'video' );
__PACKAGE__->add_columns(
    video_id => { data_type => 'integer', is_auto_increment => 1 },
    yt_id    => { data_type => 'text' },
);
__PACKAGE__->set_primary_key( 'video_id' );
__PACKAGE__->add_unique_constraint( ["yt_id"] );

1;
