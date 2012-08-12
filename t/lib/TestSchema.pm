use strictures;

package TestSchema;

use parent 'Web::Scenefinity::Schema';

sub upgrade_directory { 't/lib' }

sub deploy_or_connect {
    my $self = shift;

    my $schema = $self->connect;
    $schema->deploy;
    return $schema;
}

sub connect {
    my $self = shift;
    return $self->next::method( 'dbi:SQLite::memory:' );
}

sub prepopulate {
    my $self = shift;
    $self->resultset( $_ )->delete for qw{Video};
    $self->populate( Video => [ ['yt_id'], map( [$_], qw( a b c ) ) ] );
    return;
}

1;
