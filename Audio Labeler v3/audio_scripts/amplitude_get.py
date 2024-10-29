import numpy as np
import librosa
import sys


if __name__ == "__main__":
    time_series, _ = librosa.load(sys.argv[1], sr=5000)
    ts_squared = np.cumsum(time_series ** 2)
    amplitudes_over_10ms = ts_squared[50:] - ts_squared[:-50]
    rme_10ms = np.sqrt(amplitudes_over_10ms / 50)

    np.savetxt('amp.txt', np.concatenate([np.array([0] * 50), rme_10ms, np.array([0] * 50)]))
