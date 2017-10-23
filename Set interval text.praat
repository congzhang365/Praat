## Set Interval Text


## Written by Cong Zhang
## Language and Brain Laboratory, University of Oxford
## Last updated 22 Oct 2017

form Files
	comment Input folder
	text input_directory C:\Users\rolin\Desktop\trial\222\
	comment Keyword
	word keyword SJ110
	comment modify interval text?
	boolean newtext 0
	comment If same, the text is:
	text word
	#comment if transcription, transcription file [with directory]:
	#text transdir C:\Users\rolin\Desktop\trial\222\234.txt
	comment which tier and interval?
	integer tierchange 1
	integer intervalchange 2
	comment Confirm after every tial?
	boolean confirmation 0
endform

#New section in Praat info window
appendInfoLine:"------",date$(),"------"



Create Strings as file list... list 'input_directory$'*'keyword$'*.TextGrid
number_files = Get number of strings
pause Edit string list?





for i from 1 to number_files
	select Strings list
	current_file$ = Get string... i
	Read from file... 'input_directory$''current_file$'
	object_name$ = selected$ ("TextGrid")

	
	#The following section is to get the necessary text for different tiers and intervals
	#!!!!!It needs to change every time the task changes




	if newtext = 1
		Set interval text: tierchange, intervalchange, "'word$'"
	else newtext = 0	
	# Define Variables, e.g. get a part of the filename
	
	##extractWord is a very convienient expression
	##it "looks for a word without spaces after the first occurrence" of a word (in this script: SJ101_)
	a$ = extractWord$("'object_name$'", "ci")
	
	##this is to get the FIRST 4 characters from the string stored in variable a.
	b$ = left$("'a$'",4)
	
	## this is to get the LAST 1 character from the string stored in variable 'object_name$'
	type$ = right$ ("'object_name$'", 1)
	
	
	select TextGrid 'object_name$'
	#Duplicate tier: 1, 2, "tone"
	Set interval text: tierchange, intervalchange, "'b$' - 'type$'"
	#Duplicate tier: 3, 4, "identity"
	#Set interval text: 4, 1, ""
	#Set interval text: 4, 2, "syl1"
	#Set interval text: 4, 3, "syl2"
	#Set interval text: 4, 4, ""
	#pause Save?
	endif

	
	select TextGrid 'object_name$'
	View & Edit alone
	
	if confirmation = 1
		beginPause: "more changes"
		comment: "Anything else to change?"
		morechange = endPause: "1. Yes", "2. No", 2
		if morechange = 2
			select TextGrid 'object_name$'
			Save as text file... 'input_directory$''object_name$'.TextGrid
			appendInfoLine: i," out of ", number_files, " were processed and saved."
			endeditor
		else morechange = 1
			pause more change?
			select TextGrid 'object_name$'
			Save as text file... 'input_directory$''object_name$'.TextGrid
			endeditor
			appendInfoLine: i," out of ", number_files, " were processed and saved."
		endif
	else confirmation =0
		Save as text file... 'input_directory$''object_name$'.TextGrid
		appendInfoLine: i," out of ", number_files, " were processed and saved."
	endif
endfor


beginPause: "remove all"
comment: "Files saved. Remove everything from Praat object?"
removeall = endPause: "1. Yes", "2. No", 1

if removeall = 1
	select all
	Remove
endif