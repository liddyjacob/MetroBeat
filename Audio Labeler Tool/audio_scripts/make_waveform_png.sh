#!/usr/bin/env bash

echo $1
ffmpeg -y -i "$1" -filter_complex "aformat=channel_layouts=mono,compand=gain=-10, showwavespic=s=10000x500:colors=blue|blue" -frames:v 1  waveform.png 
