# MetroBeat Tempo and Beat analyzer


![Image of Audio Labeling Tool](https://github.com/liddyjacob/MetroBeat/blob/main/GithubReadmeResources/AudioTool.png?raw=true)
librosa's Beat and Tempo detection methods fail for some examples, especially those in 6/8. This project serves as a way to improve beat detection.

First thing is first, we need some audio to analyze. As an exercise in bringing a project from scratch to finish, I will build an audio labeling tool. This will be done in the game engine Godot

I think I need to decide on a valid range of 'clicks' per minute. Note this is not tempo, for if a song is too slow, we will measure the eigth notes per measure instead of the typical quarter notes, for example.


