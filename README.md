# MetroBeat Tempo and Beat analyzer

This repository contains the code for labeling audio data and creating a machine learning model that
will automatically label the beat track in a song. Once this is complete, a new repository will be 
made for creating my own music visualizer tool.

## Overview

### Motivation

I've always wanted to make my own music visualizer, as I grew up in the 2000s when they were 
prevalent. I wanted to make mine inspired by the cartoons seen on Teenage Engineering devices, but
with a "nintendo-like" quality where the tempo and key signature are elemental to the 
visualizations going on(For example, Super Mario Odessey integrates its music into the world around
you)

Most visualizers do not do this. Instead, they focus on showing frequencies based off STFT, basing
visuals almost soely on the spectrogram and amplitude. This limited information leads to most audio
visualizers doing more-or-less the same thing.

To expand the possibilities of the music visualizer that I am designing, I need to first understand 
the tempo of a song. Further, I must understand when a song is changing tempo or time signature. 
This leads me to finding the "beats" of a song, so that I can help my visualizer understand the 
pulse of a song. While this may feel subjective, most musicians, especially percussionists and 
producers, will agree on the "pulse" or "feel" of a song. This is often the basis to how improvised
music is made.

I first tried to solve this problem by using existing tools. Librosa has a `beat\_track` function
that works well enough on popular songs, especially more formulaic Pop and Rock. However,
this model fails for modern music in genres such as Jazz, Hip-Hop, and IDM. Especially on tracks
with non-standard time signatures, such as 7/8. Therefore I intend on creating a machine learning
tool that will identify the beats of songs outside of older pop and rock. Selfishly, I want this
to work best on the music that I listen too, but I will be even happier if I can create a model 
that is best in class across a very wide variety of genres.

### Approach

While I could probably find a decent set of music tracks with annotated beats / tempo, I'd like to 
use this opportunity to understand audio from the ground up. Therefore I am starting with nothing 
but unlabeled audio data. I indent to create a tool to help me annotate the music myself, and 
then use this tool to label hundreds of tracks myself. 

Once I have labeled music, I will import it into a programming language and build my model from 
the ground up. I may reference other guides for help, but understand that this project is not
just another codecademy or medium exercise - this is a wholly original project so that I can 
learn everything from the basics to exploring my own, original ideas.

Finally I intend to deploy this project on the web, so that anyone can label the music they have.
I may also release a version of this as a plug in VST for Digital Audio Workstations such as Logic
and Ableton.

## Details

The following sections will detail each step of the process

### Data Labeling 


This section will be more thorogh later, but for now here are some details:
* I am using Godot to buily my labeler
* I am integrating python into godot when necessary, for access to librosa and numpy
* Godot is only needed for labeling, once the data is labeled the tool will not be
needed for interpretation.
* Here is a screenshot of the tool so far. Top is the amplitude over time, middle is the wave-form,
bottom is song progess. Blue lines are music annotations.


![Image of Audio Labeling Tool](https://github.com/liddyjacob/MetroBeat/blob/main/GithubReadmeResources/AudioTool.png?raw=true)
