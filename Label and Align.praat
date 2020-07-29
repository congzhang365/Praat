## Label and Align
## This script allows you to 
## Method 1: create textgrids - label sound file - autoalign 
## Method 2: create textgrids - label sound file
## Method 3: autoalign existing textgrids

## By Cong Zhang
## Language and Brain Laboratory, University of Oxford
## Last updated 25 Oct 2017

form Files
	comment Input folder
	text input_directory C:\Users\
	
	comment Choose method:
	optionmenu method: 1
		option method 1: label&align in one go.
		option method 2: only label.
		option method 3: only align.
	comment Transcription or Text?
	choice trans: 2
		button transcription
		button text
	comment If text, what text?
	boolean same_text_for_all 0
	comment If same, the text is:
	text word
	comment if transcription, transcription file [with directory]:
	text transdir C:\Users\
	comment all tier names
	sentence intervaltiers text tone
	sentence pointtiers
	comment which tier and interval?
	integer transtier 1
	integer transinterval 2
	comment only certain files?
	sentence keyword
endform

#New section in Praat info window
appendInfoLine:"------",date$(),"------"

#Getting folder name

note1 = length(input_directory$)-1
note2$ = left$("'input_directory$'",note1)
note3 = rindex ("'note2$'","\")
note4 = note1-note3


folder$ = right$("'note2$'",note4)
appendInfoLine: "Processing folder ['folder$']"


######################################
########### METHOD 1##################
######################################
#The input folder can only have one transcription txt file
#The transcription file can have mutiple lines(same number and same order as sound files)

if method = 1
	if trans = 1
		#Use this line if the transcription file name is the folder name, e.g. folder name is 'Item1' and transcription has the same name
		#Read Strings from raw text file... 'input_directory$''folder$'.txt
		Read Strings from raw text file... 'transdir$'
		Rename... transcription
		
		
		Create Strings as file list... list 'input_directory$'*'keyword$'*wav
		number_files = Get number of strings
		pause Edit string list?
		
		for i from 1 to number_files
			select Strings transcription
			string$ = Get string... i
			
			select Strings list
			current_file$ = Get string... i
			Read from file... 'input_directory$''current_file$'
			object_name$ = selected$ ("Sound")
			txtgrd$ = input_directory$ + object_name$ +".TextGrid"
			if fileReadable(txtgrd$)
				Read from file... 'txtgrd$'
				select TextGrid 'object_name$'
				plus Sound 'object_name$'
				View & Edit
				
				beginPause: "New textgrid" 
				comment: "Do you want to create new textgrid?"
				newnewnew = endPause: "1. Yes", "2. No", 2
				if newnewnew = 2
					select TextGrid 'object_name$'
					Save as text file... 'input_directory$''object_name$'.TextGrid
				elsif newnewnew = 1
				select Sound 'object_name$'
				To TextGrid: "'intervaltiers$'","'pointtiers$'"
				select TextGrid 'object_name$'
				plus Sound 'object_name$'
				View & Edit
			
				pause continue?
				select TextGrid 'object_name$'
				
				#write the string in the chosen tier and interval.
				Set interval text: transtier, transinterval, "'string$'"
				#pause
				#Save as text file... 'input_directory$''object_name$'.TextGrid
				
				select TextGrid 'object_name$'
				plus Sound 'object_name$'
				#View & Edit
				editor TextGrid 'object_name$'
				Align interval
				pause Aligned.
				endeditor
				select TextGrid 'object_name$'
			
				Save as text file... 'input_directory$''object_name$'.TextGrid
				endif
			else
				select Sound 'object_name$'
				To TextGrid: "'intervaltiers$'","'pointtiers$'"
				Insert boundary: 1, 0.01
				select TextGrid 'object_name$'
				plus Sound 'object_name$'
				View & Edit
				
				select TextGrid 'object_name$'
				
				#write the string in the chosen tier and interval.
				Set interval text: transtier, transinterval, "'string$'"
				#pause
				#Save as text file... 'input_directory$''object_name$'.TextGrid
				pause Edit?
				select TextGrid 'object_name$'
				plus Sound 'object_name$'
				editor TextGrid 'object_name$'
				Align interval
				pause Aligned.
				endeditor
		
				select TextGrid 'object_name$'

				Save as text file... 'input_directory$''object_name$'.TextGrid
			endif
		appendInfoLine: "The word is 'string$' for 'object_name$'.",i," out of ", number_files, " were processed."
		endfor	
	
				
	appendInfoLine: "The word is 'string$' for 'object_name$'."
			
			
	# when you do not have a transcription file:
	elsif trans = 2
		Create Strings as file list... list 'input_directory$'*'keyword$'*wav
		number_files = Get number of strings
		pause Edit string list?
		
		for i from 1 to number_files
			select Strings list
			current_file$ = Get string... i
			Read from file... 'input_directory$''current_file$'
			object_name$ = selected$ ("Sound")
			txtgrd$ = input_directory$ + object_name$ +".TextGrid"
			
			if fileReadable(txtgrd$)
				Read from file... 'txtgrd$'
				select TextGrid 'object_name$'
				plus Sound 'object_name$'
				View & Edit
				
				beginPause: "New textgrid" 
				comment: "Do you want to create new textgrid?"
				newnewnew = endPause: "1. Yes", "2. No", 2
				if newnewnew = 2
					select TextGrid 'object_name$'
					Save as text file... 'input_directory$''object_name$'.TextGrid
				elsif newnewnew = 1
				select Sound 'object_name$'
				To TextGrid: "'intervaltiers$'","'pointtiers$'"
				select TextGrid 'object_name$'
				plus Sound 'object_name$'
				View & Edit
				
				
				#do all the files have the same text?
				#if they have the same text:
				if same_text_for_all = 1
					string$ = "'word$'"
					appendInfoLine: "The word is 'string$' for all."
					
				#if they the text is different for every file:
				elsif same_text_for_all = 2
					select Sound 'object_name$'
					Play
					
					beginPause: "word"
						
						comment: "what's the text"
						text:"word",""
					endPause:"Continue",1
					string$ = "'word$'"
				appendInfoLine: "The word is 'string$' for 'object_name$'.",i," out of ", number_files, " were processed."
				endif
				
				select TextGrid 'object_name$'
				
				#write the string in the chosen tier and interval.
				Set interval text: transtier, transinterval, "'string$'"
				#pause
				#Save as text file... 'input_directory$''object_name$'.TextGrid
				
				select TextGrid 'object_name$'
				plus Sound 'object_name$'
				editor TextGrid 'object_name$'
				Align interval
				pause Aligned.
				endeditor
				
				#The following section is to get the necessary text for different tiers and intervals
				#!!!!!It needs to change every time the task changes
				
				#change "Tier1" to your own tier name
				#string3$ = extractWord$("'object_name$'", "Tier1")
				#string4$ = left$("'string3$'",4)
				#type$ = right$ ("'object_name$'", 1)
				#pause Anything else to change?
				
				select TextGrid 'object_name$'
				#Duplicate tier: 1, 2, "tone"
				#Set interval text: 2, 2, "'string4$' - 'type$'"
				#Duplicate tier: 3, 4, "identity"
				#Set interval text: 4, 1, ""
				#Set interval text: 4, 2, "syl1"
				#Set interval text: 4, 3, "syl2"
				#Set interval text: 4, 4, ""
				#pause Save?
				
				Save as text file... 'input_directory$''object_name$'.TextGrid
				endif
			else
				select Sound 'object_name$'
				To TextGrid: "'intervaltiers$'","'pointtiers$'"
				select TextGrid 'object_name$'
				plus Sound 'object_name$'
				View & Edit
				
				
				#do all the files have the same text?
				#if they have the same text:
				if same_text_for_all = 1
					string$ = "'word$'"
					appendInfoLine: "The word is 'string$' for all."
					
				#if they the text is different for every file:
				elsif same_text_for_all = 2
					select Sound 'object_name$'
					Play
					
					beginPause: "word"
						
						comment: "what's the text"
						text:"word",""
					endPause:"Continue",1
					string$ = "'word$'"
				appendInfoLine: "The word is 'string$' for 'object_name$'.",i," out of ", number_files, " were processed."
				endif
				
				select TextGrid 'object_name$'
				
				#write the string in the chosen tier and interval.
				Set interval text: transtier, transinterval, "'string$'"
				#pause
				#Save as text file... 'input_directory$''object_name$'.TextGrid
				
				select TextGrid 'object_name$'
				plus Sound 'object_name$'
				editor TextGrid 'object_name$'
				Align interval
				pause Aligned.
				endeditor
		
				select TextGrid 'object_name$'

				Save as text file... 'input_directory$''object_name$'.TextGrid
			endif
		endfor
	endif

	select all
	Remove

	#folder$=extractLine$("'input_directory$'", "texttext")
	appendInfoLine: number_files," files in folder 'folder$' is done!"

######################################
########### METHOD 2##################
######################################
elsif method = 2
	if trans = 1
		#Use this line if the transcription file name is the folder name, e.g. folder name is 'Item1' and transcription has the same name
		#Read Strings from raw text file... 'input_directory$''folder$'.txt
		Read Strings from raw text file... 'transdir$'
		Rename... transcription
		
		
		Create Strings as file list... list 'input_directory$'*'keyword$'*wav
		number_files = Get number of strings
		pause Edit string list?
		
		for i from 1 to number_files
			select Strings transcription
			string$ = Get string... i
			
			select Strings list
			current_file$ = Get string... i
			Read from file... 'input_directory$''current_file$'
			object_name$ = selected$ ("Sound")
			txtgrd$ = input_directory$ + object_name$ +".TextGrid"
			if fileReadable(txtgrd$)
				Read from file... 'txtgrd$'
				select TextGrid 'object_name$'
				plus Sound 'object_name$'
				View & Edit
				
				beginPause: "New textgrid" 
				comment: "Do you want to create new textgrid?"
				newnewnew = endPause: "1. Yes", "2. No", 2
				if newnewnew = 2
					select TextGrid 'object_name$'
					Save as text file... 'input_directory$''object_name$'.TextGrid
				elsif newnewnew = 1
				select Sound 'object_name$'
				To TextGrid: "'intervaltiers$'","'pointtiers$'"
				select TextGrid 'object_name$'
				plus Sound 'object_name$'
				View & Edit
			
				pause continue?
				select TextGrid 'object_name$'
				
				#write the string in the chosen tier and interval.
				Set interval text: transtier, transinterval, "'string$'"
				select TextGrid 'object_name$'
				Save as text file... 'input_directory$''object_name$'.TextGrid
				endif
			else
				select Sound 'object_name$'
				To TextGrid: "'intervaltiers$'","'pointtiers$'"
				select TextGrid 'object_name$'
				plus Sound 'object_name$'
				View & Edit
				select TextGrid 'object_name$'
				
				#write the string in the chosen tier and interval.
				Set interval text: transtier, transinterval, "'string$'"
				select TextGrid 'object_name$'
				Save as text file... 'input_directory$''object_name$'.TextGrid
			endif
		endfor	
				
				
		appendInfoLine: "The word is 'string$' for 'object_name$'."
			
			
	# when you do not have a transcription file:
	elsif trans = 2
		Create Strings as file list... list 'input_directory$'*'keyword$'*wav
		number_files = Get number of strings
		pause Edit string list?
		
		for i from 1 to number_files
			select Strings list
			current_file$ = Get string... i
			Read from file... 'input_directory$''current_file$'
			object_name$ = selected$ ("Sound")
			txtgrd$ = input_directory$ + object_name$ +".TextGrid"
			
			if fileReadable(txtgrd$)
				Read from file... 'txtgrd$'
				select TextGrid 'object_name$'
				plus Sound 'object_name$'
				View & Edit
				
				beginPause: "New textgrid" 
				comment: "Do you want to create new textgrid?"
				newnewnew = endPause: "1. Yes", "2. No", 2
				if newnewnew = 2
					select TextGrid 'object_name$'
					Save as text file... 'input_directory$''object_name$'.TextGrid
				elsif newnewnew = 1
				select Sound 'object_name$'
				To TextGrid: "'intervaltiers$'","'pointtiers$'"
				select TextGrid 'object_name$'
				plus Sound 'object_name$'
				View & Edit
				
				
				#do all the files have the same text?
				#if they have the same text:
				if same_text_for_all = 1
					string$ = "'word$'"
					appendInfoLine: "The word is 'string$' for all."
					
				#if they the text is different for every file:
				elsif same_text_for_all = 2
					select Sound 'object_name$'
					Play
					
					beginPause: "word"
						
						comment: "what's the text"
						text:"word",""
					endPause:"Continue",1
					string$ = "'word$'"
				appendInfoLine: "The word is 'string$' for 'object_name$'.",i," out of ", number_files, " were processed."
				endif
				
				select TextGrid 'object_name$'
				
				#write the string in the chosen tier and interval.
				Set interval text: transtier, transinterval, "'string$'"
				select TextGrid 'object_name$'
				Save as text file... 'input_directory$''object_name$'.TextGrid
				endif
			else
				select Sound 'object_name$'
				To TextGrid: "'intervaltiers$'","'pointtiers$'"
				select TextGrid 'object_name$'
				plus Sound 'object_name$'
				View & Edit
				
				
				#do all the files have the same text?
				#if they have the same text:
				if same_text_for_all = 1
					string$ = "'word$'"
					appendInfoLine: "The word is 'string$' for all."
					
				#if they the text is different for every file:
				elsif same_text_for_all = 2
					select Sound 'object_name$'
					Play
					
					beginPause: "word"
						
						comment: "what's the text"
						text:"word",""
					endPause:"Continue",1
					string$ = "'word$'"
				appendInfoLine: "The word is 'string$' for 'object_name$'.",i," out of ", number_files, " were processed."
				endif
				
				select TextGrid 'object_name$'
				
				#write the string in the chosen tier and interval.
				Set interval text: transtier, transinterval, "'string$'"
				select TextGrid 'object_name$'
				Save as text file... 'input_directory$''object_name$'.TextGrid
			endif
		endfor
	endif

	select all
	Remove

	#folder$=extractLine$("'input_directory$'", "texttext")
	appendInfoLine: number_files," files in folder 'folder$' is done!"
	
	
######################################
########### METHOD 3##################
######################################
# If the textgrid exists, and it has been labelled and you only need to align it:
# The textgrid files must be in the input directory
elsif method = 3
	Create Strings as file list... list 'input_directory$'*'keyword$'*wav
	number_files = Get number of strings
	select Strings list
	pause Edit string list?
	
	for i from 1 to number_files
		select Strings list
		current_file$ = Get string... i
		Read from file... 'input_directory$''current_file$'
		object_name$ = selected$ ("Sound")
		txtgrd$ = input_directory$ + object_name$ +".TextGrid"
			if fileReadable(txtgrd$)
				Read from file... 'txtgrd$'
				select TextGrid 'object_name$'
				plus Sound 'object_name$'
				View & Edit
				pause edit?
				select TextGrid 'object_name$'
				Save as text file... 'input_directory$''object_name$'.TextGrid
			else
				select Sound 'object_name$'
				To TextGrid: "'intervaltiers$'","'pointtiers$'"
				plus Sound 'object_name$'
				View & Edit

				select Sound 'object_name$'
				Play
				beginPause: "word"
				comment: "what's the text"
				text:"word",""
				endPause:"Continue",1
				string$ = "'word$'"
				select TextGrid 'object_name$'
				
				#write the string in the chosen tier and interval.
				Set interval text: transtier, transinterval, "'string$'"
				
				select TextGrid 'object_name$'
				plus Sound 'object_name$'
				editor TextGrid 'object_name$'
				Align interval
				pause Aligned.
				endeditor

				select TextGrid 'object_name$'
				Save as text file... 'input_directory$''object_name$'.TextGrid
				
				
				appendInfoLine: "The word is 'string$' for 'object_name$'.",i," out of ", number_files, " were processed."
			endif


		
	endfor
	select all
	Remove
	appendInfoLine: number_files," files in folder 'folder$' is done!"
endif