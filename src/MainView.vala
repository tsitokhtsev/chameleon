/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2021 Gregory Tsitokhtsev <tsitokhtsev2002@gmail.com>
 */

public class Chameleon.MainView : Gtk.Box {
    public Granite.Widgets.Toast toast { get; construct; }
    public Gtk.ListBox list_box { get; construct; }

    public MainView (Granite.Widgets.Toast toast) {
        Object (
            toast: toast,
            orientation: Gtk.Orientation.VERTICAL,
            spacing: 12,
            border_width: 12
        );
    }
    construct {
        list_box = new Gtk.ListBox () {
            selection_mode = Gtk.SelectionMode.NONE
        };
        list_box.get_style_context ().add_class ("content");

        var apps_menu = new Chameleon.AppsMenu ();
        var themes_menu = new Chameleon.ThemesMenu ();

        list_box.add (apps_menu);
        list_box.add (themes_menu);

        var apply_button = new Gtk.Button.with_label (_("Apply"));
        var reset_button = new Gtk.Button.with_label (_("Reset"));

        apply_button.get_style_context ().add_class ("suggested-action");
        apply_button.clicked.connect (() => {
            apply_theme (apps_menu.get_apps_list (), themes_menu.get_selected_theme ());
        });

        reset_button.get_style_context ().add_class ("destructive-action");
        reset_button.clicked.connect (() => {
            reset_theme (apps_menu.get_apps_list ());
        });

        var buttons_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 6) {
            halign = Gtk.Align.END
        };

        buttons_box.add (reset_button);
        buttons_box.add (apply_button);

        add (apps_menu);
        add (list_box);
        add (new Chameleon.Warning ());
        add (buttons_box);
    }

    public void apply_theme (List<string> apps_list, string selected_theme) {
        var overrides_path = Environment.get_home_dir () + "/.local/share/flatpak/overrides/";
        var theme_string = "[Environment]\nGTK_THEME=" + selected_theme;

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

        toast.send_notification ();
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
