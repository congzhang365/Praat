## Modified by Cong Zhang
## Language and Brain Laboratory, University of Oxford
## Last updated 4 June 2016
##
## This script goes through sound and TextGrid files in a directory,
## opens each pair of Sound and TextGrid, gets 
## 		1.Filename	
## 		2.Segment label	
## 		3.StartTime
## 		4.EndTime 
## and calculates
## 		5. Duration(s)
## 		6. Maximum pitch (Hz)	
##		7. maxTime	[the time when the pitch is max]
##		8. Minimum pitch (Hz)	
## 		9. minTime	[the time when the pitch is min]
## 		10. Mean pitch(Hz)	
## 		11. Pitch Range(Hz)
## of each labeled interval(according to tier number), and saves results to a text file.
##
## This script is edited based on the script
## 'collect_pitch_data_from_files.praat' by Mietta Lennes.
## This script is distributed under the GNU General Public License.



form Analyze duration and pitches from labeled segments in files
	comment Directory of sound files
	text sound_directory C:\Users\
	sentence Sound_file_extension .wav
	comment Directory of TextGrid files
	text textGrid_directory C:\Users\
	sentence TextGrid_file_extension .TextGrid
	comment Full path of the resulting text file:
	text resultfile C:\Users\pitches.txt
	comment Which tier do you want to analyze?
	integer Tier 1
	comment Pitch analysis parameters
	positive Time_step 0.01
	positive Minimum_pitch_(Hz) 75
	positive Maximum_pitch_(Hz) 800
endform

# Here, you make a listing of all the sound files in a directory.
# The example gets file names ending with ".wav" from D:\tmp\
strings = Create Strings as file list: "list", sound_directory$ + "*.wav"
numberOfFiles = Get number of strings

# Check if the result file exists:
if fileReadable (resultfile$)
	pause The result file 'resultfile$' already exists! Do you want to overwrite it?
	filedelete 'resultfile$'
endif

# Write a row with column titles to the result file:
# (remember to edit this if you add or change the analyses!)
titleline$ = "Filename	Segment label	StartTime	EndTime	Duration(s)	Maximum pitch (Hz)	maxTime	Minimum pitch (Hz)	minTime	Mean pitch(Hz)	Pitch Range(Hz)	'newline$'"
fileappend "'resultfile$'" 'titleline$'

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
	gridfile$ = "'textGrid_directory$''soundname$''textGrid_file_extension$'"
	if fileReadable (gridfile$)
		Read from file... 'gridfile$'
		numberOfIntervals = Get number of intervals... tier
		# Pass through all intervals in the selected tier:
		for interval to numberOfIntervals
			label$ = Get label of interval... tier interval
			if label$ <> ""
				# if the interval has an unempty label, get its start and end, and duration:
				start = Get starting point... tier interval
				end = Get end point... tier interval
				duration = end - start
				# get pitch maximum, pitch minimum, time of pitch maximum, 
				# time of pitch minimum, mean pitch, and pitch range at that interval:
				select Pitch 'soundname$'
				pitchmax = Get maximum: start, end, "Hertz", "Parabolic"
				printline 'pitchmax'
				maxTime = Get time of maximum: start, end, "Hertz", "Parabolic"
				pitchmin = Get minimum: start, end, "Hertz", "Parabolic"
				printline 'pitchmin'
				minTime = Get time of minimum: start, end, "Hertz", "Parabolic"	
				pitchmean = Get mean: start, end, "Hertz"
				printline 'pitchmean'
				pitchrange = pitchmax - pitchmin
				# Save result to text file:
				resultline$ = "'soundname$'	'label$'	'start'	'end'	'duration'	'pitchmax'	'maxTime'	'pitchmin'	'minTime'	'pitchmean'	'pitchrange'	'newline$'"
				fileappend "'resultfile$'" 'resultline$'
				select TextGrid 'soundname$'
			endif
		endfor
		# Remove the TextGrid object from the object list
		select TextGrid 'soundname$'
		Remove
	endif
	# Remove the temporary objects from the object list
	select Sound 'soundname$'
	plus Pitch 'soundname$'
	Remove
	select Strings list
	# and go on with the next sound file!
endfor

Remove
