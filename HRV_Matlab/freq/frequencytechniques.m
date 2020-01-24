fid = fopen('math.txt');%Open the desired file.Here, you need to put the name of the file you want to perform HRV analysis on.
S = textscan(fid,'%s');%Scanning the text file. The file should consist of the RR intervals as a column.
S= S{1};%Previous function forms S as a cell matrix, we only want the first cell.
N = cellfun(@(x)str2double(x), S);%We transform the cell into a column vector and convert the strings into double for processing.
N=transpose(N);%Vectors in matlab are processed as a row vector more easily.Hence, transpose it into a row vector.
data = N;
data = data(data>=400 & data<=2000); %Filtering of non-biological RR interval might be necessary sometimes, due to the glitches in the device.
figure()
stem(data);%OPTIONAL: Plot the RR interval series on a discrete scale.

%For post-processing, use these. these will give just a number and/or a
%power spectral density plot of the RR interval signal(optional).

%The first function which assumes that RR interval series is an evenly
%sampled signal.
% calculateLF_HF(data)

%The second function does not assume that RR interval series is an evenly
%sampled signal and processes accordingly.(MORE ACCURATE)
calculateLF_HF3(data)

%For online procesing use these. These will produce a plot for LF/HF ratio.
%WARNING, before executing these lines of code, make sure that power
%spectral density plotting part in the function is commented, otherwise
%it will produce lots of plots.Note:For an RR interval vector with length
%500 it approximately takes 10 minutes.
RRdata =[];
pre = 20;
LF_HF =[];
for i = 1:pre
    RRdata = [RRdata data(1)]; % For the measure to make sense, placing the first pre(adjustable) element of data(big data) to RRdata(data to be processed each time)
    data(1) =[];
end

n = 1:length(data);
for i = n % Each time a new RR interval arrives, HRV measures should be calculated, for online processing.
    RRdata = [RRdata data(1)];
    data(1) =[];
    LF_HF(i) = calculateLF_HF3(RRdata);
end

%Plot the LF/HF curve over time
figure()
plot(n,LF_HF)
xlabel('n')
ylabel('LF/HF ratio')


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

function y = calculateLF_HF3(data)%does not assume that RR interval series is an evenly
%sampled signal and processes accordingly.(MORE ACCURATE)
sum =0;
tRR =[];%tRR is the time vector indicating which element of the data is sampled when. For example data[4] is sampled at tRR[4]
%To get the tRR[i], we sum all the elements of data up to data[i].
for i = 1:length(data)
    sum = sum + data(i);
    tRR(i) = sum;
end

%Get the power spectral density of data sampled at instances at tRR. tRR is
%converted into the seconds, because the frequencies should be in units of
%Hz.
[P,F]= plomb(data,tRR./(1000),500,4);

%If you want to see the PSD,uncomment the following two lines.
%WARNING:if you are performing online-processing, do not uncomment as it
%will produce n plots, where n is the size of the RR intervals.
% plot(F,P);
% xlim([0.03 0.4]);

%To find the index of the elements in the F(frequency vector) corresponding
%to the desired frequency bands,i.e LF and HF, use these loops.
count = 1;
while(F(count)<0.04)
    count = count+1;
end
LFlow = count;
while(F(count)<0.15)
    count = count+1;
end
LFhigh= count;
HFlow = count-1;
while(F(count)<0.4)
    count = count+1;
end
HFhigh= count;
%Once the indexes are found, go ahead and get the bands and the corresponding densities.
LFband = F(LFlow:LFhigh);
LFdensity = P(LFlow:LFhigh);
HFband = F(HFlow:HFhigh);
HFdensity = P(HFlow:HFhigh);
%Integrate the densities over the desired ranges to find the total power of
%LF and HF band.
LFpower = trapz(LFband,LFdensity);
HFpower = trapz(HFband,HFdensity);
%Take the ratio.
y= LFpower/HFpower;
end