Time domain measures of HRV.
Author:Onat Dalmaz Date:17.07.2019
This matlab file reads a series of RR intervals and can produce time domain measurements of HRV
and is able to do both post processing and simulate online processing.
For post processing, indicated parts in the code shold be uncommented and the other should be commented.
This way, the program will produce a number for each measure.
For simulating online processing, indicated parts in the code should be uncommented(default)
and other(post-processing) part should be commented.
This way, the program willl produce a plot for each measure.
To open a desired txt file with RR intervals:
1.The file should be in the same folder with the program.
2.The file should be added to the path.
3.In the second line, (default:'relax.txt') the name of the txt file should be changed to the
desired file name.