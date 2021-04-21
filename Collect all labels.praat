## Save all the labels in one tier into a csv file.
## Dr Cong Zhang, University of Kent
## 09/06/2020
##
## This script goes through sound and TextGrid files in a directory,
## opens each pair of Sound and TextGrid, gets 
## 		1. Filename	
## 		2. Segment label	
##		3. StartTime
##		4. EndTime
##		5. Duration
## and saves the results in a txt file.


form Collect all labels
	text textGrid_directory C:\Users\test\
	comment Full path of the result file:
	text resultfile C:\Users\test\labels.txt
	comment Which tier do you want to analyze?
	integer Tier 4
	choice delimiter: 1
	button tab
	button comma
	

endform

# Here, you make a listing of all the sound files in a directory.
# The example gets file names ending with ".wav" from C:\Users\
strings = Create Strings as file list: "list", textGrid_directory$ + "*.TextGrid"
numberOfFiles = Get number of strings

# Check if the result file exists:
if fileReadable (resultfile$)
	pause The result file 'resultfile$' already exists! Do you want to overwrite it?
	filedelete 'resultfile$'
endif
if delimiter = 1
	titleline$ = "filename	segment	StartTime	EndTime	duration	'newline$'"

elif delimiter = 2
	titleline$ = "filename,segment,StartTime,EndTime,duration	'newline$'"
endif
fileappend "'resultfile$'" 'titleline$'

# Go through all the sound files, one by one:
for ifile to numberOfFiles
	selectObject: strings
	filename$ = Get string: ifile
	# A sound file is opened from the listing:
	Read from file... 'textGrid_directory$''filename$'
	# Starting from here, you can add everything that should be 
	# repeated for every sound file that was opened:
	tg$ = selected$ ("TextGrid", 1)
	numberOfIntervals = Get number of intervals... tier
	# Pass through all intervals in the selected tier:
	for interval to numberOfIntervals
		label$ = Get label of interval... tier interval
		if label$ <> ""
			# Save result to text file:
			start = Get starting point... tier interval
			end = Get end point... tier interval
			duration = end - start
			if delimiter = 1
			resultline$ = "'tg$' 'tab$' 'label$' 'tab$' 'start' 'tab$' 'end' 'tab$' 'duration'	'newline$'"
				fileappend "'resultfile$'" 'resultline$'
			elif delimiter = 2
			resultline$ = "'tg$','label$','start','end','duration'	'newline$'"
				fileappend "'resultfile$'" 'resultline$'
			endif
			select TextGrid 'tg$'
		endif
	endfor
	# Remove the TextGrid object from the object list
	select TextGrid 'tg$'
	Remove
	writeInfoLine: ifile, "/", numberOfFiles, " files have been processed"
	select Strings list
	# and go on with the next sound file!
endfor

Remove
