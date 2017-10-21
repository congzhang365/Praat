## Get a list of files in your chosen directory##

## Written by Cong Zhang
## Language and Brain Laboratory, University of Oxford
## Last updated 21 Oct 2017

# The 'Word' field is for a word of interest, 
# for example, I'd like to only include the files 
# with 'SJ101' in their filenames


form Enter directory and search string
	sentence Directory C:\Users\
	sentence Word SJ101
	sentence Filetype wav
	comment Save selected objects...
	sentence Saveto C:\Users\
	comment List name
	sentence filename
endform

appendInfoLine:"------",date$(),"------"

Create Strings as file list... list 'directory$'*'Word$'*'filetype$'
numberofFiles=Get number of strings
select Strings list

Save as raw text file... 'Saveto$''filename$'.txt
appendFileLine:"'Saveto$''filename$'.txt","Total file number is: ", numberofFiles