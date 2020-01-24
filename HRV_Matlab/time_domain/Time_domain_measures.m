close all
fid = fopen('relax.txt');%Open the desired file.Here, you need to put the name of the file you want to perform HRV analysis on.
S = textscan(fid,'%s');%Scanning the text file. The file should consist of the RR intervals as a column.
S= S{1};%Previous function forms S as a cell matrix, we only want the first cell.
N = cellfun(@(x)str2double(x), S);%We transform the cell into a column vector and convert the strings into double for processing.
N=transpose(N);%Vectors in matlab are processed as a row vector more easily.Hence, transpose it into a row vector.
data = N;%We get our data.
data = data(data>=400 & data<=2000); %Filtering of non-biological RR interval might be necessary sometimes, due to the glitches in the device.
stem(data);%OPTIONAL: Plot the RR interval series on a discrete scale.
%Filtering can be also performed manually by looking at the plot and
%Deleting the non-biological RR intervals.

%For post-processing, use these. these will give just a number.for each time
%domain measure of HRV.

% calculateSDRR(data)
% calculatepNN50(data)
% calculateRMSSD(data)
% calculateHTI(data)
% calculateTINN(data)

%For online procesing use these. These will produce a plot for each time
%domain measure of HRV.
RRdata =[];%To simulate online processing, this is the vector that will be updated each time when a new RR interval arrives by 
%concatenating that new interval to this vector.
SDRR = [];
pNN50 = [];
RMSSD = [];
HTI = [];
TINN = [];% time domain measures of HRV that will be updated by concatenating the new value of that measure when a new RR interval arrives.
for i = 1:40 % For the measures to make sense, placing the first 40 element of data(big data) to RRdata(data to be processed each time)
    RRdata = [RRdata data(1)];
    data(1) =[];
end
n = 1:length(data);
for i = n % Each time a new RR interval arrives, HRV measures should be calculated, for online processing.
    RRdata = [RRdata data(1)];
    data(1) =[];
    SDRR(i) = calculateSDRR(RRdata);
    pNN50(i) = calculatepNN50(RRdata);
    RMSSD(i) = calculateRMSSD(RRdata);
    HTI(i) = calculateHTI(RRdata);
    TINN(i) = calculateTINN(RRdata);
end
figure()
plot(n,SDRR)
xlabel('n')
ylabel('SDRR')
figure()
plot(n,pNN50)
xlabel('n')
ylabel('pNN50')
figure()
plot(n,RMSSD)
xlabel('n')
ylabel('RMSSD')
figure()
plot(n,HTI)
xlabel('n')
ylabel('HTI')
figure()
plot(n,TINN)
xlabel('n')
ylabel('TINN')
% plot them to see change of the measures each time new data arrives.

function y = IBItoHR(a)% If the data is RR intervals,converts it to heart rate form.
y = 60000./a;%can be used for HRmax-HRmin
end%mainly useless.
function y = calculateSDRR(a)%Standard Deviation =(variance)^1\2 in units of ms.
y = var(a);
y = sqrt(y);
end
function y = calculatepNN50(a)%The percentage of pairs of successive  (R-R) intervals that differ by more than 50 ms
count = 0;%returns a number between 0 and 1.
for i = 1 : (length(a)-1)%count the number of (R-R) intervals that differ by more than 50 ms
    if(abs(a(i)-a(i+1))>= 50)
        count=count+1;
    end
end
y=count/(length(a)-1);%get the percentage.
end

function y = calculateHRmax_HRmin(a)%input is heart rates(bpm). calculates the max and min heart rates and returns the difference of them.
y = max(a)-min(a);
end

function y = calculateRMSSD(a) % root mean square of the successive diferrences
y = 0;
for i = 1 : (length(a)-1)
    y=y+(a(i)-a(i+1))^2; % sum of square of the successive diferrences
end
y = y/(length(a)-1); % mean square of the successive diferrences
y = sqrt(y);% root mean square of the successive diferrences
end
function y = calculateHTI(a)%Calculates HRV triangular index. That is, get the histogram of the RR intervals, then integrate the probability density function over all possible values.
% Then, divide it by the maximum of the histogram.
binNo =int8(calculateHRmax_HRmin(a)/7.8125);%adjustable bin number correspondin to bin size of 7.8125. 7.8125 is suggested by the main HRV paper.
%If you want to see the histogram, uncomment the following line.
%WARNING:if you are performing online-processing, do not uncomment as it
%will produce n plots, where n is the size of the RR intervals.
% histfit(a,binNo); 
% figure()
[N,edges] = histcounts(a,binNo); %getting the frequencies in N and the corresponding RR interval bins. in edges. length(edges)=binNo+1
%interpolate the histogram the get the probability density function(pdf)
interN = interp1(edges(1:binNo),N,min(edges):0.5:max(edges),'spline');
% take the integral
y = trapz(min(edges):0.5:max(edges),interN./15); % trapezoidal vector integral(integral of the corresponding splinely interpolated continous signal)
%divide it by the maximum frequency of the histogram.
y = y/max(N);
end
function out = calculateTINN(a)%Baseline width of the Triangular interpolation of the histogram of NN(RR) intervals.
binNo =int8(calculateHRmax_HRmin(a)/7.8125);%adjustable bin number correspondin to bin size of 7.8125
[N,edges] = histcounts(a,binNo); %getting the frequencies in N and the corresponding RR interval bins in edges. length(edges)=binNo+1
%What we do here is, to divide the histogram into two pieces, to the left
%of the maximum and to the right of the maximum.
%Than we fit a line to each of these two data points using linear
%regression.
% what we end up with these two lines is the triangular interpolation of
% the histogram.
[Y,maxIndex] = max(N);
topPoint = [mean([edges(maxIndex) edges(maxIndex+1)]) N(maxIndex)]; % top point of the histogram, the maximum frequency.

%If you want to see the histogram, uncomment the following two lines.
%WARNING:if you are performing online-processing, do not uncomment as it
%will produce n plots, where n is the size of the RR intervals.
% figure()
% histfit(a,binNo);

%This is where we fit the first line.
%FIRST LINE
x0 = topPoint(1);
y0 = topPoint(2);
x = edges(1:maxIndex);
y = N(1:maxIndex);
x = x(:); %reshape the data into a column vector
y = y(:);
% 'C' is the Vandermonde matrix for 'x'
n = 1; % since the we will fit a line, the degree is 1
V(:,n+1) = ones(length(x),1,class(x));
for j = n:-1:1
     V(:,j) = x.*V(:,j+1);
end
C = V;
% 'd' is the vector of target values, 'y'.
d = y;
% There are no inequality constraints in this case, i.e., 
A = [];
b = [];
% We use linear equality constraints to force the curve to hit the required point. In
% this case, 'Aeq' is the Vandermoonde matrix for 'x0'
Aeq = x0.^(n:-1:0);
% and 'beq' is the value the curve should take at that point
beq = y0;
p = lsqlin( C, d, A, b, Aeq, beq );
% We can then use POLYVAL to evaluate the fitted curve
yhat = polyval( p, x );% yhat is the fitted curve(linear estimation).
%Every line has an equation in the form y = mx + c
c = x(1)- ((x(2)-x(1))/(yhat(2)-yhat(1)))*yhat(1);% constant c of the line equation
while(yhat(1)<0)% if there is a negative value in the line, just remove it.(since this is a line, two points are adequate.)
    x(1) = [];
    yhat(1) = [];
end
yhat = [0;yhat ;topPoint(2)];
x =[c;x ;topPoint(1)];% concetanate the top point into the line

%If you want to see the fitted line, uncomment both the histogram plot above and these couple of lines..
%WARNING:if you are performing online-processing, do not uncomment as it
%will produce n plots, where n is the size of the RR intervals.
% Plot fitted data
% hold on
% plot(x,yhat,'r','linewidth',3)
% hold off
out = 0; % the output of the function should be the baseline width of the
TINNL = x(1);%coordinate of the left edge of the triangle
%SECOND LINE
x = edges(maxIndex+1:length(edges));
y = N(maxIndex:length(N));
x = x(:); %reshape the data into a column vector
y = y(:);
% 'C' is the Vandermonde matrix for 'x'
n = 1; % since we will fit a line, the degree is 1
V2(:,n+1) = ones(length(x),1,class(x));
for j = n:-1:1
     V2(:,j) = x.*V2(:,j+1);
end
C = V2;
% 'd' is the vector of target values, 'y'.
d = y;
% We use linear equality constraints to force the curve to hit the required point. In
% this case, 'Aeq' is the Vandermoonde matrix for 'x0'
Aeq2 = x0.^(n:-1:0);
% and 'beq' is the value the curve should take at that point
beq = y0;
p2 = lsqlin( C, d, A, b, Aeq, beq );
% We can then use POLYVAL to evaluate the fitted curve
yhat2 = polyval( p2, x );
c = x(1)- ((x(2)-x(1))/(yhat2(2)-yhat2(1)))*yhat2(1);
yhat2 = [topPoint(2); yhat2 ;0];
x =[topPoint(1);x;c];
% Plot fitted data
% hold on
% plot(x,yhat2,'r','linewidth',3)
% hold off
% c is the right edge of the triangle
out = c- TINNL;
end


