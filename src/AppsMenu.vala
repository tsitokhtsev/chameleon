/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2021 Gregory Tsitokhtsev <tsitokhtsev2002@gmail.com>
 */

public class Chameleon.AppsMenu : Gtk.Box {
    public Gtk.ComboBoxText platform_selector;
    public List<string> apps_list;

    public AppsMenu () {
        Object (
            orientation: Gtk.Orientation.HORIZONTAL,
            border_width: 12
        );
    }

    construct {
        var apps_selector = new Gtk.Box (Gtk.Orientation.VERTICAL, 6);

        apps_list = new List<string> ();

        var apps_path = Environment.get_home_dir () + "/.local/share/flatpak/app/";
        var apps_folder = File.new_for_path (apps_path);

        // var runtime_string = "runtime=" + platform;
        var runtime_string = "runtime=" + "org.gnome";

        try {
            var enumerator = apps_folder.enumerate_children (FileAttribute.STANDARD_NAME, 0);
            FileInfo file_info;

            while ((file_info = enumerator.next_file ()) != null) {
                var id = file_info.get_name ();

                var desktop_path = apps_path + id + "/current/active/export/share/applications/" + id + ".desktop";
                var desktop = File.new_for_path (desktop_path);

                var metadata_path = apps_path + id + "/current/active/metadata";
                var metadata = File.new_for_path (metadata_path);

                try {
                    FileInputStream mfis = metadata.read ();
                    DataInputStream mdis = new DataInputStream (mfis);
                    string line;

                    while ((line = mdis.read_line ()) != null) {
                        if (line.contains (runtime_string)) {
                            FileInputStream dfis = desktop.read ();
                            DataInputStream ddis = new DataInputStream (dfis);

                            var check_button = new Gtk.CheckButton ();

                            while ((line = ddis.read_line ()) != null) {
                                if (line.has_prefix ("Name=")) {
                                    var name = line.replace("Name=", "");
                                    check_button.set_label (name);
                                    apps_selector.add (check_button);
                                    break;
                                }
                            }

                            check_button.toggled.connect(() => {
                                if (check_button.get_active ()) {
                                    apps_list.append (id);
                                } else {
                                    unowned List<string> app_to_remove = apps_list.find_custom (id, strcmp);
                                    apps_list.remove_link (app_to_remove);
                                }
                            });
                        }
                    }
                } catch (Error e) {
                    print ("Error: %s\n", e.message);
                }
            }
        } catch (Error e) {
            print ("Error: %s\n", e.message);
        }

        pack_start (new Gtk.Label (_("Select Apps")), false, false, 0);
        pack_end (apps_selector, false, false, 0);
    }

    public unowned List<string> get_apps_list () {
        return apps_list;
    }
}
