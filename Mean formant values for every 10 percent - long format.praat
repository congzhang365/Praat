# Collect mean F0, F1, F2, F3, F4, F5 values for every 10% format
# 	1. divide the target utterance into 10 equal segments
# 	2. get mean formant values for every segments
#	3. write results in long format (formant values as columns)
# Dr Cong Zhang @SPRINT
# Aug 2020


form Analyze formants from labeled segments in files
	comment Directory of sound files
	text sound_directory C:\Users\
	sentence Sound_file_extension .wav
	comment Directory of TextGrid files
	text textGrid_directory C:\Users\
	sentence TextGrid_file_extension .TextGrid
	comment Full path of the resulting text file:
	text resultfile C:\Users\results.txt
	positive Time_step 0.01
	positive Minimum_pitch_(Hz) 50
	positive Maximum_pitch_(Hz) 650
	# comment Which formant do you want to analyze?
	# optionmenu formant_num: 1
       # option F1
       # option F2
       # option F3
       # option F4
       # option F5
	comment Which tier do you want to analyze?
	integer Tier 3
	comment Keyword
	sentence keyword H6N
endform

# Here, you make a listing of all the sound files in a directory.
# The example gets file names ending with ".wav" from D:\tmp\
strings = Create Strings as file list... list 'sound_directory$'*'keyword$'*wav
pause edit list?
numberOfFiles = Get number of strings

# Check if the result file exists:
if fileReadable (resultfile$)
	pause The result file 'resultfile$' already exists! Do you want to overwrite it?
	filedelete 'resultfile$'
endif

# Write a row with column titles to the result file:
# (remember to edit this if you add or change the analyses!)
titleline$ = "Filename	Segment	StartTime	EndTime	Part	F0	F1	F2	F3	F4	F5 'newline$'"
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
	To Formant (burg): 0, 5, 5500, 0.025, 50
	select Sound 'soundname$'
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
				
				######### F0
				select Pitch 'soundname$'
				part_1_F0 = Get mean: point_0, point_1, "Hertz"
				part_2_F0 = Get mean: point_1, point_2, "Hertz"
				part_3_F0 = Get mean: point_2, point_3, "Hertz"
				part_4_F0 = Get mean: point_3, point_4, "Hertz"
				part_5_F0 = Get mean: point_4, point_5, "Hertz"
				part_6_F0 = Get mean: point_5, point_6, "Hertz"
				part_7_F0 = Get mean: point_6, point_7, "Hertz"
				part_8_F0 = Get mean: point_7, point_8, "Hertz"
				part_9_F0 = Get mean: point_8, point_9, "Hertz"
				part_10_F0 = Get mean: point_9, point_10, "Hertz"
				
				
				######## F1
				select Formant 'soundname$'
				part_1_F1 = Get mean: 1, point_0, point_1, "Hertz"
				part_2_F1 = Get mean: 1, point_1, point_2, "Hertz"
				part_3_F1 = Get mean: 1, point_2, point_3, "Hertz"
				part_4_F1 = Get mean: 1, point_3, point_4, "Hertz"
				part_5_F1 = Get mean: 1, point_4, point_5, "Hertz"
				part_6_F1 = Get mean: 1, point_5, point_6, "Hertz"
				part_7_F1 = Get mean: 1, point_6, point_7, "Hertz"
				part_8_F1 = Get mean: 1, point_7, point_8, "Hertz"
				part_9_F1 = Get mean: 1, point_8, point_9, "Hertz"
				part_10_F1 = Get mean: 1, point_9, point_10, "Hertz"
				
				######## F2
				select Formant 'soundname$'
				part_1_F2 = Get mean: 2, point_0, point_1, "Hertz"
				part_2_F2 = Get mean: 2, point_1, point_2, "Hertz"
				part_3_F2 = Get mean: 2, point_2, point_3, "Hertz"
				part_4_F2 = Get mean: 2, point_3, point_4, "Hertz"
				part_5_F2 = Get mean: 2, point_4, point_5, "Hertz"
				part_6_F2 = Get mean: 2, point_5, point_6, "Hertz"
				part_7_F2 = Get mean: 2, point_6, point_7, "Hertz"
				part_8_F2 = Get mean: 2, point_7, point_8, "Hertz"
				part_9_F2 = Get mean: 2, point_8, point_9, "Hertz"
				part_10_F2 = Get mean: 2, point_9, point_10, "Hertz"
				
				######## F3
				select Formant 'soundname$'
				part_1_F3 = Get mean: 3, point_0, point_1, "Hertz"
				part_2_F3 = Get mean: 3, point_1, point_2, "Hertz"
				part_3_F3 = Get mean: 3, point_2, point_3, "Hertz"
				part_4_F3 = Get mean: 3, point_3, point_4, "Hertz"
				part_5_F3 = Get mean: 3, point_4, point_5, "Hertz"
				part_6_F3 = Get mean: 3, point_5, point_6, "Hertz"
				part_7_F3 = Get mean: 3, point_6, point_7, "Hertz"
				part_8_F3 = Get mean: 3, point_7, point_8, "Hertz"
				part_9_F3 = Get mean: 3, point_8, point_9, "Hertz"
				part_10_F3 = Get mean: 3, point_9, point_10, "Hertz"
				
				######## F4
				select Formant 'soundname$'
				part_1_F4 = Get mean: 4, point_0, point_1, "Hertz"
				part_2_F4 = Get mean: 4, point_1, point_2, "Hertz"
				part_3_F4 = Get mean: 4, point_2, point_3, "Hertz"
				part_4_F4 = Get mean: 4, point_3, point_4, "Hertz"
				part_5_F4 = Get mean: 4, point_4, point_5, "Hertz"
				part_6_F4 = Get mean: 4, point_5, point_6, "Hertz"
				part_7_F4 = Get mean: 4, point_6, point_7, "Hertz"
				part_8_F4 = Get mean: 4, point_7, point_8, "Hertz"
				part_9_F4 = Get mean: 4, point_8, point_9, "Hertz"
				part_10_F4 = Get mean: 4, point_9, point_10, "Hertz"
				
				######## F5
				select Formant 'soundname$'
				part_1_F5 = Get mean: 5, point_0, point_1, "Hertz"
				part_2_F5 = Get mean: 5, point_1, point_2, "Hertz"
				part_3_F5 = Get mean: 5, point_2, point_3, "Hertz"
				part_4_F5 = Get mean: 5, point_3, point_4, "Hertz"
				part_5_F5 = Get mean: 5, point_4, point_5, "Hertz"
				part_6_F5 = Get mean: 5, point_5, point_6, "Hertz"
				part_7_F5 = Get mean: 5, point_6, point_7, "Hertz"
				part_8_F5 = Get mean: 5, point_7, point_8, "Hertz"
				part_9_F5 = Get mean: 5, point_8, point_9, "Hertz"
				part_10_F5 = Get mean: 5, point_9, point_10, "Hertz"
				
				# Save result to text file:
				# "Filename	Segment	StartTime	EndTime	Part	F0	F1	F2	F3	F4	F5 'newline$'"
				resultline1$ = "'soundname$'	'label$'	'start'	'end'	1	'part_1_F0'	'part_1_F1'	'part_1_F2'	'part_1_F3'	'part_1_F4'	'part_1_F5' 'newline$'"
				fileappend "'resultfile$'" 'resultline1$'
				resultline2$ = "'soundname$'	'label$'	'start'	'end'	2	'part_2_F0'	'part_2_F1'	'part_2_F2'	'part_2_F3'	'part_2_F4'	'part_2_F5' 'newline$'"
				fileappend "'resultfile$'" 'resultline2$'
				resultline3$ = "'soundname$'	'label$'	'start'	'end'	3	'part_3_F0'	'part_3_F1'	'part_3_F2'	'part_3_F3'	'part_3_F4'	'part_3_F5' 'newline$'"
				fileappend "'resultfile$'" 'resultline3$'
				resultline4$ = "'soundname$'	'label$'	'start'	'end'	4	'part_4_F0'	'part_4_F1'	'part_4_F2'	'part_4_F3'	'part_4_F4'	'part_4_F5' 'newline$'"
				fileappend "'resultfile$'" 'resultline4$'
				resultline5$ = "'soundname$'	'label$'	'start'	'end'	5	'part_5_F0'	'part_5_F1'	'part_5_F2'	'part_5_F3'	'part_5_F4'	'part_5_F5' 'newline$'"
				fileappend "'resultfile$'" 'resultline5$'
				resultline6$ = "'soundname$'	'label$'	'start'	'end'	6	'part_6_F0'	'part_6_F1'	'part_6_F2'	'part_6_F3'	'part_6_F4'	'part_6_F5' 'newline$'"
				fileappend "'resultfile$'" 'resultline6$'
				resultline7$ = "'soundname$'	'label$'	'start'	'end'	7	'part_7_F0'	'part_7_F1'	'part_7_F2'	'part_7_F3'	'part_7_F4'	'part_7_F5' 'newline$'"
				fileappend "'resultfile$'" 'resultline7$'
				resultline8$ = "'soundname$'	'label$'	'start'	'end'	8	'part_8_F0'	'part_8_F1'	'part_8_F2'	'part_8_F3'	'part_8_F4'	'part_8_F5' 'newline$'"
				fileappend "'resultfile$'" 'resultline8$'
				resultline9$ = "'soundname$'	'label$'	'start'	'end'	9	'part_9_F0'	'part_9_F1'	'part_9_F2'	'part_9_F3'	'part_9_F4'	'part_9_F5' 'newline$'"
				fileappend "'resultfile$'" 'resultline9$'
				resultline10$ = "'soundname$'	'label$'	'start'	'end'	10	'part_10_F0'	'part_10_F1'	'part_10_F2'	'part_10_F3'	'part_10_F4'	'part_10_F5' 'newline$'"
				fileappend "'resultfile$'" 'resultline10$'
				
				
				select TextGrid 'soundname$'
				
			endif
		endfor

		# Remove the TextGrid object from the object list
		select TextGrid 'soundname$'
		Remove
	endif
	# Remove the temporary objects from the object list
	select Sound 'soundname$'
	plus Formant 'soundname$'
	Remove
	select Strings list
	# and go on with the next sound file!
endfor

Remove