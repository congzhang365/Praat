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
	sentence wav_dir /Desktop/
	sentence tg_dir /Desktop/
#  Leaving the "Word" field blank will open all sound files in a
#  directory. By specifying a Word, you can open only those files
#  that begin with a particular sequence of characters. For example,
#  you may wish to only open tokens whose filenames begin with ba.
	sentence word
	sentence Filetype wav
	comment save textgrid
	boolean save_tg 1
endform

Create Strings as file list... list 'wav_dir$'*'word$'*'filetype$'
number_of_files = Get number of strings
for x from 1 to number_of_files
	select Strings list
	current_file$ = Get string... x
	Read from file... 'wav_dir$''current_file$'
	object_name$ = selected$ ("Sound")
	To Pitch: 0, 75, 600
	max_f0 = Get maximum: 0, 0, "Hertz", "parabolic"
	min_f0 = Get minimum: 0, 0, "Hertz", "parabolic"

	Read from file... 'tg_dir$''object_name$'.TextGrid
	plus Sound 'object_name$'
	View & Edit
				
	editor:"TextGrid " + object_name$
		Advanced pitch settings: min_f0-20, max_f0+20, "no", 15, 0.03, 0.45, 0.01, 0.35, 0.14	
		pause work on your change
		Close
	endeditor
	if save_tg = 1
	select TextGrid 'object_name$'
	Write to text file... 'tg_dir$''object_name$'.TextGrid
	endif
	select all
	minus Sound 'object_name$'
	minus Strings list
	Remove
endfor

select Strings list
Remove
clearinfo
# printline TextGrids have been reviewed for 'word$'.'filetype$' files in 
# printline wav directory: 'wav_dir$'; tg directory: 'tg_dir$'
