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
	sentence audio_dir /Desktop/
	comment if tg_dir is different from audio_dir
	sentence tg_dir /Desktop/
#  Leaving the "Word" field blank will open all sound files in a
#  directory. By specifying a Word, you can open only those files
#  that begin with a particular sequence of characters. For example,
#  you may wish to only open tokens whose filenames begin with ba.
	sentence Word
	sentence filetype wav
endform

Create Strings as file list... list 'audio_dir$'*'Word$'*'filetype$'
# if filetype$ = "wav"
	# pair_filetype$ = "TextGrid"
# elif filetype$ = "TextGrid"
	# pair_filetype$ = "wav"
# endif
number_of_files = Get number of strings


for x from 1 to number_of_files
	select Strings list
	current_file$ = Get string... x
	Read from file... 'audio_dir$''current_file$'
	object_name$ = selected$ ("Sound")
	To Pitch: 0, 75, 600
	max_f0 = Get maximum: 0, 0, "Hertz", "parabolic"
	min_f0 = Get minimum: 0, 0, "Hertz", "parabolic"
	
	if not tg_dir$ = ""
		Read from file... 'tg_dir$''object_name$'.TextGrid
		point_time = Get time of point: 1, 1

	else
		Read from file... 'audio_dir$''object_name$'.TextGrid
		point_time = Get time of point: 1, 1
	endif
	plus Sound 'object_name$'
	View & Edit
				
	editor:"TextGrid " + object_name$
	
		Zoom: point_time-0.1, point_time+0.1
		pause work on your change
		Close
	endeditor
	
	minus Sound 'object_name$'
	Write to text file... 'tg_dir$''object_name$'.TextGrid
	select all
	minus Strings list
	Remove
endfor

select Strings list
Remove
clearinfo
printline TextGrids have been reviewed for 'word$'.'filetype$' files in 
printline 'tg_dir$'.
