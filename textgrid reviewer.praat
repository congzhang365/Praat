form Enter directory and search string
# Be sure not to forget the slash (Windows: backslash, OSX: forward
# slash)  at the end of the directory name.
	sentence wav_dir /Desktop/
	sentence tg_dir /Desktop/
#  Leaving the "Word" field blank will open all sound files in a
#  directory. By specifying a Word, you can open only those files
#  that begin with a particular sequence of characters. For example,
#  you may wish to only open tokens whose filenames begin with ba.
	comment only show files with the keywords:
	sentence word
	sentence Filetype wav
	comment save textgrid
	boolean save_tg 1
	# comment Set max viewing f0 value
	# integer lower_max_f0 350

endform

Create Strings as file list... list 'wav_dir$'*'word$'*'filetype$'
number_of_files = Get number of strings
for x from 1 to number_of_files
	select Strings list
	current_file$ = Get string... x
	Read from file... 'wav_dir$''current_file$'
	object_name$ = selected$ ("Sound")
	
	Read from file... 'tg_dir$''object_name$'.TextGrid
	plus Sound 'object_name$'
	View & Edit
	pause  Make any changes then click Continue. 
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
