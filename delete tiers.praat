## This script deletes Tier 1, then Tier 2 after deleting Tier 1 (i.e. original Tier 3), then Tier 3 after deleting the previous two (i.e. original Tier 5)
## It deletes these tiers in all the textgrid files in the input folder



form Enter directory and search string
# Be sure not to forget the slash (Windows: backslash, OSX: forward
# slash)  at the end of the directory name.
	sentence Directory C:\Users\sprin\Desktop\test/
#  Leaving the "Word" field blank will open all sound files in a
#  directory. By specifying a Word, you can open only those files
#  that begin with a particular sequence of characters. For example,
#  you may wish to only open tokens whose filenames begin with ba.
	sentence Word
	sentence Filetype TextGrid
endform

Create Strings as file list... list 'directory$'*'Word$'*'filetype$'
number_of_files = Get number of strings
for x from 1 to number_of_files
	select Strings list
	current_file$ = Get string... x
	Read from file... 'directory$''current_file$'
	
	Remove tier: 1
	Remove tier: 2
	Remove tier: 3
	
	Write to text file... 'directory$''current_file$'
	select all
	minus Strings list
	Remove
endfor

select Strings list
Remove
clearinfo
printline TextGrids have been reviewed for 'word$'.'filetype$' files in 
printline 'directory$'.