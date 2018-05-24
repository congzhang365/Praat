form Synthesize speech according to a txt list
comment Give the path of words you want to synthesize:
sentence listdir C:\Users\rolin\Desktop\123.txt

comment Save selected objects to...
boolean save_file 1	
sentence Saveto C:\Users\rolin\Desktop\trial\222
sentence suffix
comment choose voice name (e.g. English, English-us, English-rp)
sentence voice_name English
comment choose voice variant (e.g. default,croak, f1-5, klatt, klatt2-4, m1-7, whisper, whisperf)
sentence voice_variant default
   positive new_dur 0.25
   boolean Play_after_synthesis 1
   boolean Delete_useless_file 1
   boolean flatten_pitch 1
 comment keep flat level 0 if use mean pitch
 real flat_level 100
endform

########
Read Strings from raw text file... 'listdir$'
Rename... list
number_of_files = Get number of strings


for x from 1 to number_of_files
		if x = 10
			pause continue?
		endif
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
		if delete_useless_file = 1
			Remove
		endif
		
		select Manipulation 'current_file$'
		Get resynthesis (PSOLA)
		new_dur_string = new_dur * 1000
		new_dur_name$ = "'current_file$'_'new_dur_string'"
		select Sound 'current_file$'
		Rename: "'new_dur_name$'"

		if delete_useless_file = 1
			select Sound 'current_file$'
			plus Manipulation 'current_file$'
			Remove
		endif
		
		
		if flatten_pitch = 1
			
			select Sound 'new_dur_name$'
			To Manipulation: 0.01, 75, 600
			select Manipulation 'new_dur_name$'
			Extract pitch tier
			meanPitch = Get mean (points)... 0 0
			
			if flat_level = 0
				target_level = meanPitch
				flatF0$ = "flatF0Mean"
			else
			   target_level = flat_level
			   flatF0$ = "flat'target_level'hz"
			endif
			Formula: "'target_level'"
			
			select Manipulation 'new_dur_name$'
			plus PitchTier 'new_dur_name$'
			Replace pitch tier
			select Manipulation 'new_dur_name$'
			Get resynthesis (overlap-add)
			if play_after_synthesis = 1
			   Play
			endif
			new_f0_name$ = "'new_dur_name$'_'flatF0$'"
			Rename: "'new_f0_name$'"
			if delete_useless_file = 1
				select PitchTier 'new_dur_name$'
				plus Sound 'new_dur_name$'
				plus Manipulation 'new_dur_name$'
				plus SpeechSynthesizer 'voice_name$'_'voice_variant$'
				Remove
			endif
		else
			new_f0_name$ = "'new_dur_name$'"
			if delete_useless_file = 1
			select SpeechSynthesizer 'voice_name$'_'voice_variant$'
				Remove
			endif
		endif
		
	if save_file = 1
		select Sound 'new_f0_name$'
		Save as WAV file... 'Saveto$'\'new_f0_name$''suffix$'.wav
	endif	
endfor

