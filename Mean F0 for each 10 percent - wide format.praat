# Collect mean F0 values for every 10% format
# 	1. divide the target utterance into 10 equal segments
# 	2. get mean F0 value for every segments
#	3. write results in wide format
# Dr Cong Zhang @SPRINT
# Aug 2020


form Analyze pitches from labeled segments in files
	comment Directory of sound files
	text sound_directory C:\Users\
	sentence Sound_file_extension .wav
	comment Directory of TextGrid files
	text textGrid_directory C:\Users\
	sentence TextGrid_file_extension .TextGrid
	comment Full path of the resulting text file:
	text resultfile C:\Users\10percent.txt
	comment Which tier do you want to analyze?
	integer Tier 1
	comment Pitch analysis parameters
	positive Time_step 0.01
	positive Minimum_pitch_(Hz) 75
	positive Maximum_pitch_(Hz) 500
	comment Subject name
	text subject_name
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
titleline$ = "Filename	Segment	sub	StartTime	EndTime	Part01	Part02	Part03	Part04	Part05	Part06	Part07	Part08	Part09	Part10	'newline$'"
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
				point_0 = start
				point_1 = ((end - start) * 0.1) + start
				point_2 = ((end - start) * 0.2) + start
				point_3 = ((end - start) * 0.3) + start
				point_4 = ((end - start) * 0.4) + start
				point_5 = ((end - start) * 0.5) + start
				point_6 = ((end - start) * 0.6) + start
				point_7 = ((end - start) * 0.7) + start
				point_8 = ((end - start) * 0.8) + start
				point_9 = ((end - start) * 0.9) + start
				point_10 = end
				# get pitch maximum, pitch minimum, time of pitch maximum, 
				# time of pitch minimum, mean pitch, and pitch range at that interval:
				select Pitch 'soundname$'
				part_1 = Get mean: point_0, point_1, "Hertz"
				part_2 = Get mean: point_1, point_2, "Hertz"
				part_3 = Get mean: point_2, point_3, "Hertz"
				part_4 = Get mean: point_3, point_4, "Hertz"
				part_5 = Get mean: point_4, point_5, "Hertz"
				part_6 = Get mean: point_5, point_6, "Hertz"
				part_7 = Get mean: point_6, point_7, "Hertz"
				part_8 = Get mean: point_7, point_8, "Hertz"
				part_9 = Get mean: point_8, point_9, "Hertz"
				part_10 = Get mean: point_9, point_10, "Hertz"
				# Save result to text file:
				resultline$ = "'soundname$'	'label$'	'subject_name$'	'start'	'end'	'part_1'	'part_2'	'part_3'	'part_4'	'part_5'	'part_6'	'part_7'	'part_8'	'part_9'	'part_10'	'newline$'"
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