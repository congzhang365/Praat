## Modified by Cong Zhang. Email me at: cong.zhang@ling-phil.ox.ac.uk
## Language and Brain Laboratory, University of Oxford
## Last updated 28 Aug 2016
##
## This script is edited based on the script
## 'save_labeled_intervals_to_wav_sound_files.praat' by Mietta Lennes.
## Original comments by Mietta Lennes:
# This script saves each interval in the selected IntervalTier of a TextGrid to a separate WAV sound file.
# The source sound must be a LongSound object, and both the TextGrid and 
# the LongSound must have identical names and they have to be selected 
# before running the script.
# Files are named with the corresponding interval labels (plus a running index number when necessary).
# NOTE: You have to take care yourself that the interval labels do not contain forbidden characters!!!!
# 
## Cong's edits:
## 1. Run through selected files;
## 2. Save small sounds with original file name;
## 3. Continue in one go without pressing 'continue';
## 4. If you need to add index numbers, get rid of the hash marks in the last few lines before 'Save ...'
## 5. No margin.
## 6. Note: there can be bugs in this script. Sometimes it only deals with the first few files. 
##    Move files to different folders if this happens. 
##    Would appreciate it if you could let me know if you know why this happens.
##
# This script is distributed under the GNU General Public License.

form Save intervals to small WAV sound files
	comment Directory of sound files
	text sound_directory D:\tmp\
	sentence Sound_file_extension .wav
	comment Directory of TextGrid files
	text textGrid_directory D:\tmp\
	comment Which IntervalTier in this TextGrid would you like to process?
	integer Tier 1
	comment Starting and ending at which interval? 
	integer Start_from 1
	integer End_at_(0=last) 0
	boolean Exclude_empty_labels 1
	boolean Exclude_intervals_labeled_as_xxx 1
	boolean Exclude_intervals_starting_with_dot_(.) 1
	#comment Give a small margin for the files if you like:
	#positive Margin_(seconds) 0.000001
	comment Give the folder where to save the sound files:
	sentence Folder D:\tmp\
	comment Give an optional prefix for all filenames:
	sentence Prefix TMP_
	comment Give an optional suffix for all filenames (.wav will be added anyway):
	sentence Suffix 
endform

# Here, you make a listing of all the sound files in a directory.
# The example gets file names ending with ".wav" from D:\tmp\
strings = Create Strings as file list: "list", sound_directory$ + "*.wav"
numberOfFiles = Get number of strings
# Go through all the sound files, one by one:
for x from 1 to numberOfFiles
	selectObject: strings
	current_file$ = Get string... x
	# A sound file is opened from the listing:
	Open long sound file... 'sound_directory$''current_file$'
    soundname$ = selected$ ("LongSound")
	# Starting from here, you can add everything that should be 
	# repeated for every sound file that was opened:
	
	# Open a TextGrid by the same name:
	Read from file... 'textGrid_directory$''soundname$'.TextGrid
	gridfile$ = selected$ ("TextGrid")
    #plus LongSound 'soundname$'
	numberOfIntervals = Get number of intervals... tier
	if start_from > numberOfIntervals
		exit There are not that many intervals in the IntervalTier!
	endif
	if end_at > numberOfIntervals
		end_at = numberOfIntervals
	endif
	if end_at = 0
		end_at = numberOfIntervals
	endif

	# Default values for variables
	files = 0
	intervalstart = 0
	intervalend = 0
	interval = 1
	intname$ = ""
	intervalfile$ = ""
	endoffile = Get finishing time

	# ask if the user wants to go through with saving all the files:
	# for interval from start_from to end_at
		# xxx$ = Get label of interval... tier interval
		# check = 0
		# if xxx$ = "xxx" and exclude_intervals_labeled_as_xxx = 1
			# check = 1
		# endif
		# if xxx$ = "" and exclude_empty_labels = 1
			# check = 1
		# endif
		# if left$ (xxx$,1) = "." and exclude_intervals_starting_with_dot = 1
			# check = 1
		# endif
		# if check = 0
		   # files = files + 1
		# endif
	# endfor
	# interval = 1
	# pause 'files' sound files will be saved. Continue?

	# Loop through all intervals in the selected tier of the TextGrid
	for interval from start_from to end_at
		select TextGrid 'gridfile$'
		intname$ = ""
		intname$ = Get label of interval... tier interval
		check = 0
		if intname$ = "xxx" and exclude_intervals_labeled_as_xxx = 1
			check = 1
		endif
		if intname$ = "" and exclude_empty_labels = 1
			check = 1
		endif
		if left$ (intname$,1) = "." and exclude_intervals_starting_with_dot = 1
			check = 1
		endif
		if check = 0
			intervalstart = Get starting point... tier interval
			intervalend = Get end point... tier interval
			select LongSound 'soundname$'
			Extract part... intervalstart intervalend no
			filename$ = soundname$
			intervalfile$ = "'folder$'" + "'prefix$'" + "'filename$'" + "'suffix$'" + ".wav"
			# indexnumber = 0
			# while fileReadable (intervalfile$)
				# indexnumber = indexnumber + 1
				# intervalfile$ = "'folder$'" + "'prefix$'" + "'filename$'" + "'suffix$''indexnumber'" + ".wav"
			# endwhile
			Save as WAV file... 'intervalfile$'
			Remove
		endif
	endfor
# and go on with the next sound file!
endfor
