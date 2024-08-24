import librosa
import sys
import numpy
numpy.set_printoptions(threshold=sys.maxsize)

import warnings
warnings.filterwarnings("ignore")


if __name__ == "__main__":
    time_series, sr = librosa.load(sys.argv[1])
    print(time_series[0:1000000])
