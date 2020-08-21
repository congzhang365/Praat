# Collect points and corresponding intervals
# This script allows you to collect the labels and time of the point tier as well as the labels of its corresponding interval tiers
# The input file should be a TextGrid containing a point tier and up to two other interval tiers.
# It produces two files: 
# 1. the interval result file collects the corrspondence between the two interval tiers
# 2. the point result file collects the corrspondence between the point tier and the two interval tiers.

## Dr Cong Zhang @PDRA Summer Research Prize
## 27 Jul 2020



form Analyze duration and pitches from labeled segments in files
	comment Directory of TextGrid files
	text textGrid_directory C:\Users\
	comment Full paths of the resulting text files:
	boolean need_interval_result 0
	text interval_result C:\Users\int.txt
	text point_result C:\Users\point.txt
	comment Which interval tier do you want to analyze?
	integer word_tier 3
	integer phoneme_tier 4
	comment Which point tier do you want to analyze?
	integer point_tier 5
	
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
	interval_titleline$ = "file_name,interval_label,interval_start,interval_end,interval_duration,start_word_label, end_word_label 'newline$'"
	fileappend "'interval_result$'" 'interval_titleline$'

endif


if fileReadable (point_result$)
	pause The result file 'point_result$' already exists! Do you want to overwrite it?
	filedelete 'point_result$'
endif

# Write a row with column titles to the result file:
point_titleline$ = "index, file_name, point_label, point_time, phoneme_label, phoneme_start, phoneme_end, phoneme_duration, word_label 'newline$'"
fileappend "'point_result$'" 'point_titleline$'


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
		numberOfIntervals = Get number of intervals: phoneme_tier
		
		# Pass through all intervals in the selected tier:
		for i from 1 to numberOfIntervals
			select TextGrid 'tg_name$'
			int_label$ = Get label of interval: phoneme_tier, i
			if int_label$ <> ""
				# if the interval has an unempty label, get its start and end, and duration:
				interval_start = Get starting point: phoneme_tier, i
				interval_end = Get end point: phoneme_tier, i
				interval_duration = interval_end - interval_start
				
				# get the labels where the starting and ending points of the interval are
				start_word_interval = Get interval at time: word_tier, interval_start
				start_word_label$ = Get label of interval: word_tier, start_word_interval
				
				end_word_interval = Get interval at time: word_tier, interval_end
				end_word_label$ = Get label of interval: word_tier, end_word_interval	

				interval_resultline$ = "'tg_name$','int_label$','interval_start','interval_end','interval_duration','start_word_label$', 'end_word_label$' 'newline$'"
				fileappend "'interval_result$'" 'interval_resultline$'
			endif
		endfor
		
	endif
	
	
	select TextGrid 'tg_name$'

	numberOfPoints = Get number of points: point_tier
	#appendInfo: numberOfPoints
	for j from 1 to numberOfPoints
		point_label$ = Get label of point: point_tier, j
		point_time = Get time of point: point_tier, j
		#appendInfo: point_time
		point_phoneme_interval = Get interval at time: phoneme_tier, point_time
		#appendInfo: point_phoneme_interval
		for point_phoneme to point_phoneme_interval
			point_phoneme_label$ = Get label of interval: phoneme_tier, point_phoneme
			point_phoneme_start = Get starting point: phoneme_tier, point_phoneme
			point_phoneme_end = Get end point: phoneme_tier, point_phoneme
			point_phoneme_duration = point_phoneme_end - point_phoneme_start
			#appendInfoLine: point_phoneme_duration
		endfor
		
		point_word_interval = Get interval at time: word_tier, point_time
		for point_word to point_word_interval
			point_word_label$ = Get label of interval: word_tier, point_word_interval
		endfor
		point_resultline$ = "'j', 'tg_name$','point_label$','point_time', 'point_phoneme_label$', 'point_phoneme_start', 'point_phoneme_end','point_phoneme_duration', 'point_word_label$' 'newline$'"
		fileappend "'point_result$'" 'point_resultline$'
	endfor
	
endfor
	

# Remove the TextGrid object from the object list
select TextGrid 'tg_name$'
Remove

# Remove the temporary objects from the object list

select Strings list
# and go on with the next sound file!
Remove
