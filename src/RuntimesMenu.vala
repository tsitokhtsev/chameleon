/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2021 Gregory Tsitokhtsev <tsitokhtsev2002@gmail.com>
 */

public class Chameleon.RuntimesMenu : Gtk.Box {
    public Gtk.ComboBoxText runtime_selector;

    construct {
        orientation = Gtk.Orientation.HORIZONTAL;
        border_width = 12;

        runtime_selector = new Gtk.ComboBoxText ();
        runtime_selector.append_text ("org.gnome");
        runtime_selector.append_text ("org.kde");
        // runtime_selector.append_text ("io.elementary");
        runtime_selector.set_active (0);

        pack_start (new Gtk.Label (_("Select Runtime")), false, false, 0);
        pack_end (runtime_selector, false, false, 0);
    }

    public string get_selected_runtime () {
        return runtime_selector.get_active_text ();
    }
}
