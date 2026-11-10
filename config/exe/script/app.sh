#!/usr/bin/env bash

# ==================================================
# GESTION DES APPLICATIONS
# Syntaxe : app [option] <application>
# ==================================================

# --------------------------------------------------
# AIDE
# --------------------------------------------------

usage() {
    cat <<'EOF'
Utilisation :
  app <application>       Ouvrir / démarrer
  app -o <application>    Ouvrir / démarrer
  app -c <application>    Fermer
  app -p <application>    Mettre en pause
  app -r <application>    Reprendre
  app -f <application>    Redémarrer
  app -u <application>    Désinstaller (non configuré dans cette version)
  app -sf <application>  Arrêter de force

Applications connues :
  brave, chrome, chromium, floorp, zen,
  codium, obsidian, virtualbox, vmware,
  osu, curseforge, decibels
EOF
}

# --------------------------------------------------
# VERIFICATION DES ARGUMENTS
# --------------------------------------------------

option=""
application=""

if [ "$#" -eq 1 ]; then
    application="$1"
elif [ "$#" -eq 2 ]; then
    option="$1"
    application="$2"
else
    usage
    exit 1
fi

case "$option" in
    ""|-o|-c|-p|-r|-f|-u|-sf) ;;
    *)
        echo "Erreur : option inconnue : $option"
        usage
        exit 1
        ;;
esac

# --------------------------------------------------
# LANCEMENT DES APPLICATIONS
# --------------------------------------------------

launch_application() {
    case "$application" in
        brave)      brave-browser & ;;
        chrome)     google-chrome-stable & ;;
        chromium)   chromium & ;;
        floorp)     flatpak run one.ablaze.floorp & ;;
        zen)        flatpak run app.zen_browser.zen & ;;
        codium)     codium & ;;
        obsidian)   "$HOME/Applications/Obsidian/Obsidian.AppImage" & ;;
        virtualbox) virtualbox & ;;
        vmware)     vmware & ;;
        osu)        "$HOME/Applications/Games/osu/osu.AppImage" & ;;
        curseforge) "$HOME/Applications/Games/mincraft/CurseForge/CurseForge.AppImage" & ;;
        decibels)   flatpak run org.gnome.Decibels & ;;
        *)
            echo "Erreur : application inconnue : $application"
            return 1
            ;;
    esac

    echo "Demande de lancement envoyée : $application"
}

# --------------------------------------------------
# NOMS DES PROCESSUS
# --------------------------------------------------

case "$application" in
    brave)      process_name="brave-browser" ;;
    chrome)     process_name="chrome" ;;
    chromium)   process_name="chromium" ;;
    floorp)     process_name="floorp" ;;
    zen)        process_name="zen" ;;
    codium)     process_name="codium" ;;
    obsidian)   process_name="obsidian" ;;
    virtualbox) process_name="VirtualBox" ;;
    vmware)     process_name="vmware" ;;
    osu)        process_name="osu!" ;;
    curseforge) process_name="CurseForge" ;;
    decibels)   process_name="decibels" ;;
    *)
        echo "Erreur : application inconnue : $application"
        exit 1
        ;;
esac

# --------------------------------------------------
# EXECUTION DE L'ACTION
# --------------------------------------------------

case "$option" in
    ""|-o)
        launch_application
        exit $?
        ;;

    -c)
        if pkill -TERM -x "$process_name"; then
            echo "Demande de fermeture envoyée : $application"
        else
            echo "Aucun processus correspondant trouvé : $application"
            exit 1
        fi
        ;;

    -p)
        if pkill -STOP -x "$process_name"; then
            echo "Application mise en pause : $application"
        else
            echo "Impossible de mettre en pause : $application"
            exit 1
        fi
        ;;

    -r)
        if pkill -CONT -x "$process_name"; then
            echo "Application reprise : $application"
        else
            echo "Impossible de reprendre : $application"
            exit 1
        fi
        ;;

    -f)
        pkill -TERM -x "$process_name" 2>/dev/null || true
        sleep 1
        launch_application
        exit $?
        ;;

    -sf)
        if pkill -KILL -x "$process_name"; then
            echo "Arrêt forcé effectué : $application"
        else
            echo "Aucun processus correspondant trouvé : $application"
            exit 1
        fi
        ;;

    -u)
        echo "Désinstallation non configurée pour cette application."
        echo "Définir la méthode d'installation avant d'autoriser sa suppression."
        exit 2
        ;;
esac
