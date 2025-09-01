#!/usr/bin/env bash
ANDROID_PATH="/sdcard/SyncedPdf"

if ! adb devices | grep -q "device$";then
  /home/hl/.local/bin/connect_phone_adb
fi

dunstify "Start Syncing..." -a "system_status"  -i xsi-emblem-synchronizing-symbolic 

for FILE in "$@"; do
  FILENAME=$(basename "$FILE")
  if adbsync push "$FILE" "$ANDROID_PATH/";then
    dunstify "PDF SYNC" "$FILENAME" -i xsi-emblem-synchronizing-symbolic
  else
    dunstify "PDF SYNC" "ERROR" -u critial -i xsi-emblem-synchronizing-symbolic
    exit 1
  fi
done
