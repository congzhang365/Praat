## Copy files from one folder to another folder according to a list

# Note: The string list CANNOT have file extensions.

## Written by Cong Zhang
## Language and Brain Laboratory, University of Oxford
## Last updated 10 June 2020

form Enter directory and search string
	comment The directory that your files are from:
	sentence source_dir C:\Users\sprin\Desktop\test\t\UPDATED\
	comment Save selected objects to...
	sentence target_dir C:\Users\sprin\Desktop\test\wav\
	
	comment use txt list or files in a folder?
	choice list_type: 2
		button txt_list
		button folder_file
	sentence list_dir C:\Users\sprin\Desktop\test\wav\
	comment if folder_file, you can choose the files with the following keyword:
	sentence keyword 
	comment You already have:
	choice source_filetype: 2
		button wav
		button TextGrid
	
	comment The new files you want to copy:
	choice target_filetype: 1
		button wav
		button TextGrid
	comment do you want to overwrite existing files?
		boolean overwrite 0
	
	comment Name of skipped file log
	sentence logname log1
endform

appendInfoLine:"------",date$(),"------"


if list_type = 1
	Read Strings from raw text file... 'list_dir$'
	Rename... list
elif list_type = 2
	##You can also uncomment this section to use a list of all files in a directory
	if source_filetype = 1
		Create Strings as file list... list 'list_dir$'*'keyword$'*wav

	elif source_filetype = 2
		Create Strings as file list... list 'list_dir$'*'keyword$'*TextGrid

	endif
	pause Do you want to use this list? If not, select your own now.
endif
number_of_files = Get number of strings

#Here it creates a log file that will record any unprocessed files
writeFile:"'target_dir$''logname$'.txt"
writeFileLine:"'target_dir$''logname$'.txt","These files are not processed:",newline$

# This section is for wav files		
if target_filetype = 1
	for x from 1 to number_of_files
		select Strings list
		current_file$ = Get string... x
		base_name$ = left$("'current_file$'",length("'current_file$'")-9)
		full_name$ = source_dir$ + base_name$ + ".wav"

		if fileReadable(full_name$)
			Read from file... 'full_name$'
			# object_name$ = selected$ ("Sound")
			if fileReadable("'target_dir$''base_name$'.wav")
				if overwrite = 0
					appendFileLine:"'target_dir$''logname$'.txt","'current_file$' already exists!"
				elif overwrite = 1
					Save as WAV file... 'target_dir$''base_name$'.wav
				endif
			else
				Save as WAV file... 'target_dir$''base_name$'.wav
			endif
			select all
			minus Strings list
			Remove
		else
			appendFileLine:"'target_dir$''logname$'.txt","'current_file$'"
		endif
	endfor

# This section is for TextGrid files
elif target_filetype = 2
	for x from 1 to number_of_files
		select Strings list
		current_file$ = Get string... x
		base_name$ = left$("'current_file$'",length("'current_file$'")-4)
		full_name$ = source_dir$ + base_name$ + ".TextGrid"
		if fileReadable(full_name$)
			Read from file... 'full_name$'
			if fileReadable("'target_dir$''base_name$'.TextGrid")
				if overwrite = 0
					appendFileLine:"'target_dir$''logname$'.txt","'current_file$' already exists!"
				elif overwrite = 1
					Write to text file... 'target_dir$''base_name$'.TextGrid
				endif
			else
				Write to text file... 'target_dir$''base_name$'.TextGrid
			endif
			select all
			minus Strings list
			Remove
		else
			appendFileLine:"'target_dir$''logname$'.txt","'current_file$'"
		endif
	endfor
endif

select Strings list
Remove
appendInfoLine: number_of_files," 'target_filetype$'", " files have been saved in ", "'target_dir$'."