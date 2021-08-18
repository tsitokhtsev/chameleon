public class Themer.HeaderBar : Gtk.HeaderBar {
    construct {
		title = "Themer";
        show_close_button = true;
		get_style_context ().add_class ("titlebar");
		get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);
    }
}
