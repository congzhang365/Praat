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
	text resultfile C:\Users\pitches.csv
	comment Which tier do you want to analyze?
	integer segment_tier 1
	integer word_tier 2
	comment Pitch analysis parameters
	positive Time_step 0.01
	positive Minimum_pitch_(Hz) 75
	positive Maximum_pitch_(Hz) 500
endform
Text writing preferences: "UTF-8"

# Here, you make a listing of all the sound files in a directory.
# The example gets file names ending with ".wav" from C:\Users\
strings = Create Strings as file list: "list", sound_directory$ + "*.wav"
numberOfFiles = Get number of strings

# Check if the result file exists:
if fileReadable (resultfile$)
	pause The result file 'resultfile$' already exists! Do you want to overwrite it?
	filedelete 'resultfile$'
endif

# Write a row with column titles to the result file(comma-delimited):
# (remember to edit this if you add or change the analyses!)
titleline$ = "filename	segment	word	StartTime	EndTime	duration	maxF0_Hz	maxTime	minF0_Hz	minTime	meanF0_Hz	f0Range_Hz'newline$'"
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
		numberOfIntervals = Get number of intervals... segment_tier
		# Pass through all intervals in the selected segment_tier:
		for interval to numberOfIntervals
			label$ = Get label of interval... segment_tier interval
			if label$ <> ""
				# if the interval has an unempty label, get its start and end, and duration:
				start = Get starting point... segment_tier interval
				end = Get end point... segment_tier interval
				duration = end - start
				word_interval = Get interval at time: word_tier, start
				word_label$ = Get label of interval: word_tier, word_interval
				# get pitch maximum, pitch minimum, time of pitch maximum, 
				# time of pitch minimum, mean pitch, and pitch range at that interval:
				select Pitch 'soundname$'
				pitchmax = Get maximum: start, end, "Hertz", "Parabolic"
				# printline 'pitchmax'
				maxTime = Get time of maximum: start, end, "Hertz", "Parabolic"
				pitchmin = Get minimum: start, end, "Hertz", "Parabolic"
				# printline 'pitchmin'
				minTime = Get time of minimum: start, end, "Hertz", "Parabolic"	
				pitchmean = Get mean: start, end, "Hertz"
				# printline 'pitchmean'
				pitchrange = pitchmax - pitchmin
				# Save result to text file:
				resultline$ = "'soundname$'	'label$'	'word_label$'	'start'	'end'	'duration'	'pitchmax'	'maxTime'	'pitchmin'	'minTime'	'pitchmean'	'pitchrange''newline$'"
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
