#!/bin/bash

# set input file names

png_files=$(find /Users/samchin/dev/SoundspindleExperiment/data/criterion -name "*.png")
wav_files=$(find /Users/samchin/dev/SoundspindleExperiment/data/criterion -name "*.wav")

# echo $file
for file in $png_files
do
    image_file=$file
    name=`echo "$file" | cut -d'.' -f1`
    audio_file="$name.wav"
    cropped_file="$name-cropped.png"
    lpf_audio="$name-lpf.wav"


    if [ $image_file == "$name.png" ] && [ $audio_file == "$name.wav" ]; then

        # ffmpeg -i "$audio_file" -ar 44100 -filter:a "lowpass=f=500" -y "$lpf_audio"

        # ffmpeg -i $image_file -vf  "crop=1900:1550:0:0" -y $cropped_file

        # ffmpeg -loop 1 -i "$cropped_file" -i "$lpf_audio" -c:v libx264 -quality best -crf 22 -shortest -y "$name.mov"

        # # ffmpeg -loop 1 -i "$cropped_file" -i "$lpf_audio" -c:v libx264 -quality best -crf 22 -shortest -vcodec h264 -acodec aac  -y "$name.mp4"

        # ffmpeg -i "$name.mov" -c:v libvpx -crf 10 -b:v 1M -c:a libvorbis -y "$name.webm"

        #rm "$name-cropped.png" "$name.mov"  "$name-lpf.wav" 

        sox -v 0.98 "$name.wav"  -r 44100 "$name.intermediate.wav" fade t 0.15 0 0.15

        mv "$name.intermediate.wav" "$name.wav"

    fi

done

