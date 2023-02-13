/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2021 Gregory Tsitokhtsev <tsitokhtsev2002@gmail.com>
 */

public class Chameleon.HeaderBar : Gtk.HeaderBar {
    construct {
        title = "Chameleon";
        subtitle = "Theme your Flatpak apps";
        show_close_button = true;
        get_style_context ().add_class ("titlebar");
        get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);
        hexpand = true;
    }
}
