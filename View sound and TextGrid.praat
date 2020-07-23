## View sound file and TextGrid together
##
## This script allows you to view the audio files and textgrid files together. 
## It doesn't save any changes you made to the original file.
##
## Dr Cong Zhang
## Language and Brain Laboratory, University of Oxford
## Last updated 23 July 2020

form Enter the directory for your audio files:
	sentence audio_dir C:\Users\
	comment Enter the directory for your Textgrids:
	sentence tg_dir C:\Users\
	comment Only show files containing:
	sentence Word
	comment What is the format of your audio file?
	sentence Filetype wav
endform

Create Strings as file list... list 'audio_dir$'*'Word$'*'filetype$'
pause Would you like to chang the file list?
number_of_files = Get number of strings
for x from 1 to number_of_files
     select Strings list
     current_file$ = Get string... x
     Read from file... 'audio_dir$''current_file$'
     object_name$ = selected$ ("Sound")
     Read from file... 'tg_dir$''object_name$'.TextGrid
     plus Sound 'object_name$'
     Edit
     pause  Make any changes then click Continue. 
     select all
     minus Strings list
     Remove
endfor

select Strings list
Remove