/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2021 Gregory Tsitokhtsev <tsitokhtsev2002@gmail.com>
 */

public class Chameleon.Window : Gtk.ApplicationWindow {
    public GLib.Settings settings;

    public Window (Application application) {
        Object (application: application);
    }

    construct {
        window_position = Gtk.WindowPosition.CENTER;
        resizable = false;
        default_width = 400;
        this.get_style_context ().add_class ("rounded");

        settings = new GLib.Settings ("com.github.tsitokhtsev.chameleon");

        var header_bar = new Chameleon.HeaderBar ();
        set_titlebar (header_bar);

        var box = new Gtk.Box (Gtk.Orientation.VERTICAL, 12) {
            border_width = 12
        };

        var themes_warning = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 6);
        themes_warning.halign = Gtk.Align.CENTER;
        var warning_icon = new Gtk.Image () {
            gicon = new ThemedIcon ("dialog-warning-symbolic"),
            pixel_size = 16
        };
        var warning_label = new Gtk.Label ("Theme must be downloaded from Flathub to be displayed");
        themes_warning.add (warning_icon);
        themes_warning.add (warning_label);
        box.add (themes_warning);

        var platforms_menu = new Chameleon.PlatformsMenu ();
        var themes_menu = new Chameleon.ThemesMenu ();

        var list_box = new Gtk.ListBox () {
            selection_mode = Gtk.SelectionMode.NONE
        };
        list_box.get_style_context ().add_class ("content");
        list_box.add (platforms_menu);
        list_box.add (themes_menu);
        box.add (list_box);

        var apply_button = new Gtk.Button.with_label (_("Apply"));
        var reset_button = new Gtk.Button.with_label (_("Reset"));

        apply_button.get_style_context ().add_class ("suggested-action");
        apply_button.clicked.connect (() => {
            var apps_list = get_apps (platforms_menu.get_selected_platform ());
            apply_theme (apps_list, themes_menu.get_selected_theme ());
        });

        reset_button.get_style_context ().add_class ("destructive-action");
        reset_button.clicked.connect (() => {
            var apps_list = get_apps (platforms_menu.get_selected_platform ());
            reset_theme (apps_list);
        });

        var buttons_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 6) {
            halign = Gtk.Align.END
        };
        buttons_box.add (reset_button);
        buttons_box.add (apply_button);

        box.pack_end (buttons_box, false, false, 0);
        add (box);

        show_all ();
    }

    public List<string> get_apps (string platform) {
        var apps = new List<string> ();
        var apps_path = Environment.get_home_dir () + "/.local/share/flatpak/app/";
        var apps_folder = File.new_for_path (apps_path);
        var runtime_string = "runtime=" + platform;

        try {
            var enumerator = apps_folder.enumerate_children (FileAttribute.STANDARD_NAME, 0);
            FileInfo file_info;

            while ((file_info = enumerator.next_file ()) != null) {
                var name = file_info.get_name ();
                var metadata_path = apps_path + name + "/current/active/metadata";
                var metadata = File.new_for_path (metadata_path);

                try {
                    FileInputStream fis = metadata.read ();
                    DataInputStream dis = new DataInputStream (fis);
                    string line;

                    while ((line = dis.read_line ()) != null) {
                        if (line.contains (runtime_string)) {
                            apps.append (name);
                        }
                    }
                } catch (Error e) {
                    print ("Error: %s\n", e.message);
                }
            }
        } catch (Error e) {
            print ("Error: %s\n", e.message);
        }

        return apps;
    }

    public void apply_theme (List<string> apps_list, string theme) {
        var overrides_path = Environment.get_home_dir () + "/.local/share/flatpak/overrides/";
        var theme_string = "[Environment]\nGTK_THEME=" + theme;

        apps_list.foreach (app => {
            var app_path = File.new_for_path (overrides_path + app);

            if (app_path.query_exists ()) {
                try {
                    app_path.delete ();
                } catch (Error e) {
                    print ("Error: %s\n", e.message);
                }
            }

            try {
                FileOutputStream fos = app_path.append_to (GLib.FileCreateFlags.NONE);
                fos.write (theme_string.data);
            } catch (Error e) {
                print ("Error: %s\n", e.message);
            }
        });
    }

    public void reset_theme (List<string> apps_list) {
        var overrides_path = Environment.get_home_dir () + "/.local/share/flatpak/overrides/";

        apps_list.foreach (app => {
            var app_path = File.new_for_path (overrides_path + app);

            if (app_path.query_exists ()) {
                try {
                    app_path.delete ();
                } catch (Error e) {
                    print ("Error: %s\n", e.message);
                }
            }
        });
    }
}
