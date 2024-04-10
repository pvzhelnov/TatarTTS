#!/bin/bash

# Credit: ChatGPT 3.5 with modifications

basedir=models

# Check if all required arguments are provided
if [ $# -lt 4 ]; then
    echo "Usage: $0 <phrase> <output_filename> <voice> <output_format>"
    exit 1
fi

# Assigning arguments to variables
phrase=$1
output_filename=$2
voice=$3
output_format=$4

# Check if the output audio file format is supported
supported_formats=("wav" "m4a" "ogg" "mp3")
if ! [[ " ${supported_formats[@]} " =~ " $output_format " ]]; then
    echo "Unsupported input audio format: $output_format. Supported formats: ${supported_formats[*]}"
    exit 1
fi

# Supported voices
supported_voices=("female" "male")

# Check if the voice is supported
if ! [[ " ${supported_voices[@]} " =~ " $voice " ]]; then
    echo "Unsupported voice: $voice. Supported voices: ${supported_voices[*]}"
    exit 1
fi

# Run the command with the provided phrase, output file name, and voice
echo "$phrase" | "$basedir"/piper --model "$basedir/$voice/$voice.onnx" --config "$basedir/$voice/config.json" --output_file "$output_filename.wav"

# Check if conversion is needed
case "$output_format" in
    m4a)
        ffmpeg -i "$output_filename.wav" -c:a aac "$output_filename.$output_format"
        # Remove the intermediate wav file
        rm "$output_filename.wav"
        ;;
    ogg)
        ffmpeg -i "$output_filename.wav" -acodec libopus "$output_filename.ogg" # lib opus for telegram to show as a spectrogram
        # Remove the intermediate wav file
        rm "$output_filename.wav"
        ;;
    mp3)
        ffmpeg -i "$output_filename.wav" -acodec libmp3lame "$output_filename.$output_format"
        # Remove the intermediate wav file
        rm "$output_filename.wav"
        ;;
    *)
        ;;
esac

# Save this script in a file named tts.sh, make it executable with the command chmod +x tts.sh, and then you can run it like this:

# ./tts.sh "Аның чыраенда тәвәккәллек чагыла иде." welcome female ogg

# Replace "Аның чыраенда тәвәккәллек чагыла иде." with the desired phrase, welcome with the desired output file name (without the extension), female with either female or male depending on the desired voice model, and file extension depending on the desired audio format (wav, m4a, ogg, or mp3).
