## textgrid reviewer with auto-adjust f0 view range.praat
## Dr Cong Zhang@SPRINT, Radboud University || 05 Nov 2020
## With this script you can: 
## (1) View textgrid and sound together 
##    (filter by keyword or leave blank for all); 
## (2) Automatically adjust the view range of f0 according to their extrema;
## (3) Automatically save the changes in textgrids.


form Enter directory and search string
# Be sure not to forget the slash (Windows: backslash, OSX: forward
# slash)  at the end of the directory name.
	sentence Directory C:\Users\sprin\SPRINT Dropbox\Cong Zhang\Other projects\Singing\Music_Linguistics\ASA\final_Mandarin/
#  Leaving the "Word" field blank will open all sound files in a
#  directory. By specifying a Word, you can open only those files
#  that begin with a particular sequence of characters. For example,
#  you may wish to only open tokens whose filenames begin with ba.
	sentence file_keyword
	integer search_tier 4
	choice match_style: 2
		button exact_match
		sentence exact_word yao
		button contain_match
		sentence contain_word wu
endform

Create Strings as file list... list 'directory$'*'file_keyword$'.TextGrid
number_of_files = Get number of strings
for x from 1 to number_of_files
	select Strings list
	current_file$ = Get string... x
	Read from file... 'directory$''current_file$'
	object_name$ = selected$ ("TextGrid")
	numberOfIntervals = Get number of intervals: search_tier
	
	for i from 1 to numberOfIntervals
		select TextGrid 'object_name$'
		int_label$ = Get label of interval: search_tier, i
		
		if match_style = 1
			if int_label$ = exact_word$
				left_boundary = Get starting point: search_tier, i
				right_boundary = Get end point: search_tier, i
				Read from file... 'directory$''object_name$'.wav
				plus TextGrid 'object_name$'
				View & Edit
				appendInfoLine: object_name$, " : Interval ",i," contains ", exact_word$				
				editor:"TextGrid " + object_name$	
					Zoom: left_boundary - 0.5, right_boundary + 0.5
					pause work on your change
					Close
				endeditor
				minus Sound 'object_name$'
				Write to text file... 'directory$''object_name$'.TextGrid
			endif
		elif match_style = 2
			if index (int_label$, contain_word$) <> 0  
				left_boundary = Get starting point: search_tier, i
				right_boundary = Get end point: search_tier, i
				Read from file... 'directory$''object_name$'.wav
				plus TextGrid 'object_name$'
				View & Edit
				appendInfoLine: object_name$, " : Interval ",i," contains ", contain_word$				
				editor:"TextGrid " + object_name$	
					Zoom: left_boundary - 0.5, right_boundary + 0.5
					pause work on your change
					Close
				endeditor
				minus Sound 'object_name$'
				Write to text file... 'directory$''object_name$'.TextGrid
			endif
		endif
	endfor
select all
minus Strings list
Remove
endfor

