# This script checks whether the boundaries on the word tier match the boundaries on the phoneme tier.
# If they don't match, the script allows you to move the unmatching boundaries one by one 
# and automatically saves the changes.


## Dr Cong Zhang @PDRA Summer Research Prize
## 20 Oct 2020

form Check whether word boundaries match phoneme boundaries
	comment Directory of TextGrid files
	text textGrid_directory C:\Users\sprin\SPRINT Dropbox\Cong Zhang\Other projects\Singing\Music_Linguistics\ASA\final_Mandarin\
	comment Which interval tier do you want to analyze?
	integer word_tier 3
	integer phoneme_tier 4
endform


# make a listing of all the textgrid files in a directory.
strings = Create Strings as file list: "list", textGrid_directory$ + "*.TextGrid"
pause would you like to modify the list of files? You can remove the files you do not want to include.
numberOfFiles = Get number of strings


for ifile to numberOfFiles
	selectObject: strings
	filename$ = Get string: ifile
	# Starting from here, you can add everything that should be 
	# repeated for every sound file that was opened:
	
	# Open a TextGrid by the same name:
	Read from file... 'textGrid_directory$''filename$'
	tg_name$ = selected$ ("TextGrid", 1)
	numberOfIntervals = Get number of intervals: word_tier
		# Pass through all intervals in the selected tier:
	writeInfoLine: "------",date$(),"------"
	appendInfoLine:tg_name$

		for i from 1 to numberOfIntervals
			select TextGrid 'tg_name$'
			int_label$ = Get label of interval: word_tier, i
			
				# get the labels where the starting and ending points of the interval are
				word_label$ = Get label of interval: word_tier, i
				
				word_start = Get starting point: word_tier, i
				phoneme_interval = Get interval at time: phoneme_tier, word_start
				phoneme_label$ = Get label of interval: phoneme_tier, phoneme_interval
				same_syllable = index (word_label$, phoneme_label$)
				if phoneme_label$ = "" & word_label$ <> ""
					phoneme_interval = phoneme_interval + 1
				elsif phoneme_label$ = "" & word_label$ = ""
					phoneme_start = Get starting point: phoneme_tier, phoneme_interval
					if word_start < phoneme_start
						View & Edit
						appendInfoLine:"Boundary number: '",i,"' does not match"					
						editor:"TextGrid " + tg_name$	
							Zoom: word_start-0.1, word_start+0.1	
							pause work on your change
							Close
						endeditor
						
						Save as text file... 'textGrid_directory$'\'tg_name$'.TextGrid
					elsif word_start > phoneme_start
						View & Edit
						appendInfoLine:"Boundary number: '",i,"' does not match"	
						Insert boundary: word_tier, phoneme_start
						Remove boundary at time: word_tier, word_start
						Insert boundary: word_tier-1, phoneme_start
						Remove boundary at time: word_tier-1, word_start
						Insert boundary: word_tier-2, phoneme_start
						Remove boundary at time: word_tier-2, word_start
						editor:"TextGrid " + tg_name$	
							Zoom: word_start-0.1, word_start+0.1
							pause Was it correct?
							Close
						endeditor
						Save as text file... 'textGrid_directory$'\'tg_name$'.TextGrid
					endif
				else
					if same_syllable = 0
						phoneme_interval = phoneme_interval + 1
					endif
				endif
				phoneme_start = Get starting point: phoneme_tier, phoneme_interval
			if int_label$ <> ""
				if word_start < phoneme_start
					View & Edit
					appendInfoLine:"Boundary number: '",i,"' does not match"					
					editor:"TextGrid " + tg_name$	
						Zoom: word_start-0.1, word_start+0.1	
						pause work on your change
						Close
					endeditor
					
					Save as text file... 'textGrid_directory$'\'tg_name$'.TextGrid

				elsif word_start > phoneme_start
					View & Edit
					appendInfoLine:"Boundary number: '",i,"' does not match"	
					Insert boundary: word_tier, phoneme_start
					Remove boundary at time: word_tier, word_start
					Insert boundary: word_tier-1, phoneme_start
					Remove boundary at time: word_tier-1, word_start
					editor:"TextGrid " + tg_name$	
						Zoom: word_start-0.1, word_start+0.1
						pause Was it correct?
						Close
					endeditor
					Save as text file... 'textGrid_directory$'\'tg_name$'.TextGrid
				
				endif
			endif
		endfor
		appendInfoLine:tg_name$, "is done!"

endfor