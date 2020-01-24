from scipy import signal
import numpy as np
import matplotlib.pyplot as plt


timeseries=np.ones(10000)
n = 1000
freqs, power = signal.welch(timeseries, fs=1000, window=signal.get_window('hamming', 5000), nperseg=5000, noverlap=2500, nfft=None, detrend='constant', return_onesided=True, scaling='density', axis=-1)

plt.plot(freqs)
plt.ylabel('some numbers')
plt.show()



function y = calculateLF_HF(data)%assumes that RR interval series is an evenly sampled signal.
normalize = 29;%since F vector starts from 30.
%Get the power spectral density of the signal using Welch's Method. PSD is
%acquired between 30mHz-860mHZ.
[Pxx,F] = pwelch(double(data), 250, 125,[30:860] ,1000);
LFband = 40:150;%Define the low freqency band
LFdensity = Pxx(40-normalize:150-normalize);%Get the low frequency density.
LFpower = trapz(LFband,LFdensity);%Integrate the density over the low frequency range to get the LF power.
HFband = 150:400;%Define the high freqency band
HFdensity = Pxx(150-normalize:400-normalize);%Get the high frequency density.
HFpower = trapz(HFband,HFdensity);%Integrate the density over the high frequency rangeto get the HF power.
y= LFpower/HFpower; %Get the ratio.
end
