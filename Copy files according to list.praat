## Copy files from one folder to another folder according to a list

# Note: The string list CANNOT have file extensions.

## Written by Cong Zhang
## Language and Brain Laboratory, University of Oxford
## Last updated 10 June 2020

form Enter directory and search string
	comment The directory that your files are from:
	sentence Directory C:\Users\
	comment What is your list?
	sentence listdir C:\Users\list.txt
	#sentence Word 
	#sentence Filetype wav
	comment Save selected objects to...
	sentence Saveto C:\Users\
	comment Choose to save wav or TextGrid
	choice filetype: 1
		button wav
		button TextGrid
	comment Name of skipped file log
	sentence logname log1
endform

appendInfoLine:"------",date$(),"------"

Read Strings from raw text file... 'listdir$'
Rename... list

##You can also uncomment this section to use a list of all files in a directory
#Create Strings as file list... list 'directory$'*'Word$'*'filetype$' 
#pause Do you want to use this list? If not, select your own now.

number_of_files = Get number of strings

#Here it creates a log file that will record any unprocessed files
writeFile:"'Saveto$''logname$'.txt"
writeFileLine:"'Saveto$''logname$'.txt","These files are not processed:",newline$

# This section is for wav files		
if filetype$ = "wav"
	for x from 1 to number_of_files
		select Strings list
		current_file$ = Get string... x
		full_name$ = directory$ + current_file$ + ".wav"
		appendInfoLine: "'full_name$'"
		if fileReadable(full_name$)
			Read from file... 'full_name$'
			object_name$ = selected$ ("Sound")
			Save as WAV file... 'Saveto$'\'object_name$'.wav
			select all
			minus Strings list
			Remove
		else
			appendFileLine:"'Saveto$''logname$'.txt","'current_file$'"
		endif
	endfor

# This section is for TextGrid files
else
	for x from 1 to number_of_files
		select Strings list
		current_file$ = Get string... x
		full_name$ = directory$ + current_file$
		if fileReadable(full_name$)
			Read from file... 'directory$''current_file$'
			Write to text file... 'Saveto$''current_file$'
			select all
			minus Strings list
			Remove
		else
			appendFileLine:"'Saveto$''logname$'.txt","'current_file$'"
		endif
	endfor
endif

select Strings list
Remove
appendInfoLine: number_of_files," 'filetype$'", " files have been saved in ", "'directory$'."