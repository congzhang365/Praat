## Rate/Categorise sound files
#This script allows you to copy sound files into different folders according to their quality/rating/other aspects.

form Enter directory and search string
	sentence Directory C:\Users\
	sentence Word SJ101
	sentence Filetype wav
	comment Save selected objects...
	sentence Saveto C:\Users\
	comment Name of log
	sentence logname H_LH_Final_mismatch
	boolean with_tg 1
	sentence textGrid_directory C:\Users\
	boolean auto_play 0
endform

appendInfoLine:"------",date$(),"------"

Create Strings as file list... list 'directory$'*'Word$'*'filetype$'
number_of_files = Get number of strings

#Here it creates a log file that records the files you processed
writeFile:"'Saveto$''logname$'.txt"
writeFileLine:"'Saveto$''logname$'.txt","Filename",tab$,"Folder"

for x from 1 to number_of_files
	select Strings list
	current_file$ = Get string... x

	Read from file... 'directory$''current_file$'
	object_name$ = selected$ ("Sound", 1)
	if auto_play = 1
		Play
	endif
	
	gridfile$ = "'textGrid_directory$''object_name$'.TextGrid"
	if with_tg = 1
		Read from file... 'gridfile$'
	endif
	select Sound 'object_name$'
	plus TextGrid 'object_name$'
	# Listen to the sound file

	#You can  view the sound at the same time. If not necessary, delete this line.
	View & Edit
	
	# Here you can rate/ categorise your sound files.
	# You can change the wording within the quotation marks
	# The names of the result folders will only have the numbers, not the strings.
	beginPause: "Rate the quality" 
	comment: "How good is the sound on a scale from 1 to 5?"
	quality = endPause: "1. NoWay", "2. NotReally", "3. NoIdea", "4. Maybe", "5. Best", 0
	appendInfoLine: "The quality of ","'object_name$'"," is:",quality
	
	#create a folder if you don't have the folder
	createDirectory:"'Saveto$''quality'"
	
	#saves the sound file in the new folder
	Save as WAV file... 'Saveto$''quality'\'object_name$'.wav
	
	#log it
	appendFileLine: "'Saveto$''logname$'.txt", object_name$,tab$,quality
	select all
	minus Strings list
	Remove
endfor

select Strings list
Remove
appendInfoLine: number_of_files, " files in ", "'directory$'", " have been categorised."
