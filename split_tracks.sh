#!/bin/bash

INPUT="Diablo2Soundtrack_MelodicMetal_FractalHaze.flac"
OUTDIR="tracks"
mkdir -p "$OUTDIR"

# Format: "start_time|end_time|title"
# Use "END" as the end_time for the last track
tracks=(
  "0:00|6:21|01 - Main Theme - Lord of Destruction"
  "6:21|10:49|02 - Main Menu - Options Credits"
  "10:49|17:16|03 - Rogue Encampment"
  "17:16|24:57|04 - Wilderness"
  "24:57|29:36|05 - Caves"
  "29:36|34:08|06 - Crypt"
  "34:08|41:53|07 - Tristram"
  "41:53|47:21|08 - Monastery"
  "47:21|54:12|09 - Lut Gholein"
  "54:12|57:48|10 - Sewers"
  "57:48|1:05:33|11 - Desert"
  "1:05:33|1:12:15|12 - Tombs"
  "1:12:15|1:19:30|13 - Maggot Lair"
  "1:19:30|1:27:53|14 - Valley"
  "1:27:53|1:34:42|15 - Harem"
  "1:34:42|1:38:25|16 - Arcane Sanctuary"
  "1:38:25|1:44:47|17 - Kurast Docks"
  "1:44:47|1:51:18|18 - Jungle"
  "1:51:18|1:58:08|19 - Spider Cavern"
  "1:58:08|2:05:34|20 - Travincal"
  "2:05:34|2:13:07|21 - Durance of Hate"
  "2:13:07|2:20:30|22 - Pandemonium Fortress"
  "2:20:30|2:28:09|23 - Mesa - Act IV Area"
  "2:28:09|2:35:24|24 - Chaos Sanctuary - Diablo"
  "2:35:24|2:42:43|25 - Harrogath"
  "2:42:43|2:49:46|26 - Siege"
  "2:49:46|2:57:53|27 - Ice Caves"
  "2:57:53|3:04:41|28 - Temple"
  "3:04:41|3:15:24|29 - Worldstone Keep - Baal"
  "3:15:24|3:24:05|30 - Return to Tristram - Super Ubers"
  "3:24:05|END|31 - Bonus Track - Tristram - Diablo I"
)

for track in "${tracks[@]}"; do
  IFS='|' read -r start end title <<< "$track"
  output="$OUTDIR/${title}.flac"

  if [ "$end" = "END" ]; then
    ffmpeg -i "$INPUT" -ss "$start" -c copy "$output" -loglevel error -stats
  else
    ffmpeg -i "$INPUT" -ss "$start" -to "$end" -c copy "$output" -loglevel error -stats
  fi

  echo "Created: $output"
done

echo "Done. All tracks in $OUTDIR/"