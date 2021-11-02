## Add an utterance tier to your existing textgrid
## This script is to add an utterance tier to an exsiting textgrid
## e.g. the output file from many forced aligners such as MFA, MAUS, etc.
## You will need to have:
## - wav files
## - txt files: the txt files need to contain the text of the utterances, and the file names need to be the same as the tg files.



## Last updated 01/02/2021
## Dr. Cong Zhang. @SPRINT, Radboud University.

form Files
	comment wav folder
	text wav_dir C:\Users\sprin\SPRINT Dropbox\Academic Research\Related_Projects\Comparison_Study\Full\Processed_Data\cut\
	comment txt folder
	text txt_dir C:\Users\sprin\SPRINT Dropbox\Academic Research\Related_Projects\Comparison_Study\Full\Processed_Data\txt\
	comment New TextGrid tiers
	sentence interval_tier utterance vowel
	sentence point_tier
	# comment transcription
	# text trans_text

	comment new utterance tier
	integer utterance_tier 1
	boolean overwrite 1
	
	comment only certain files?
	sentence keyword
endform

Create Strings as file list... list 'wav_dir$'*'keyword$'*wav
number_files = Get number of strings
# pause Edit string list?


for i from 1 to number_files
	select Strings list
	current_file$ = Get string... i
	snd$ = Read from file... 'wav_dir$''current_file$'
	object_name$ = selected$ ("Sound")
	snd_dur = Get total duration
	To TextGrid: interval_tier$, point_tier$
	Read Strings from raw text file... 'txt_dir$''object_name$'.txt
	select Strings 'object_name$'
	txt$ = Get string... 1
	select TextGrid 'object_name$'
	if overwrite = 1
		Insert boundary: utterance_tier, 0.1
		Insert boundary: utterance_tier, snd_dur-0.1
		Set interval text: utterance_tier, 2, "'txt$'"
	elsif overwrite = 0
		Insert interval tier: utterance_tier, "utterance"
		Insert boundary: utterance_tier, 0.1
		Insert boundary: utterance_tier, snd_dur-0.1
		Set interval text: utterance_tier, 2, "'txt$'"

	endif					
	
	select TextGrid 'object_name$'
	Save as text file... 'wav_dir$''object_name$'.TextGrid
	select Strings 'object_name$'
	Remove
	endif
	
	
endfor	
		
		
appendInfoLine: "The utterance is 'txt$' for 'object_name$'."