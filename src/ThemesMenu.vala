public class Themer.ThemesMenu : Gtk.Box {
    public Gtk.ComboBoxText theme_selector;

    construct {
        orientation = Gtk.Orientation.HORIZONTAL;
        border_width = 12;
        
        theme_selector = new Gtk.ComboBoxText ();
        var themes_list = get_themes ();
        themes_list.foreach (theme => {
            theme_selector.append_text (theme);
        });
        theme_selector.set_active (0);

        pack_start (new Gtk.Label ("Select Theme"), false, false, 0);
        pack_end (theme_selector, false, false, 0);
    }

    public List<string> get_themes () {
        var themes_list = new List<string> ();
        var themes_path = Environment.get_home_dir () + "/.local/share/themes/";
        var themes_folder = File.new_for_path (themes_path);

        try {
            var enumerator = themes_folder.enumerate_children (FileAttribute.STANDARD_NAME, 0);
            FileInfo file_info;

            while ((file_info = enumerator.next_file ()) != null) {
                var name = file_info.get_name ();

                var theme = File.new_for_path (themes_path + name + "/gtk-3.0");
                var icons = File.new_for_path (themes_path + name + "/48x48/gtk-3.0");
                if ((theme.query_exists () || icons.query_exists ()) && themes_list.find (name) == null) {
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
