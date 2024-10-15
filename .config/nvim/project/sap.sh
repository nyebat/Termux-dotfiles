#!/usr/bin/env bash

TARGET_DIR="storage/shared/Download/YTDLnis/Audio/"

# cek path
if [ ! -d "$TARGET_DIR" ]; then
    echo "Direktori tidak ditemukan!"
    exit 1
fi

# collect file and send to list
IFS=$'\n' read -r -d '' -a FILES <<< $(ls "$TARGET_DIR")

# cek file
if [ ${#FILES[@]} -eq 0 ]; then
    echo "Tidak ada file di direktori $TARGET_DIR"
    exit 1
fi

# buat list menu
MENU_OPTIONS=("." "")
for file in "${FILES[@]}"; do
    MENU_OPTIONS+=("$file" "")
done

while true; do
    CHOSEN_FILE=$(
        whiptail --title "Simple Audio Player" \
        --menu "List: " \
        --ok-button "Play" \
        --cancel-button "Exit" \
        10 65 0 \
        "${MENU_OPTIONS[@]}" \
        3>&1 1>&2 2>&3
    )

    # cek exit code
    if [ $? = 0 ]; then
        clear
        if [ "$CHOSEN_FILE" == "." ]; then
            ls $TARGET_DIR && echo -e "\n"
        else
            echo -e "Playing: $CHOSEN_FILE ...\n"
        fi

        mpv "${TARGET_DIR}$CHOSEN_FILE"
    else
        break
    fi
done
