# Converts TextGrid to an Excel file with 
#	- filenames 
# 	- texts 

## Dr Cong Zhang @SPRINT, Radboud University
## first version: 20 April 2021
## last update: 20/04/2021



form Analyze duration and pitches from labeled segments in files
	comment Directory of TextGrid files
	text textGrid_directory C:\Users\sprin\SPRINT Dropbox\Academic Research\Production_Pilots\Data_Processed\English\London\Audio\OBJE\mono\
	comment Full paths of the resulting text files:
	text interval_result C:\Users\sprin\SPRINT Dropbox\Academic Research\Production_Pilots\Data_Processed\English\London\Audio\OBJE\mono\OBJE_index_text.csv
	comment tier for analysis
	integer tier 1
	# comment Which point tier do you want to analyze?
	# integer point_tier 5
	
endform

# make a listing of all the textgrid files in a directory.
strings = Create Strings as file list: "list", textGrid_directory$ + "*.TextGrid"
numberOfFiles = Get number of strings

# Check if the result files exist:

if fileReadable (interval_result$)
	pause The result file 'interval_result$' already exists! Do you want to overwrite it?
	filedelete 'interval_result$'
endif
# interval_titleline$ = "file_name,stress_label,stress_start,stress_end,stress_duration,word_label, word_start, word_end 'newline$'"
interval_titleline$ = "file_name	text 'newline$'"
fileappend "'interval_result$'" 'interval_titleline$'



# if fileReadable (point_result$)
	# pause The result file 'point_result$' already exists! Do you want to overwrite it?
	# filedelete 'point_result$'
# endif

# # Write a row with column titles to the result file:
# point_titleline$ = "index, file_name, point_label, point_time, phoneme_label, phoneme_start, phoneme_end, phoneme_duration, word_label, distance_label, distance_duration 'newline$'"
# fileappend "'point_result$'" 'point_titleline$'

Text writing preferences: "UTF-8"
# Go through all the sound files, one by one:

for ifile to numberOfFiles
	selectObject: strings
	filename$ = Get string: ifile
	# Starting from here, you can add everything that should be 
	# repeated for every sound file that was opened:
	
	# Open a TextGrid by the same name:
	Read from file... 'textGrid_directory$''filename$'
	tg_name$ = selected$ ("TextGrid", 1)
		numberOfStressesLabels = Get number of intervals: tier

	# Pass through all intervals in the selected tier:
	for i from 1 to numberOfStressesLabels
		select TextGrid 'tg_name$'
		label$ = Get label of interval: tier, i
	
		if label$ <> ""
		
			# interval_resultline$ = "'tg_name$','int_label$','stress_start','stress_end','stress_duration','word_label$', 'word_start', 'word_end' 'newline$'"
			interval_resultline$ = "'tg_name$'	'label$' 'newline$'"
	
			fileappend "'interval_result$'" 'interval_resultline$'
		endif
	
	endfor
		
	appendInfoLine: ifile, "/", numberOfFiles
	
endfor
	

# Remove the TextGrid object from the object list
select TextGrid 'tg_name$'
Remove

# Remove the temporary objects from the object list

select Strings list
# and go on with the next sound file!
Remove
