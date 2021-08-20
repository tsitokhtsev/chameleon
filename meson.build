# project name and programming language
project('com.github.tsitokhtsev.themer', 'vala', 'c')

# Include the translations module
i18n = import('i18n')

# Set our translation domain
add_global_arguments('-DGETTEXT_PACKAGE="@0@"'.format (meson.project_name()), language:'c')

# Create a new executable, list the files we want to compile, list the dependencies we need, and install
executable(
    meson.project_name(),
	'src' / 'Main.vala',
    'src' / 'Application.vala',
    'src' / 'Window.vala',
    'src' / 'HeaderBar.vala',
    'src' / 'ThemesMenu.vala',
    'src' / 'RuntimesMenu.vala',
    dependencies: [
        dependency('gtk+-3.0'),
        dependency('granite')
    ],
    install: true
)

#Translate and install our .desktop file
i18n.merge_file(
    input: 'data' / 'themer.desktop.in',
    output: meson.project_name() + '.desktop',
    po_dir: meson.source_root() / 'po',
    type: 'desktop',
    install: true,
    install_dir: get_option('datadir') / 'applications'
)

#Translate and install our .appdata file
i18n.merge_file(
    input: 'data' / 'themer.appdata.xml.in',
    output: meson.project_name() + '.appdata.xml',
    po_dir: meson.source_root() / 'po',
    install: true,
    install_dir: get_option('datadir') / 'metainfo'
)

# Install our gschema.xml
install_data(
    'data' / 'gschema.xml',
    install_dir: get_option ('datadir') / 'glib-2.0' / 'schemas',
    rename: meson.project_name () + '.gschema.xml'
)

meson.add_install_script('meson/post_install.py')

subdir('po')
