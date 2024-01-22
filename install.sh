# UshOS Install Script
cat <<'EOF'                                                           
 ,---.   ,--.                 ,--.,--.       ,--.       ,--.   
'   .-',-'  '-. ,--,--.,--.--.|  |`--' ,---. |  ,---. ,-'  '-. 
`.  `-.'-.  .-'' ,-.  ||  .--'|  |,--.| .-. ||  .-.  |'-.  .-' 
.-'    | |  |  \ '-'  ||  |   |  ||  |' '-' '|  | |  |  |  |   
`-----'  `--'   `--`--'`--'   `--'`--'.`-  / `--' `--'  `--'   
                                      `---'                       
EOF

starlight_theme() {
    curl -s --compressed "https://raw.githubusercontent.com/Lrdsnow/StarLightLinux/main/Repo/KEY.gpg" | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/starlightrepo.gpg >/dev/null
    sudo curl -s --compressed -o /etc/apt/sources.list.d/starlightrepo.list "https://raw.githubusercontent.com/Lrdsnow/StarLightLinux/main/Repo/starlightrepo.list"
    sudo apt update
    sudo apt install -y starlightgtk
    if ! command -v "cinnamon" &> /dev/null; then
        read -r -p "Install Cinnamon Desktop? (required for starlight) [y/N] " response
        case "$response" in
            [yY][eE][sS]|[yY]) 
                sudo apt install -y cinnamon
                ;;
            *)
                echo Exiting...
                exit 1
                ;;
            esac
    fi
    gsettings set org.cinnamon.theme name 'starlight'
    gsettings set org.cinnamon.desktop.wm.preferences theme 'starlight'
}

ios_tools() {
    sudo apt install -y libimobiledevice-dev
    mkdir ~/tmp
    wget https://github.com/palera1n/palera1n/releases/download/v2.0.0-beta.5/palera1n-linux-x86_64 -O ~/tmp/palera1n
    sudo mv ~/tmp/palera1n /usr/bin/palera1n
    sudo chmod +x /usr/bin/palera1n
    wget https://assets.checkra.in/downloads/linux/cli/x86_64/dac9968939ea6e6bfbdedeb41d7e2579c4711dc2c5083f91dced66ca397dc51d/checkra1n -O ~/tmp/checkra1n
    sudo mv ~/tmp/checkra1n /usr/bin/checkra1n
    sudo chmod +x /usr/bin/checkra1n
    rm -rf ~/tmp
    echo "Installed palera1n, checkra1n and libimobiledevice"
}

devtools() {
    mkdir ~/tmp
    wget "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64" -O ~/tmp/vscode.deb
    sudo apt install -y ~/tmp/vscode.deb build-essential python3 python3-pip
    rm -rf ~/tmp
    echo "Installed vscode, build-essentail, python3, python3-pip"
}

show_menu() {
    echo "Choose an option:"
    echo "[a] Install themes"
    echo "[b] Install devtools"
    echo "[c] Install iOS tools"
    echo "[d] Install everything"
    echo "[q] Quit"
}

while true; do
    show_menu
    read -p "Enter your choice: " choice

    case $choice in
        [aA])
            starlight_theme
            ;;
        [bB])
            devtools
            ;;
        [cC])
            ios_tools
            ;;
        [dD])
            devtools
            ios_tools
            starlight_theme
            ;;
        [qQ])
            echo "Quitting..."
            exit 0
            ;;
        *)
            echo "Invalid choice. Please try again."
            ;;
    esac
done
