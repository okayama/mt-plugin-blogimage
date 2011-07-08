package MT::Plugin::BlogImage;
use strict;
use MT;
use MT::Plugin;
use base qw( MT::Plugin );
@MT::Plugin::BlogImage::ISA = qw( MT::Plugin );

my $PLUGIN_NAME = 'BlogImage';
my $VERSION = '0.1';

my $plugin = __PACKAGE__->new( {
    id => $PLUGIN_NAME,
    key => lc $PLUGIN_NAME,
    name => $PLUGIN_NAME,
    author_name => 'okayama',
    author_link => 'http://weeeblog.net/',
    description => '<__trans phrase="Change blog image.">',
    version => $VERSION,
    l10n_class => 'MT::' . $PLUGIN_NAME . '::L10N',
    system_config_template => lc $PLUGIN_NAME . '_config.tmpl',
    settings => new MT::PluginSettings( [
        [ 'tag', { Default => '@dashboard' } ],
    ] ),
} );
MT->add_plugin( $plugin );

sub init_registry {
    my $plugin = shift;
    $plugin->registry( {
        callbacks => {
            'MT::App::CMS::template_param.favorite_blogs' => 'MT::' . $PLUGIN_NAME . '::Callbacks::_cb_tp_favorite_blogs',
            'MT::App::CMS::template_param.recent_websites' => 'MT::' . $PLUGIN_NAME . '::Callbacks::_cb_tp_recent_websites',
            'MT::App::CMS::template_param.recent_blogs' => 'MT::' . $PLUGIN_NAME . '::Callbacks::_cb_tp_recent_blogs',
        },
    } );
}

1;