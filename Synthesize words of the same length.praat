form Synthesize speech according to a txt list
comment Give the path of words you want to synthesize:
sentence listdir C:\Users\rolin\Desktop\123.txt
comment Save selected objects to...
	sentence Saveto C:\Users\rolin\Desktop\trial\222
sentence suffix
comment choose voice name
sentence voice_name English
comment choose voice variant
sentence voice_variant default
   positive new_dur 0.25
   boolean Play_after_synthesis 1
   boolean Delete_Manipulation_file 1
   boolean flatten_pitch 1
endform

########
Read Strings from raw text file... 'listdir$'
Rename... list
number_of_files = Get number of strings


for x from 1 to number_of_files
		select Strings list
		current_file$ = Get string... x
		synth1 = Create SpeechSynthesizer: "'voice_name$'", "'voice_variant$'"
		To Sound: current_file$, 0
		Rename: "'current_file$'"
		dur = Get duration
		To Manipulation: 0.01, 75, 600
		Create DurationTier... 'current_file$' 0 'new_dur'
		Add point... 0 'new_dur'/'dur'
		select Manipulation 'current_file$'
		plus DurationTier 'current_file$'
		Replace duration tier
		select DurationTier 'current_file$'
		Remove
		
		select Manipulation 'current_file$'
		Get resynthesis (PSOLA)
		if play_after_synthesis = 1
		   Play
		endif
		new_dur_string = new_dur * 1000
		new_name$ = "'current_file$'_'new_dur_string'"
		Rename... 'new_name$'
		
		if delete_Manipulation_file = 1
		   select Manipulation 'current_file$'
		   Remove
		endif

		select Sound 'new_name$'
		Save as WAV file... 'Saveto$'\'new_name$''suffix$'.wav
		
endfor

