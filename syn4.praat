form open audios according to a list
comment Give the path of the list of words:
sentence listdir C:\Users\rolin\Desktop\IPOX\macintosh synthesizer\macintosh synthesizer\no blank\123.txt
comment The directory that your files are from:
sentence Directory C:\Users\rolin\Desktop\IPOX\macintosh synthesizer\macintosh synthesizer\no blank\
comment What is the file type (e.g. .wav, .TextGrid)
sentence file_type .wav
endform

Read Strings from raw text file... 'listdir$'
Rename... list
number_of_files = Get number of strings
for x from 1 to number_of_files
	select Strings list
	current_file$ = Get string... x
	Read from file... 'directory$''current_file$''file_type$'
endfor