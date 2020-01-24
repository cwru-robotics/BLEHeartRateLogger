HRV Real Time Acquisition and Anaylsis 

Version: 0.0.01

Author: Gautham Divakar Date: 12.19.2019


These python files are still in the design process. However, to gather data from 
the sensor follow the following steps. 

1. Disconnect all Bluetooth devices from the computer and connect the polar H10 sensor.
2. Look up in Device Manager to ensure connection 
3. Use the gattool feature to ensure a connection in terminal:  sudo gatttool -t random -b D0:CC:52:23:AE:4D -I
4. (in gattool), type connect. If connection successful, then exit. If not, remove the device from the device manager and retry the connection
5. Once connection successful, type in terminal:  ./BLEHeartRateLogger.py -m D0:CC:52:23:AE:4D




Interface HeartRate data with Statistical Anaylsis:


1. Ensure the the proper libraries are installed. 
	
	sudo apt-get install python-numpy python-scipy python-matplotlib ipython 

	sudo pip install numpy scipy


2. Ensure that the BLEHeartRateLogger.py has the statistical Package built
connected to it
	 from CogLoadMeasure import *
	

3. The Code attached Below is where one can add methods to it. res["rr"][0] is an integer that provides the RR interval from the polar H10 Sensor. It is a real
time value available to be used for signal processing applications. Below get_RR_data(res["rr"][0]) just a put a signal processing method that takes in an input preferably, rr_data.
It will run and re-run in real time. 
	

	if sqlfile is None:
                #print type(())res["rr"][0]
		log.info("Heart rate: " + str(res["hr"]))
		#log.info("RR interval: " + str(res["rr"]))
		get_RR_data(res["rr"][0])
		#print_RR_data()	
                continue



Signal Processing Background Information: 

1. The Timing anaylsis is for the most part done. It calculates Standard Deviation, Root Mean Time squared, pNN50. The Triangular Index method referenced in the 
papers need to be done.  

2. The Frequency domain anaylsis is a litle diffucult. Please reference the attached diagram titled "HRV Frequency Conversion Block Diagram", saved as a PNG File. It will help 
explain the process I attempted to construct the conversion. However, it has not been validated and may not be accurate. Another way calculating the Power Spectral Density is 
through the Welches periodiagram algorithm. Another Method, called Lomb's algorithm. We have not incorporated that into my functionality yet. 

3. LF/HF Ratio can found by taking the integral of the LF PSD, to get the LF power, and the integral of the HF PSD for the HF Power. That ratio is what I was planning 
on using for the LF/HF Ratio. This Ratio is key to determining Cognitive Load. 


