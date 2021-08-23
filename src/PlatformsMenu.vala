/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2021 Gregory Tsitokhtsev <tsitokhtsev2002@gmail.com>
 */

public class Chameleon.PlatformsMenu : Gtk.Box {
    public Gtk.ComboBoxText platform_selector;

    construct {
        orientation = Gtk.Orientation.HORIZONTAL;
        border_width = 12;

        platform_selector = new Gtk.ComboBoxText ();
        platform_selector.append_text ("org.gnome");
        platform_selector.append_text ("org.kde");
        // platform_selector.append_text ("io.elementary");
        platform_selector.set_active (0);

        pack_start (new Gtk.Label (_("Select Platform")), false, false, 0);
        pack_end (platform_selector, false, false, 0);
    }

    public string get_selected_platform () {
        return platform_selector.get_active_text ();
    }
}
