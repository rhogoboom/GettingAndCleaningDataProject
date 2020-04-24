# GettingAndCleaningDataProject
Repo for the Coursera Data Science Specialization 3rd Module course project.

Getting and Cleaning Data Course Project R Script
Packages needed for this script to run: dplyr

Please note that for this script to run the data files must be removed from their subfolders and put in to your working directory. 

Script first writes relevant unprocessed summary data in to R, individually merges each group's (train and test) data, then binds the two together vertically. Y data makes up the activity in each question, appeneded to the relevant subject, appended to the individual data points.

Samples were mutually exclusive, so there were no issues matching the data, just one on top of the other. 

Code Book
There are 89 Variables in the final table, with 180 observations of each (30 subjects performing 6 activities. The tables gives the mean value for each subject's data in each activity. 

The general labels on the data are as follows:
Subject.Number:           Ranges 1-30, the 30 subjects of the data
Activity:                 The activity performed
Sample:                   Which group the subject belong to, either training or test
Raw/FFT:                  Data is presented either in Raw data units, or Fast Fourier Transform
Body/Gravity:             Denotes if the data is for body movement or gravity caught by the lowpass filter
Acclermeter/Gyrometer:    The instrument measuring
Jerk.Signal:              If there was a jerk movement
Magniute:                 Magnitude of the vector
X/Y/Z Axis:               The axis of measurement
Mean / Standard Dev:      The measure being summarized, either arithmatic mean or standard deviation
Angle:                    Average of the x, y, and z measurements being given. 

