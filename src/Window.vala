/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2021 Gregory Tsitokhtsev <tsitokhtsev2002@gmail.com>
 */

public class Chameleon.Window : Hdy.ApplicationWindow {
    public GLib.Settings settings;
    public Granite.Widgets.Toast toast;

    public Window (Application application) {
        Object (
            application: application,
            window_position: Gtk.WindowPosition.CENTER,
            resizable: false
        );
    }

    construct {
        Hdy.init ();

        settings = new GLib.Settings ("com.github.tsitokhtsev.chameleon");

        var header = new Hdy.HeaderBar () {
            title = _("Chameleon"),
            show_close_button = true
        };

        unowned Gtk.StyleContext header_context = header.get_style_context ();
        header_context.add_class ("default-decoration");
        header_context.add_class (Gtk.STYLE_CLASS_FLAT);

        // var grid = new Gtk.Grid () {
        //     column_spacing = 6,
        //     row_spacing = 6,
        //     margin = 6,
        //     //  Side margins to make scrolling easier
        //     margin_left = 10,
        //     margin_right = 10,
        //     halign = Gtk.Align.FILL
        // };

        var overlay = new Gtk.Overlay ();
        // grid.attach (overlay, 0, 0);

        var toast = new Granite.Widgets.Toast (_("All done!"));
        toast.set_default_action (_("Undo"));
        overlay.add_overlay (toast);

        var main_view = new Chameleon.MainView (toast);
        overlay.add (main_view);

        var scrolled = new Gtk.ScrolledWindow (null, null) {
            //  Disabled sideways scrolling
            hscrollbar_policy = Gtk.PolicyType.NEVER,
            //  Minimum show one app
            // min_content_height = 200,
            propagate_natural_height = true
        };

        scrolled.add (overlay);

        var window_grid = new Gtk.Grid () {
            column_spacing = 0,
            row_spacing = 0,
            margin = 0,
            halign = Gtk.Align.FILL
        };

        window_grid.attach (header, 0, 0);
        window_grid.attach (scrolled, 0, 1);

        var window_handle = new Hdy.WindowHandle ();
        window_handle.add (window_grid);

        add (window_handle);

        show_all ();
    }
}
