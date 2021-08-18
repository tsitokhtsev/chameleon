# project name and programming language
project('com.github.tsitokhtsev.themer', 'vala', 'c')

# Create a new executable, list the files we want to compile, list the dependencies we need, and install
executable(
    meson.project_name(),
	'src' / 'Main.vala',
    'src' / 'Application.vala',
    'src' / 'Window.vala',
    'src' / 'HeaderBar.vala',
    dependencies: [
        dependency('gtk+-3.0'),
        dependency('granite')
    ],
    install: true
)

# Install our .desktop file so the Applications Menu will see it
install_data(
    'data' / 'themer.desktop',
    install_dir: get_option('datadir') / 'applications',
    rename: meson.project_name() + '.desktop'
)

# Install our .appdata.xml file so AppCenter will see it
install_data(
    'data' / 'themer.appdata.xml',
    install_dir: get_option('datadir') / 'metainfo',
    rename: meson.project_name() + '.appdata.xml'
)

# Install our gschema.xml
install_data(
    'data' / 'gschema.xml',
    install_dir: join_paths (get_option ('datadir'), 'glib-2.0', 'schemas'),
    rename: meson.project_name () + '.gschema.xml'
)

meson.add_install_script('meson/post_install.py')
