import math  
import time 
import numpy as geek 
from scipy import signal
from scipy import interpolate
import scipy.integrate as integrate
import matplotlib.pyplot as plt
import random


rr_data=[];
temp_array=[5]

time=[0]
my_randoms=[]
freq=[]
power=[]
def rand():
	
	for i in range (1000):
    		my_randoms.append(random.randrange(700,1200,1))
    		
    	


def get_RR_data(data):		
	rr_data.append(data)
	
def print_RR_data():
	##rr_data.append(input_data)
	print rr_data

def time_mean(input_data):
	length_data=len(input_data)
	loop_index=0
	sum_rr_data=0.0
	##get the mean first
	while(loop_index<length_data):
		sum_rr_data+=input_data[loop_index]
		loop_index+=1
	if(length_data>0):
		mean_rr_data=sum_rr_data/float(length_data)
	#	print mean_rr_data	
		return mean_rr_data
	#print length_data
	


def time_std(input_data):
	mean_rr_data=time_mean(input_data)
	length_data=len(input_data)
	sum_std_data=0
	loop_index=0
	##standard deviaton formula 
	while(loop_index<length_data):
		local_var=input_data[loop_index]
		local_var=local_var-mean_rr_data
		local_var=local_var*local_var
		sum_std_data=sum_std_data+local_var
		loop_index+=1
	std_rr_data=sum_std_data/length_data
	std_rr_data=math.sqrt(std_rr_data0)
	print std_rr_data
	return std_rr_data

def time_root_mean_squared(input_data):
	mean_rr_data=time_mean(input_data)
	length_data=len(input_data)
	length_data=length_data-1
	sum_rmssd_data=0.0
	loop_index=0
	
	if length_data<1:
		return 0
	else:
		while(loop_index<length_data):
			local_var1=input_data[loop_index+1]
			local_var_2=input_data[loop_index]
			local_var=local_var1-local_var_2
			local_var=local_var*local_var
			sum_rmssd_data=sum_rmssd_data+local_var
			loop_index+=1
		inside_sq_root=sum_rmssd_data/float(length_data)
		rmssd=	math.sqrt(inside_sq_root)
		#print rmssd	
		return rmssd

def rr_differ_more_than_50(input_data):
	length_data=len(input_data)
	length_data=length_data-1
	number_of_intervals=0
	loop_index=0
	#only count the diffeences greater than 50ms, 
	while(loop_index<length_data):
		local_var1=input_data[loop_index+1]
		local_var2=input_data[loop_index]
		if(abs(local_var1-local_var2)>50):
			number_of_intervals= number_of_intervals +1
		loop_index=loop_index+1
	return number_of_intervals
 
def pNN50(input_data):
	rmssd=rr_differ_more_than_50(input_data)
	return float(float(rmssd)/(len(input_data))) 
	#float((rmssd)/len(input_data))

def TriangularIndex(input_data):
	## establish Histrogram boundarier
	## assign values based on those boundaries 
	## intrgate that and divide it by the maximum values	
	return len(nn_intervals) / max(np.histogram(nn_intervals, bins=range(300, 2000, 8))[0])
		

#	return 

	

# Time domain Anaylsis Need to still write functions for HRV Trainsgluar Index--integral of teh RR interveral histrogram divieded by the heigh of the hstigram
## Find 
# Frequency Domain neeeds ot be down, we need to compute an FFT for realtime conversion and then Peaks, Powers, relative powers LF< HF
# Non-linear methods need to be down as well
# Finally, need to have some type of Gui to execute the following scripts and save my data 


## some frequency methods
def VLF_LF_HF_peaks(input_data):
	frequency_data=[]#I would have to apply some type of Frequency changing 
	
	length_freq_data=len(frequency_data)
	loop_index=0
	while(loop_index<length_data):
		local_var1=input_data[loop_index+1]
		local_var2=input_data[loop_index]
		if(abs(local_var1-local_var2)>50):
			number_of_intervals= number_of_intervals +1

def getVLF(input_data):
	frequency_data=welch_method(input_data,False)
	power=welch_method(input_data,True)##get power is true, for frequency set it to false
				
	length_freq_data=len(frequency_data)
	VLF_values=[]
	loop_index=0
	#only count the diffeences greater than 50ms, 
	while(loop_index<length_freq_data):
		if(frequency_data[loop_index]<0.04 and frequency_data[loop_index]>=0):
			VLF_values.append(power[loop_index])

		loop_index=loop_index+1
	return VLF_values

def getLF(input_data):
	frequency_data=welch_method(input_data,False)
	power=welch_method(input_data,True)##get power is true, for frequency set it to false

		
	length_freq_data=len(frequency_data)
	
	LF_values=[]
	loop_index=0
	#only count the diffeences greater than 50ms, 
	while(loop_index<length_freq_data):
		if(frequency_data[loop_index]<0.15 and frequency_data[loop_index]>=.04):
			LF_values.append(power[loop_index])
		loop_index=loop_index+1
	return LF_values

def getHF(input_data):
	frequency_data=welch_method(input_data,False)
	power=welch_method(input_data,True)##get power is true, for frequency set it to false
	
	length_freq_data=len(frequency_data)
	HF_values=[]
	loop_index=0
	#only count the diffeences greater than 50ms, 
	while(loop_index<length_freq_data):
		if(frequency_data[loop_index]>=0.15 and frequency_data[loop_index]<0.4):
			HF_values.append(power[loop_index])
		loop_index=loop_index+1

	return HF_values 

def expected_value(input_data): 
	n=len(input_data)	
	prb = 1 / n
	# calculating expectation overall 
	expected_value = 0
	for i in range(0, n): 
		sum += (input_data[i] * prb)  
        return float(expected_value)


def autocovariance_method(input_data):
#	result_array =[]
	mean_input_data=time_mean(input_data)
	n=len(input_data)
	
	auto_array=[]	
	for h in range(0,n): 
		result_array =[]		
    		result = h
		for k in range(1,n-h): 
    			result_array.append(float((input_data[k+h]-mean_input_data)*(input_data[k]-mean_input_data)))
		#time_mean(input_data)
		auto_array.append(time_mean(result_array))
	return auto_array


	#print(type(result_array[0]))	
	
def yule_walker_equation_ar_coffieceints(input_data):				
	#autocovariance_var=geek.array(autocovariance_method(input_data))	
	autocovariance_var=autocovariance_method(input_data)
	n=len(autocovariance_var)
	if (n>2):		
			
		rr = geek.zeros([n-2,n-2]) 
		autocovariance_col = geek.zeros([n-2,1])
	
		for i in range(1,n-1):
			autocovariance_col[i-1][0]=(-1)*autocovariance_var[i]#transpose the data, it may be negative, may not unsure, just putting negative for now
			#print autocovariance_col
			#print autocovariance_var
		for l in range(0,n-2):
			for k in range(0,n-2):
				if(l-k<0):
					rr[l][k]=autocovariance_var[k-l]## assuming the even nature of the autocovarince function, if this is not true, then zero pad the function or just replace with a break
				#break
				else:
					rr[l][k]=autocovariance_var[l-k]
		autocovariance_var_two_d = geek.array(rr) 
		#print autocovariance_var_two_d
		inv_autocovariance_var_two_d = geek.linalg.inv(autocovariance_var_two_d)
		#print inv_autocovariance_var_two_d
		yule_walker_cof = inv_autocovariance_var_two_d.dot(autocovariance_col) 
		#print yule_walker_cof
		return yule_walker_cof
	else: 
		return [0];

def estimate_variance_from_yule_walker(input_data):
	yule_walker=yule_walker_equation_ar_coffieceints(input_data)
	autocovariance_var=autocovariance_method(input_data)	
	n=len(yule_walker)
	est_var=0.0
	if(n>2): 	
		for x in range(0,n): 
			est_var=est_var+yule_walker[x][0]*autocovariance_var[x]
	return est_var
	
#def time_domain_package():
	#print "The Mean is " + str(time_mean(rr_data))
	#print "The Standard Deviation is " + str(time_std(rr_data))
	#print "The Time root Mean squared is  " + str(time_root_mean_squared(rr_data))
	#print "The pNN50(input_data) is " + str(pNN50(rr_data))
	#print " The rr_differ_more_than_50 " + str(rr_differ_more_than_50(rr_data))
	#print "The Autocovariance coeffiencients are " + str(autocovariance_method(rr_data))
	#print "AR Estimation " + str(yule_walker_equation_ar_coffieceints(rr_data))
	#print "Estimate Variance from Yule Walker" + str(estimate_variance_from_yule_walker(rr_data))	
	#print "LF_HF Ratio" + str(LF_HF_ratio(rr_data))






def sample_counter():
	
	time.append(time[len(time)-1]+1)
	print time[len(time)-1]
	#nni_tmstp = geek.cumsum(rr_data)

   	




def welch_method(input_data,get_power):
	
	#fs is the sampling frequency, set the window to 256 points for as of now, 
	if (len(input_data)>256):
		#signal.get_window('hamming', 256)		
		
		##Might need to add interpolation 
		# ---------- Interpolation of signal ---------- #(UNCOMMENT IF YOU WANT INTERPOLATION, ALSO YOU NEED TO ADD TIME STAMP OF THE DATA FROM THE BLUETOOTH SENSOR 
        	#funct = interpolate.interp1d(x=timestamp_list, y=input_data, kind=interpolation_method)
		freqs, power = signal.welch(input_data, fs=4, window='hann', nperseg=256, noverlap=125, nfft=4096, detrend='constant', return_onesided=True, scaling='density', axis=-1)
		
		#plt.plot(freqs, power)
		#plt.show()	
		if(get_power):
			return power
		else: 

			return freqs 
		
	else: 
		print "Not enough points to apply Welch's Method"
		return [1]

def LF_HF_ratio_Real_Time():
	print "This is the LF HF ratio " + str(LF_HF_ratio(rr_data))



def LF_Power(input_data):
	##Assume that the low frequency values are properply calculated; 
	LF_values=getLF(input_data)
	#LFband = 40:150
	if(geek.trapz(LF_values)!=0.0):
		return geek.trapz(LF_values) 	
	else: 
		return 1.0


def HF_Power(input_data):
	##Assume that the low frequency values are properply calculated; 
	HF_values=getHF(input_data)
	#LFband = 40:150
	if(geek.trapz(HF_values)!=0.0):
		return geek.trapz(HF_values) 	
	else: 
		return 1.0



def LF_HF_ratio(input_data):
	my_lf_power=LF_Power(input_data)
	my_hf_power=HF_Power(input_data)
	return my_lf_power/my_hf_power


def main():
	#g=autocovariance_method(rr_data)
	#get_RR_data(322)
	print (my_randoms)
	rand()
	print (my_randoms)
	#get_RR_data(45)		
	#time_domain_package()
	print time
	sample_counter()
	#get_RR_data(21)
	#get_RR_data(80)
	#time_domain_package()
	print "The LF_HF ratio " + str(LF_HF_ratio(my_randoms)) 	
	print LF_Power(my_randoms)
	print HF_Power(my_randoms)
	




if __name__ == "__main__":
	main()






		
				
			

