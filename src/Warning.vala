/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2021 Gregory Tsitokhtsev <tsitokhtsev2002@gmail.com>
 */

public class Chameleon.Warning : Gtk.Box {
    public Warning () {
        Object (
            orientation: Gtk.Orientation.HORIZONTAL,
            spacing: 6,
            margin_left: 20,
            margin_right: 20,
            halign: Gtk.Align.CENTER
        );
    }

    construct {
        var warning_icon = new Gtk.Image () {
            gicon = new ThemedIcon ("dialog-warning-symbolic"),
            pixel_size = 16
        };

        var warning_label = new Gtk.Label ("Theme must be downloaded from Flathub to be displayed");

        add (warning_icon);
        add (warning_label);
    }
}
