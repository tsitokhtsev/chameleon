/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2021 Gregory Tsitokhtsev <tsitokhtsev2002@gmail.com>
 */

public class Chameleon.ThemesMenu : Gtk.Box {
    public Gtk.ComboBoxText theme_selector;

    construct {
        orientation = Gtk.Orientation.HORIZONTAL;
        border_width = 12;

        theme_selector = new Gtk.ComboBoxText ();
        var themes_list = get_themes ();
        theme_selector.append_text ("Adwaita");
        themes_list.foreach (theme => {
            theme_selector.append_text (theme);
        });
        theme_selector.set_active (0);

        pack_start (new Gtk.Label (_("Select Theme")), false, false, 0);
        pack_end (theme_selector, false, false, 0);
    }

    public List<string> get_themes () {
        var themes_list = new List<string> ();
        try {
            var themes_path = Environment.get_home_dir () + "/.local/share/flatpak/runtime";
            var themes_folder = File.new_for_path (themes_path);
            var enumerator = themes_folder.enumerate_children (FileAttribute.STANDARD_NAME, 0);
            FileInfo file_info;

            while ((file_info = enumerator.next_file ()) != null) {
                var name = file_info.get_name ();
                
                if (name.contains ("org.gtk.Gtk3theme.")) {
                    name = name.replace ("org.gtk.Gtk3theme.", "");
                    themes_list.append (name);
                }
            }
        } catch (Error e) {
            print ("Error: %s\n", e.message);
        }

        return themes_list;
    }

    public string get_selected_theme () {
        return theme_selector.get_active_text ();
    }
}
