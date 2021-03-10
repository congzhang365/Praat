# Collect points and corresponding intervals
# This script allows you to collect the labels and time of the point tier as well as the labels of its corresponding interval tiers
# The input file should be a TextGrid containing a point tier and up to two other interval tiers.
# It uses 'stress' as a reference, and collects the labels and times of: 
# "file_name,stress_label,stress_start,word_label,am_label,type_label,type_start,type_end"

## Dr Cong Zhang @SPRINT, Radboud University
## first version: 27 Jul 2020
## last update: 15/02/2021



form Analyze duration and pitches from labeled segments in files
	comment Directory of TextGrid files
	text textGrid_directory C:\Users\sprin\Desktop\test\test\
	comment Full paths of the resulting text files:
	boolean need_interval_result 1
	text interval_result C:\Users\sprin\Desktop\test\test\int.csv
	# text point_result C:\Users\point.txt
	comment Which interval tier do you want to analyze?
	integer stress_tier 7
	integer word_tier 2
	integer distance_tier 8
	integer am_tier 9
	integer type_tier 10
	# comment Which point tier do you want to analyze?
	# integer point_tier 5
	
endform

# make a listing of all the textgrid files in a directory.
strings = Create Strings as file list: "list", textGrid_directory$ + "*.TextGrid"
numberOfFiles = Get number of strings

# Check if the result files exist:
if need_interval_result = 1

	if fileReadable (interval_result$)
		pause The result file 'interval_result$' already exists! Do you want to overwrite it?
		filedelete 'interval_result$'
	endif
	# interval_titleline$ = "file_name,stress_label,stress_start,stress_end,stress_duration,word_label, word_start, word_end 'newline$'"
	interval_titleline$ = "file_name,stress_label,stress_start,word_label,am_label,type_label,type_start,type_end 'newline$'"
	fileappend "'interval_result$'" 'interval_titleline$'

endif


# if fileReadable (point_result$)
	# pause The result file 'point_result$' already exists! Do you want to overwrite it?
	# filedelete 'point_result$'
# endif

# # Write a row with column titles to the result file:
# point_titleline$ = "index, file_name, point_label, point_time, phoneme_label, phoneme_start, phoneme_end, phoneme_duration, word_label, distance_label, distance_duration 'newline$'"
# fileappend "'point_result$'" 'point_titleline$'


# Go through all the sound files, one by one:
for ifile to numberOfFiles
	selectObject: strings
	filename$ = Get string: ifile
	# Starting from here, you can add everything that should be 
	# repeated for every sound file that was opened:
	
	# Open a TextGrid by the same name:
	Read from file... 'textGrid_directory$''filename$'
	tg_name$ = selected$ ("TextGrid", 1)
	if need_interval_result = 1
		numberOfStresses = Get number of intervals: stress_tier

		# Pass through all intervals in the selected tier:
		for i from 1 to numberOfStresses
			select TextGrid 'tg_name$'
			stress_label$ = Get label of interval: stress_tier, i
		
			
			
			
			if stress_label$ <> ""
				# if the interval has an unempty label, get its start and end, and duration:
				stress_start = Get starting point: stress_tier, i
				# stress_end = Get end point: stress_tier, i
				# stress_duration = stress_end - stress_start
				
				# get the labels where the starting and ending points of the interval are
				word_interval = Get interval at time: word_tier, stress_start
				word_label$ = Get label of interval: word_tier, word_interval
				# word_start = Get starting point: word_tier, word_interval
				# word_end = Get end point: word_tier, word_interval
				# word_duration = word_end - word_start

				# get the labels where the starting and ending points of the interval are
				am_interval = Get interval at time: am_tier, stress_start
				am_label$ = Get label of interval: am_tier, am_interval
				# am_start = Get starting point: am_tier, am_interval
				# am_end = Get end point: am_tier, am_interval
				# am_duration = am_end - am_start
				
				# get the labels where the starting and ending points of the interval are
				type_interval = Get interval at time: type_tier, stress_start
				type_label$ = Get label of interval: type_tier, type_interval
				type_start = Get starting point: type_tier, type_interval
				type_end = Get end point: type_tier, type_interval
				type_duration = type_end - type_start
				
				
				# interval_resultline$ = "'tg_name$','int_label$','stress_start','stress_end','stress_duration','word_label$', 'word_start', 'word_end' 'newline$'"
				interval_resultline$ = "'tg_name$','stress_label$','stress_start','word_label$','am_label$','type_label$','type_start','type_end' 'newline$'"

				fileappend "'interval_result$'" 'interval_resultline$'
			endif
		
		endfor
		
	endif
	
endfor
	

# Remove the TextGrid object from the object list
select TextGrid 'tg_name$'
Remove

# Remove the temporary objects from the object list

select Strings list
# and go on with the next sound file!
Remove
