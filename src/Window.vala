public class Themer.Window : Gtk.ApplicationWindow {
    public GLib.Settings settings;

    public Window (Application application) {
        Object (application: application);
    }

    construct {
		window_position = Gtk.WindowPosition.CENTER;
        resizable = false;
		default_width = 400;
        // default_height = 500;
		this.get_style_context ().add_class ("rounded");
		
        settings = new GLib.Settings ("com.github.tsitokhtsev.themer");
		
        move (settings.get_int ("pos-x"), settings.get_int ("pos-y"));
        // resize (settings.get_int ("window-width"), settings.get_int ("window-height"));
		
        delete_event.connect (e => {
			return before_destroy ();
        });
		
        var header_bar = new Gtk.HeaderBar () {
            title = "Themer",
            show_close_button = true,
        };
        // header_bar.get_style_context ().add_class ("titlebar");
        header_bar.get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);
        set_titlebar (header_bar);

		var box = new Gtk.Box (Gtk.Orientation.VERTICAL, 12) {
            border_width = 12
        };
        
		var list_box = new Gtk.ListBox () {
            selection_mode = Gtk.SelectionMode.NONE
        };
        list_box.get_style_context ().add_class ("content");
        
        var themes_row = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0) {
            border_width = 12
        };

        var theme_selector = new Gtk.ComboBoxText ();
        var theme_list = get_themes ();
        theme_list.foreach (str => {
            theme_selector.append_text (str); 
        });

        themes_row.pack_start (new Gtk.Label ("Select Theme"), false, false, 0);
        themes_row.pack_end (theme_selector, false, false, 0);
		list_box.add (themes_row);
        box.add (list_box);
        
		var apply_button = new Gtk.Button.with_label ("Apply");
        var reset_button = new Gtk.Button.with_label ("Reset");
        
        apply_button.get_style_context ().add_class ("suggested-action");
        
		var buttons_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 6) {
            halign = Gtk.Align.END
        };
        buttons_box.add (reset_button);
        buttons_box.add (apply_button);
        
        box.pack_end (buttons_box, false, false, 0);
        add (box);
        
        show_all ();
    }
    
    public bool before_destroy () {
        int width, height, x, y;

        get_size (out width, out height);
        get_position (out x, out y);

        settings.set_int ("pos-x", x);
        settings.set_int ("pos-y", y);
        settings.set_int ("window-width", width);
        settings.set_int ("window-height", height);

        return false;
    }

    public List<string> get_themes () {
        var themes = new List<string> ();
        var themes_path = Environment.get_home_dir () + "/.local/share/themes/";
        var file = File.new_for_path (themes_path);

        try {
            var enumerator = file.enumerate_children (FileAttribute.STANDARD_NAME, 0);
            FileInfo file_info;
            while ((file_info = enumerator.next_file ()) != null) {
                var name = file_info.get_name ();

                var checktheme = File.new_for_path (themes_path + name + "/gtk-3.0");
                var checkicons = File.new_for_path (themes_path + name + "/48x48/gtk-3.0");
                if ((checktheme.query_exists () || checkicons.query_exists ()) && themes.find (name) == null) {
                    themes.append (name);
                    message (name);
                }
            }
        } catch (Error e) {
            warning (e.message);
        }

        return themes;
    }
}
