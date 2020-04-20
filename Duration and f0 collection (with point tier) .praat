## Dr Cong Zhang
## Language and Brain Laboratory, University of Oxford // SECL, University of Kent
## Last updated 20 April 2020
##
# This script goes through sound and TextGrid files in a directory,
# opens each pair of Sound and TextGrid, gets 
# "filename,segment,StartTime,EndTime,duration,maxF0_Hz,maxTime,
# minF0_Hz,minTime,meanF0_Hz,f0Range_Hz,PointTier_labelA, PointTier_F0A, 
# PointTier_TimeA,PointTier_labelB, PointTier_F0B, PointTier_TimeB"
# of each labeled interval(according to tier number), and saves results to a comma-delimited csv file.
# The major purpose of this script is to get the time, f0, and segment label of 
# two points on a point tier (can be the max and min f0 points)
# In your TextGrid file, you need a point tier, and an interval tier.
# For instance, you can segment all syllables and then label the max f0 point and min f0 point
# for each segment. Then you can use this script to collect the values of the two points.
#
## This script is edited based on the script 'Duration and f0 collection (by tier number).praat'
## https://github.com/rolin365/Praat/blob/master/Duration%20and%20f0%20collection%20(by%20tier%20number).praat
## If you do not have a point tier, it will be easier to use this one instead.
## This script is distributed under the GNU General Public License.



form Analyze duration and pitches from labeled segments in files
	comment Directory of sound files
	text sound_directory C:\Users\test\
	sentence Sound_file_extension .wav
	comment Directory of TextGrid files
	text textGrid_directory C:\Users\\test\
	sentence TextGrid_file_extension .TextGrid
	comment Full path of the resulting text file:
	text resultfile C:\Users\pitches.csv
	comment Which interval tier do you want to analyze?
	integer Tier 3
	comment Which point tier do you want to analyze?
	integer poitier 5
	comment Pitch analysis parameters
	positive Time_step 0.01
	positive Minimum_pitch(Hz) 75
	positive Maximum_pitch_(Hz) 550
	
endform

# Here, you make a listing of all the sound files in a directory.
# The example gets file names ending with ".wav" from C:\Users\
strings = Create Strings as file list: "list", sound_directory$ + "*.wav"
numberOfFiles = Get number of strings

# Check if the result file exists:
if fileReadable (resultfile$)
	pause The result file 'resultfile$' already exists! Do you want to overwrite it?
	filedelete 'resultfile$'
endif

# Write a row with column titles to the result file:
# (remember to edit this if you add or change the analyses!)
writeFile:"'resultfile$'"
writeFileLine:"'resultfile$'","filename,segment,StartTime,EndTime,duration,maxF0_Hz,maxTime,minF0_Hz,minTime,meanF0_Hz,f0Range_Hz,PointTier_labelA, PointTier_F0A, PointTier_TimeA,PointTier_labelB, PointTier_F0B, PointTier_TimeB"


# Go through all the sound files, one by one:
for ifile to numberOfFiles
	selectObject: strings
	filename$ = Get string: ifile
	# A sound file is opened from the listing:
	Read from file... 'sound_directory$''filename$'
	# Starting from here, you can add everything that should be 
	# repeated for every sound file that was opened:
	soundname$ = selected$ ("Sound", 1)
	To Pitch... time_step minimum_pitch maximum_pitch
	# Open a TextGrid by the same name:
	Read from file... 'sound_directory$''soundname$'.TextGrid
	sec_poi_tier = poitier + 1
	select TextGrid 'soundname$'
	pointnumber = Get number of points: sec_poi_tier
	if pointnumber = 0
		f0labelA$ = "NA"
		f0secA = 999999999
		f0secondtimeA = 999999999
		f0labelB$ = "NA"
		f0secB = 999999999
		f0secondtimeB = 999999999
	elsif pointnumber = 1
		select TextGrid 'soundname$'
		f0labelA$ = Get label of point... sec_poi_tier 1
		f0secondtimeA = Get time of point... sec_poi_tier 1
		select Pitch 'soundname$'
		f0secA = Get value at time: f0secondtimeA, "Hertz", "Linear"
		f0labelB$ = "NA"
		f0secB = 999999999
		f0secondtimeB = 999999999
	else
		select TextGrid 'soundname$'
		f0labelA$ = Get label of point... sec_poi_tier 1
		f0labelB$ = Get label of point... sec_poi_tier 1
		f0secondtimeA = Get time of point... sec_poi_tier 1
		f0secondtimeB = Get time of point... sec_poi_tier 1
		select Pitch 'soundname$'
		f0secA = Get value at time: f0secondtimeA, "Hertz", "Linear"
		f0secB = Get value at time: f0secondtimeB, "Hertz", "Linear"
	endif
	select TextGrid 'soundname$'
	numberOfIntervals = Get number of intervals... tier
	# Pass through all intervals in the selected tier:
	
		
	for i from 1 to numberOfIntervals
		select TextGrid 'soundname$'
		label$ = Get label of interval... tier i
		if label$ <> ""
			# if the interval has an unempty label, get its start and end, and duration:
			start = Get starting point... tier i
			end = Get end point... tier i
			duration = end - start
			# get pitch maximum, pitch minimum, time of pitch maximum, 
			# time of pitch minimum, mean pitch, and pitch range at that interval:
			select Pitch 'soundname$'
			pitchmax = Get maximum: start, end, "Hertz", "Parabolic"
			maxTime = Get time of maximum: start, end, "Hertz", "Parabolic"
			
			
			pitchmin = Get minimum: start, end, "Hertz", "Parabolic"
			minTime = Get time of minimum: start, end, "Hertz", "Parabolic"	
							
			pitchmean = Get mean: start, end, "Hertz"
			pitchrange = pitchmax - pitchmin
			resultline$ = "'soundname$','label$','start','end','duration','pitchmax','maxTime','pitchmin','minTime','pitchmean','pitchrange','f0labelA$','f0secA','f0secondtimeA','f0labelB$','f0secB','f0secondtimeB' 'newline$'"
			fileappend "'resultfile$'" 'resultline$'
			
		endif
	endfor
			# Save result to text file:
			#resultline$ = "'soundname$'	'label$'	'start'	'end'	'duration'	'pitchmax'	'maxTime'	'pitchmin'	'minTime'	'pitchmean'	'pitchrange'	'newline$'"


	# Remove the TextGrid object from the object list
	select TextGrid 'soundname$'
	Remove
	
	# Remove the temporary objects from the object list
	select Sound 'soundname$'
	plus Pitch 'soundname$'
	Remove
	select Strings list
	# and go on with the next sound file!
endfor

Remove
