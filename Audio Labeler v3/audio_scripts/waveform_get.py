import librosa
import sys
import numpy
import pandas as pd
import warnings
warnings.filterwarnings("ignore")

if __name__ == "__main__":
    time_series, _ = librosa.load(sys.argv[1], sr=6000)
    numpy.savetxt('output.txt', time_series)
