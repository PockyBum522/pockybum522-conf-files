#! /bin/bash

set -e
set -o pipefail

echo "### Changing grub timeout to 1s ###" ##############################################################################
sed -i '/GRUB_TIMEOUT=5/c\GRUB_TIMEOUT=1' /etc/default/grub
update-grub


echo "### Setting up dirs for where to put appimages ###" ################################################################
USER_HOME=$(getent passwd $SUDO_USER | cut -d: -f6)

mkdir -p "$USER_HOME/.local"
APP_INSTALLS_DIR="$USER_HOME/.local/share"

if [ ! -f "$APP_INSTALLS_DIR" ]; then
    mkdir -p "$APP_INSTALLS_DIR"
fi

BEEPER_INSTALLS_DIR="$USER_HOME/.local/share/beeper"
if [ ! -f "$BEEPER_INSTALLS_DIR" ]; then
    mkdir -p "$BEEPER_INSTALLS_DIR"
fi

KMONAD_INSTALL_DIR="$USER_HOME/.local/share/beeper"
if [ ! -f "$KMONAD_INSTALL_DIR" ]; then
    mkdir -p "$KMONAD_INSTALL_DIR"
fi


echo "### Downloading kmonad ###" ##############################################################################
if [ ! -f "$KMONAD_INSTALL_DIR" ]; then
    curl https://raw.githubusercontent.com/PockyBum522/linux-files/master/bin/kmonad > "$KMONAD_INSTALL_DIR/kmonad"
    curl https://raw.githubusercontent.com/PockyBum522/linux-files/master/configuration/kmonad/default_layers.kbd > "$KMONAD_INSTALL_DIR/default_layers.kbd"
    groupadd uinput
    usermod -aG input,uinput david
    echo KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput" > /etc/udev/rules.d/80-kmonad.rules
    modprobe uinput
fi


echo "### Updating installed packages ###" ##############################################################################
wget -qO - https://apt.packages.shiftkey.dev/gpg.key | gpg --dearmor | sudo tee /usr/share/keyrings/shiftkey-packages.gpg > /dev/null ## Get the @shiftkey package feed for github desktop
sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/shiftkey-packages.gpg] https://apt.packages.shiftkey.dev/ubuntu/ any main" > /etc/apt/sources.list.d/shiftkey-packages.list'

apt update
apt-get -y upgrade
apt-get -y dist-upgrade


echo "### Setting theme to dark mode ###" ##############################################################################
sudo -H -u david bash -c gsettings set org.cinnamon.desktop.interface gtk-theme "Mint-Y-Dark"
sudo -H -u david bash -c gsettings set org.cinnamon.desktop.interface icon-theme "Mint-Y-Dark"
sudo -H -u david bash -c gsettings set org.cinnamon.theme name "Mint-Y-Dark"


echo "### Setting xed settings ###" ##############################################################################
sudo -H -u david bash -c gsettings set org.x.editor.preferences.editor display-line-numbers true
sudo -H -u david bash -c gsettings set org.x.editor.preferences.editor scheme cobalt

sudo -H -u david bash -c gsettings set org.x.editor.preferences.editor.bracket-matching true
sudo -H -u david bash -c gsettings set org.x.editor.preferences.editor.highlight-current-line true
sudo -H -u david bash -c gsettings set org.x.editor.preferences.editor.auto-indent true
sudo -H -u david bash -c gsettings set org.x.editor.plugins.active-plugins "['sort', 'filebrowser', 'docinfo', 'joinlines', 'spell', 'textsize', 'open-uri-context-menu', 'modelines', 'time']"


echo "### Setting update manager to hide icon unless updates are available ###" ##############################################################################
sudo -H -u david bash -c gsettings set com.linuxmint.updates hide-systray true

echo "### Setting notification settings ###" ##############################################################################
sudo -H -u david bash -c gsettings set org.cinnamon.desktop.notifications bottom-notifications true
sudo -H -u david bash -c gsettings set org.cinnamon.desktop.notifications remove-old true
sudo -H -u david bash -c gsettings set org.cinnamon.desktop.notifications notification-duration 3


echo "### Setting nemo file manager settings ###" ##############################################################################
sudo -H -u david bash -c gsettings set org.nemo.list-view default-zoom-level 'smaller'
sudo -H -u david bash -c gsettings set org.nemo.preferences default-folder-viewer 'list-view'
sudo -H -u david bash -c gsettings set org.nemo.preferences click-policy 'single'
sudo -H -u david bash -c gsettings set org.nemo.preferences start-with-dual-pane true
sudo -H -u david bash -c gsettings set org.nemo.preferences ignore-view-metadata true
sudo -H -u david bash -c gsettings set org.nemo.preferences click-double-parent-folder true
sudo -H -u david bash -c gsettings set org.nemo.preferences show-full-path-titles true
sudo -H -u david bash -c gsettings set org.nemo.preferences tooltips-on-desktop true
sudo -H -u david bash -c gsettings set org.nemo.preferences tooltips-show-file-type true
sudo -H -u david bash -c gsettings set org.nemo.preferences tooltips-show-mod-date true
sudo -H -u david bash -c gsettings set org.nemo.preferences tooltips-show-birth-date true
sudo -H -u david bash -c gsettings set org.nemo.preferences tooltips-show-access-date true
sudo -H -u david bash -c gsettings set org.nemo.preferences tooltips-show-path true
sudo -H -u david bash -c gsettings set org.nemo.preferences tooltips-in-list-view true
sudo -H -u david bash -c gsettings set org.nemo.preferences tooltips-in-icon-view true
sudo -H -u david bash -c gsettings set org.nemo.preferences show-new-folder-icon-toolbar true
sudo -H -u david bash -c gsettings set org.nemo.preferences show-open-in-terminal-toolbar true
sudo -H -u david bash -c gsettings set org.nemo.preferences show-compact-view-icon-toolbar false
sudo -H -u david bash -c gsettings set org.nemo.preferences show-show-thumbnails-toolbar true
sudo -H -u david bash -c gsettings set org.nemo.preferences show-icon-view-icon-toolbar true
sudo -H -u david bash -c gsettings set org.nemo.preferences show-reload-icon-toolbar true
sudo -H -u david bash -c gsettings set org.nemo.preferences show-computer-icon-toolbar true
sudo -H -u david bash -c gsettings set org.nemo.preferences menu-config.selection-menu-make-link true
sudo -H -u david bash -c gsettings set org.nemo.preferences menu-config.selection-menu-duplicate true
sudo -H -u david bash -c gsettings set org.nemo.preferences show-location-entry true
sudo -H -u david bash -c gsettings set org.nemo.list-view default-column-order "['name', 'size', 'type', 'date_modified', 'date_created_with_time', 'date_accessed', 'date_created', 'detailed_type', 'group', 'where', 'mime_type', 'date_modified_with_time', 'octal_permissions', 'owner', 'permissions']"
sudo -H -u david bash -c gsettings set org.nemo.list-view default-visible-columns "['name', 'size', 'type', 'date_modified', 'date_created', 'owner']"
sudo -H -u david bash -c gsettings set org.nemo.window-state side-pane-view 'tree'


echo "### Setting firefox keyboard shortcut ###" ##############################################################################
sudo -H -u david bash -c gsettings set org.cinnamon.desktop.keybindings custom-list "['__dummy__']"
sudo -H -u david bash -c gsettings set org.cinnamon.desktop.keybindings custom-list "['__dummy__', 'custom0']"
sudo -H -u david bash -c dconf write /org/cinnamon/desktop/keybindings/custom-keybindings/custom0/binding "['<Alt>f']"
sudo -H -u david bash -c dconf write /org/cinnamon/desktop/keybindings/custom-keybindings/custom0/command "'firefox'"
sudo -H -u david bash -c dconf write /org/cinnamon/desktop/keybindings/custom-keybindings/custom0/name "'Firefox'"

# Make sure dir exists

if [ ! -f "/media/secondary" ]; then
    mkdir /media/secondary
fi
chown /media/secondary david

sudo -H -u david bash -c gsettings set org.x.apps.favorites list "['computer:///::inode/directory', 'file:///home/david::inode/directory', 'file:///media/secondary::inode/directory', 'file:///media/secondary/Dropbox::inode/directory', 'file:///media/secondary/repos::inode/directory']"


#echo "### Setting panel settings ###" ##############################################################################
#sudo -H -u david bash -c 


echo "### Setting system audio volume to 0 (Muted) ###" ################################################################
xdotool key XF86AudioLowerVolume
xdotool key XF86AudioLowerVolume
xdotool key XF86AudioLowerVolume
xdotool key XF86AudioLowerVolume
xdotool key XF86AudioLowerVolume
xdotool key XF86AudioLowerVolume


echo "### Installing common programs ###" ###############################################################################
apt install -y tmux
apt install -y vim
apt install -y git
apt install -y htop
apt install -y mint-meta-codecs
apt install -y feh
apt install -y xdotool
apt install -y github-desktop
apt install -y barrier
apt install -y dropbox
apt install -y flameshot
apt install -y k4dirstat


echo "### Installing common programs, flatpak edition ###" ###############################################################################
flatpak install -y com.github.dail8859.NotepadNext


# Language packs
apt install -y wbritish
apt install -y firefox-l10n-en

echo "### Adding barrier config ###" ###############################################################################
BARRIER_CONFIG_DIR="$USER_HOME/.config/Debauchee"
if [ ! -f "$BARRIER_CONFIG_DIR" ]; then
    mkdir -p "$BARRIER_CONFIG_DIR"
    curl https://raw.githubusercontent.com/PockyBum522/linux-files/master/configuration/dotfiles/Barrier.conf > "$BARRIER_CONFIG_DIR/Barrier.conf"

    if [ "$HOSTNAME" = DAVID-LAPTOP ]; then
        cat >> "$USER_HOME/.config/autostart/barrier.desktop"<<EOF 
[Desktop Entry]
Type=Application
Name=Barrier
Comment=Keyboard and mouse sharing solution
Exec=barrier
Icon=barrier
Terminal=false
Categories=Utility;RemoteAccess;
Keywords=keyboard;mouse;sharing;network;share;
X-GNOME-Autostart-enabled=true
NoDisplay=false
Hidden=false
Name[en_US]=Barrier
Comment[en_US]=Keyboard and mouse sharing solution
X-GNOME-Autostart-Delay=15

EOF
    fi
fi


echo "### Adding tmux config ###" ###############################################################################
curl https://raw.githubusercontent.com/PockyBum522/linux-files/master/configuration/dotfiles/.tmux.conf > "$USER_HOME/.tmux.conf"


echo "### Adding vim config ###" ###############################################################################
curl https://raw.githubusercontent.com/PockyBum522/linux-files/master/configuration/dotfiles/.vimrc > "$USER_HOME/.vimrc"


echo "### Disabling LMDE welcome dialog at startup ###" ################################################################
if [ ! -f "$USER_HOME/.config/autostart/mintwelcome.desktop" ]; then
    cat >> "$USER_HOME/.config/autostart/mintwelcome.desktop"<<EOF 
[Desktop Entry]
Encoding=UTF-8
Name=mintwelcome
Comment=Linux Mint Welcome Screen
Icon=mintwelcome
Exec=mintwelcome-launcher
Terminal=false
Type=Application
Categories=
X-GNOME-Autostart-enabled=false

EOF

fi


echo "### Downloading latest beeper appimage ###" #########################################################################
if [ ! -f "$BEEPER_INSTALLS_DIR/Beeper-Cloud.appimage" ]; then
    curl https://download.beeper.com/linux/appImage/x64 > "$BEEPER_INSTALLS_DIR/Beeper-Cloud.appimage"
fi

chmod +x "$BEEPER_INSTALLS_DIR/Beeper-Cloud.appimage"

if [ ! -f "$USER_HOME/Desktop/Beeper" ]; then
    ln -s "$BEEPER_INSTALLS_DIR/Beeper-Cloud.appimage" "$USER_HOME/Desktop/Beeper"
fi


echo "### Downloading and installing jetbrains toolbox ###" ##############################################################
TMP_DIR="/tmp"
INSTALL_DIR="$USER_HOME/.local/share/jetbrains/toolbox/bin"
SYMLINK_DIR="$USER_HOME/.local/bin"

echo -e "\e[94mFetching the URL of the latest version...\e[39m"
ARCHIVE_URL=$(curl -s 'https://data.services.jetbrains.com/products/releases?code=TBA&latest=true&type=release' | grep -Po '"linux":.*?[^\\]",' | awk -F ':' '{print $3,":"$4}'| sed 's/[", ]//g')
ARCHIVE_FILENAME=$(basename "$ARCHIVE_URL")

echo -e "\e[94mDownloading $ARCHIVE_FILENAME...\e[39m"
rm "$TMP_DIR/$ARCHIVE_FILENAME" 2>/dev/null || true
wget -q --show-progress -cO "$TMP_DIR/$ARCHIVE_FILENAME" "$ARCHIVE_URL"

echo -e "\e[94mExtracting to $INSTALL_DIR...\e[39m"
mkdir -p "$INSTALL_DIR"
rm "$INSTALL_DIR/jetbrains-toolbox" 2>/dev/null || true
tar -xzf "$TMP_DIR/$ARCHIVE_FILENAME" -C "$INSTALL_DIR" --strip-components=1
rm "$TMP_DIR/$ARCHIVE_FILENAME"
chmod +x "$INSTALL_DIR/jetbrains-toolbox"

echo -e "\e[94mSymlinking to $SYMLINK_DIR/jetbrains-toolbox...\e[39m"
mkdir -p "$SYMLINK_DIR"
rm "$SYMLINK_DIR/jetbrains-toolbox" 2>/dev/null || true
ln -s "$INSTALL_DIR/jetbrains-toolbox" "$SYMLINK_DIR/jetbrains-toolbox"

if [ -z "$CI" ]; then
	echo -e "\e[94mRunning for the first time to set-up...\e[39m"
	( "$INSTALL_DIR/jetbrains-toolbox" & )
	echo -e "\n\e[32mDone! JetBrains Toolbox should now be running, in your application list, and you can run it in terminal as jetbrains-toolbox (ensure that $SYMLINK_DIR is on your PATH)\e[39m\n"
else
	echo -e "\n\e[32mDone! Running in a CI -- skipped launching the AppImage.\e[39m\n"
fi

sudo chown david $USER_HOME/.local/share"


echo "### Adding $USER_HOME/.local/bin to PATH ###" ######################################################################
echo -e "\nexport PATH=\"$USER_HOME/.local/bin:$PATH\"" >> "$USER_HOME/.bashrc"


echo "### Installing Yubico Authenticator ###" ###########################################################################
apt-get -y install pcscd
systemctl enable --now pcscd

mkdir -p "$APP_INSTALLS_DIR/yubico-authenticator"

if [ ! -f "$APP_INSTALLS_DIR/yubico-authenticator/Yubico-Authenticator.appimage" ]; then
    curl https://developers.yubico.com/yubioath-flutter/Releases/yubioath-desktop-latest-linux.AppImage > "$APP_INSTALLS_DIR/Yubico-Authenticator/Yubico-Authenticator.appimage"
fi

chmod +x "$APP_INSTALLS_DIR/yubico-authenticator/Yubico-Authenticator.appimage"

if [ ! -f "$USER_HOME/Desktop/Authenticator" ]; then
    ln -s "$APP_INSTALLS_DIR/yubico-authenticator/Yubico-Authenticator.appimage" "$USER_HOME/Desktop/Authenticator"
fi


if [ "$HOSTNAME" = DAVID-LAPTOP ]; then
    echo "### Installing nvidia driver ###" 
    apt install -y nvidia-driver ;; ###########################################################################

    # Set DPI fractional scaling on
    gsettings set org.cinnamon.muffin experimental-features "['scale-monitor-framebuffer', 'x11-randr-fractional-scaling']"
fi

if [ "$HOSTNAME" = DAVID-DESKTOP ]; then
    echo "### Installing nvidia driver ###" 
    apt install -y nvidia-driver ;; ###########################################################################
fi
