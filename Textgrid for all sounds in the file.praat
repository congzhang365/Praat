## Create Textgrid for all sounds in the file

## Written by Cong Zhang
## Language and Brain Laboratory, University of Oxford
## Last updated 21 Oct 2017

form Enter directory and search string
	sentence Directory C:\Users\
	sentence Word SJ101
	sentence Filetype wav
	comment Save selected objects...
	sentence Save_to C:\Users\
endform

createDirectory:"'Save_to$'"
Create Strings as file list... list 'directory$'*'Word$'*'filetype$'
pause
number_of_files = Get number of strings
for x from 1 to number_of_files
     select Strings list
     current_file$ = Get string... x
     Read from file... 'directory$''current_file$'
     object_name$ = selected$ ("Sound")
     Read from file... 'directory$''object_name$'.TextGrid
     Write to text file... 'Save_to$''object_name$'.TextGrid
     select all
     minus Strings list
     Remove
endfor

select Strings list
Remove
clearinfo
printline TextGrids have been reviewed for 'word$'.'filetype$' files in 
printline 'directory$'.