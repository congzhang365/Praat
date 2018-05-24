form Synthesize speech according to a txt list
comment Give the path of words you want to synthesize:
sentence listdir C:\Users\rolin\Desktop\123.txt
comment Save selected objects to...
	sentence Saveto C:\Users\rolin\Desktop
comment choose voice name
sentence voice_name English
comment choose voice variant
sentence voice_variant default
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
		Play
		Save as WAV file... 'Saveto$'\'current_file$'.wav
endfor

