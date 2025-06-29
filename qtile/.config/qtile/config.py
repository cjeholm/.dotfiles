# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

#    ____  __  _ __        __                         __
#   / __ \/ /_(_) /__     / /      ____ _   ____     / /_   ____     ____
#  / / / / __/ / / _ \   / /      / __ `/  / __ \   / __/  / __ \   / __ \
# / /_/ / /_/ / /  __/  / /___   / /_/ /  / /_/ /  / /_   / /_/ /  / /_/ /
# \___\_\__/_/_/\___/  /_____/   \__,_/  / .___/   \__/   \____/  / .___/
#                                       /_/                      /_/

import os
import datetime

from libqtile import bar, layout, qtile, widget, hook
from libqtile.config import Click, Drag, Group, Key, Match, Screen, ScratchPad, DropDown
from libqtile.lazy import lazy

@hook.subscribe.startup_once
def autostart():
    os.system("dunst -config ~/.config/dunst/dunstrc &")

def set_date_to_clipboard(foo):
    # Get today's date in the desired format (YYYY-MM-DD_)
    today_date = datetime.datetime.now().strftime("%Y-%m-%d_")
    # Copy the date to the clipboard using xsel
    os.system(f"echo -n '{today_date}' | xsel -ib")


mod = "mod4"
# terminal = guess_terminal()
terminal = "alacritty"
# terminal = "kitty"
# terminal = "konsole"

keys = [
    # A list of available commands that can be bound to keys can be found
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html
    # Switch between windows
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),

    Key([mod, "control"], "Tab", lazy.spawn("rofi -show window")),

    # Toggle bar
    Key([mod], "b", lazy.hide_show_bar(), desc="Toggles the bar"),

    # Paste todays date
    Key([mod], "d", lazy.function(set_date_to_clipboard), desc="Set todays date to clipboard"),

    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),

    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key([mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),

    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key(
        [mod, "shift"],
        "Return",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    Key([mod, "shift"], "s", lazy.spawn("scrot-window"), desc="Screenshot window"),
    Key([mod, "control"], "s", lazy.spawn("scrot-screen"), desc="Screenshot screen"),
    Key([mod], "Escape", lazy.spawn("i3lock -c 111111 -t -i /home/conny/.config/qtile/fräv-3840x2557.png"), desc="Lock screen"),

    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "w", lazy.window.kill(), desc="Kill focused window"),
    Key(
        [mod],
        "f",
        lazy.window.toggle_fullscreen(),
        desc="Toggle fullscreen on the focused window",
    ),
    Key([mod], "t", lazy.window.toggle_floating(), desc="Toggle floating on the focused window"),
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),

    # App launcher
    # Key([mod], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),
    Key([mod], "r", lazy.spawn("rofi -show drun")),
    Key([mod, "shift"], "r", lazy.spawncmd()),


    # Sound
    Key([], "XF86AudioMute", lazy.spawn("pamixer -t")),
    Key([], "XF86AudioLowerVolume", lazy.spawn("pamixer -d 10")),
    Key([], "XF86AudioRaiseVolume", lazy.spawn("pamixer -i 10")),

    # Scratchpad
    Key([mod], "s", lazy.group['scratchpad'].dropdown_toggle('term')),
    Key([mod], "v", lazy.group['scratchpad'].dropdown_toggle('vim')),
    Key([mod], "y", lazy.group['scratchpad'].dropdown_toggle('yazi')),
    Key([mod], "c", lazy.group['scratchpad'].dropdown_toggle('clip')),

    # Notifications
    Key([mod], "n", lazy.spawn("dunstctl close-all")),
    Key([mod], "p", lazy.spawn("dunstctl history-pop")),
]

# Add key bindings to switch VTs in Wayland.
# We can't check qtile.core.name in default config as it is loaded before qtile is started
# We therefore defer the check until the key binding is run by using .when(func=...)
for vt in range(1, 8):
    keys.append(
        Key(
            ["control", "mod1"],
            f"f{vt}",
            lazy.core.change_vt(vt).when(func=lambda: qtile.core.name == "wayland"),
            desc=f"Switch to VT{vt}",
        )
    )


groups = [Group(i) for i in "123456789"]

for i in groups:
    keys.extend(
        [
            # mod1 + group number = switch to group
            Key(
                [mod],
                i.name,
                lazy.group[i.name].toscreen(),
                desc="Switch to group {}".format(i.name),
            ),
            # mod1 + shift + group number = switch to & move focused window to group
            Key(
                [mod, "shift"],
                i.name,
                lazy.window.togroup(i.name, switch_group=False),
                desc="Switch to & move focused window to group {}".format(i.name),
            ),
            # Or, use below if you prefer not to switch to that group.
            # # mod1 + shift + group number = move focused window to group
            # Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
            #     desc="move focused window to group {}".format(i.name)),
        ]
    )


# Add the ScratchPad group
groups.append(
    ScratchPad("scratchpad", [
        DropDown("term", "alacritty", width=0.4, height=0.7, x=0.3, y=0.15),
        DropDown("vim", "alacritty -e nvim", width=0.4, height=0.7, x=0.3, y=0.15),
        DropDown("yazi", "alacritty -e yazi", width=0.4, height=0.7, x=0.3, y=0.15),
        DropDown("clip", "alacritty -e /home/conny/Documents/xseltui/xseltui.py", width=0.4, height=0.3, x=0.3, y=0.4),
    ])
)


layout_defaults = dict(
    border_focus=["#bbb"],
    border_normal=["#111", "#222"],
    border_focus_stack=["#ddd"],
    border_width=2,
    margin=20
)

layouts = [
    layout.Columns(**layout_defaults),
    layout.RatioTile(**layout_defaults),
    layout.Max(),
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    # layout.Matrix(**layout_defaults),
    # layout.MonadTall(**layout_defaults),
    # layout.MonadWide(),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

widget_defaults = dict(
    # font="Iosevka NFM Medium",
    # font="0xProto Nerd Font Mono",
    font="BlexMono Nerd Font Mono",
    fontsize=32,
    padding=16,
    foreground="#aaa",
)
extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        wallpaper="/home/conny/.config/qtile/tiles1_laptop.png",
        wallpaper_mode="fill",
        bottom=bar.Bar(
            [
                widget.CurrentLayout(),
                widget.GroupBox(),
                widget.Prompt(),
                widget.WindowName(),
                widget.Chord(
                    chords_colors={
                        "launch": ("#ff0000", "#ffffff"),
                    },
                    name_transform=lambda name: name.upper(),
                ),
                # widget.TextBox("default config", name="default"),
                # widget.TextBox("Press &lt;M-r&gt; to spawn", foreground="#d75f5f"),
                # NB Systray is incompatible with Wayland, consider using StatusNotifier instead
                # widget.StatusNotifier(),
                widget.Systray(),
                # widget.Backlight(),
                widget.PulseVolume(fmt='Vol {}'),
                widget.TextBox("\U00002022", name="Unicide Dot"),
                widget.Battery(fmt="Bat {}", notify_below=10, discharge_char="\U00002193", charge_char="\U00002191"),
                widget.TextBox("\U00002022", name="Unicide Dot"),
                widget.Wlan(interface="wlp1s0"),
                widget.TextBox("\U00002022", name="Unicide Dot"),
                widget.Net(interface="tun0"),
                widget.TextBox("\U00002022", name="Unicide Dot"),
                widget.Bluetooth(interface="hci0"),
                # widget.TextBox("🐹", name="Hamster"),
                widget.TextBox("\U00002022", name="Unicide Dot"),
                widget.Clock(format="%Y-%m-%d %a %H:%M %p"),
                # widget.QuickExit(default_text='[logout]'),
            ],
            44,
            background="#222",
            padding=20,
            # border_width=[2, 0, 2, 0],  # Draw top and bottom borders
            # border_color=["ff00ff", "000000", "ff00ff", "000000"]  # Borders are magenta
        ),
        # You can uncomment this variable if you see that on X11 floating resize/moving is laggy
        # By default we handle these events delayed to already improve performance, however your system might still be struggling
        # This variable is set to None (no cap) by default, but you can set it to 60 to indicate that you limit it to 60 events per second
        # x11_drag_polling_rate = 60,
    ),


    Screen(
        wallpaper="/home/conny/.config/qtile/fjällräven.png",
        wallpaper_mode="fill",
    ),


]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
floats_kept_above = True
cursor_warp = False
floating_layout = layout.Floating(
    border_width=4,
    border_focus=["#bbb"],
    border_normal=["#111", "#222"],
    border_focus_stack=["#ddd"],

    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
# wmname = f"Qtile {VERSION}"
