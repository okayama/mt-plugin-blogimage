package MT::BlogImage::Callbacks;
use strict;

sub _cb_tp_favorite_blogs {
    my ( $cb, $app, $param, $tmpl ) = @_;
    my $plugin = MT->component( 'BlogImage' );
    my $tag = $plugin->get_config_value( 'tag' );
    return unless $tag;
    if ( my $objects = $param->{ website_object_loop } ) {
        for my $object ( @$objects ) {
            my $website_id = $object->{ website_id };
            my $image_url = _asset_url_by_tag( $website_id, $tag );
            if ( $image_url ) {
                $object->{ website_theme_thumb } = $image_url;
            }
        }
        if ( my $blog_objects = $param->{ blog_object_loop } ) {
            for my $object ( @$blog_objects ) {
                my $blog_id = $object->{ blog_id };
                my $image_url = _asset_url_by_tag( $blog_id, $tag );
                if ( $image_url ) {
                    $object->{ blog_theme_thumb } = $image_url;
                }
            }
        }
    }
1;
}

sub _cb_tp_recent_websites {
    goto &_cb_tp_favorite_blogs;
}

sub _cb_tp_recent_blogs {
    goto &_cb_tp_favorite_blogs;
}

sub _asset_url_by_tag {
    my ( $blog_id, $tag_name ) = @_;
    return unless $blog_id;
    return unless $tag_name;
    my $tag = MT->model( 'tag' )->load( { name => $tag_name, },
                                        { fetchonly => { id => 1, },
                                          binary => { name => 1 },
                                        },
                                      );
    return unless $tag;
    my ( %terms, %args );
    $terms{ id } = \'=objecttag_object_id';
    $args{ 'join' } = MT->model( 'objecttag' )->join_on( undef,
                                                         { tag_id => $tag->id,
                                                           blog_id => $blog_id,
                                                         }, {
                                                           unique => 1,
                                                         }
                                                       );
    $args{ 'sort' } = 'modified_on';
    $args{ direction } = 'descend';
    my $asset = MT->model( 'asset' )->load( \%terms, \%args );
    if ( $asset ) {
        return $asset->url;
    }
}

1;