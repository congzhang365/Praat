## Add an utterance tier to your existing textgrid
## This script is to add an utterance tier to an exsiting textgrid
## e.g. the output file from many forced aligners such as MFA, MAUS, etc.
## You will need to have:
## - textgrid files: each textgrid file needs to have at least one tier that contains a minimum of two boundaries 
##   (the first and last boundary will be used to create the utterance tier
## - txt files: the txt files need to contain the text of the utterances, and the file names need to be the same as the tg files.


## Last updated 19/1/2021
## Dr. Cong Zhang. @SPRINT, Radboud University.

form Files
	comment TextGrid folder
	text tg_dir C:\Users\sprin\Desktop\test\test2\
	comment txt folder
	text txt_dir C:\Users\sprin\Desktop\test\test2\t\
	comment existing reference tier
	integer ref_tier 4
	comment new utterance tier
	integer utterance_tier 1
	comment add other tiers?
	comment only certain files?
	sentence keyword
endform

Create Strings as file list... list 'tg_dir$'*'keyword$'*TextGrid
number_files = Get number of strings
# pause Edit string list?


for i from 1 to number_files
	select Strings list
	current_file$ = Get string... i
	txtgrd$ = Read from file... 'tg_dir$''current_file$'
	object_name$ = selected$ ("TextGrid")
	Read Strings from raw text file... 'txt_dir$''object_name$'.txt
	select Strings 'object_name$'
	txt$ = Get string... 1
	select TextGrid 'object_name$'
	int_num = Get number of intervals: ref_tier
	if int_num > 2
		utterance_start = Get starting point: ref_tier, 2
		utterance_end = Get starting point: ref_tier, int_num
		Insert interval tier: utterance_tier, "utterance"
		Insert boundary: utterance_tier, utterance_start
		Insert boundary: utterance_tier, utterance_end
		
		#write the string in the chosen tier and interval.
		Set interval text: utterance_tier, 2, "'txt$'"
	else 
		select TextGrid 'object_name$'
		Insert interval tier: utterance_tier, "utterance"
		Insert boundary: utterance_tier, 0.1
		Insert boundary: utterance_tier, 0.2
		Set interval text: utterance_tier, 2, "'txt$'"
		View & Edit
		pause
	endif					
	
	select TextGrid 'object_name$'
	Save as text file... 'tg_dir$''object_name$'.TextGrid
	select Strings 'object_name$'
	Remove
	endif
	
	
endfor	
		
		
appendInfoLine: "The utterance is 'txt$' for 'object_name$'."