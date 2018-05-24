form Change to Fo and duration
positive new_dur 0.25
comment Save selected objects to...
boolean save_file 1	
sentence Saveto C:\Users\rolin\Desktop\trial\222
sentence suffix
boolean Play_after_synthesis 1
boolean delete_useless_file 1
boolean flatten_pitch 1
comment keep flat level 0 if use mean pitch
real flat_level 100
endform

numberOfSounds = numberOfSelected  ("Sound")
for ifile from 1 to numberOfSounds
   sound$ = selected$  ("Sound", 'ifile' )
   soundID = selected  ("Sound", 'ifile')
   ids'ifile' = soundID
   names'ifile'$ = sound$
endfor

#now get down to business
for ifile from 1 to numberOfSounds
   soundID = ids'ifile'
   sound$ = names'ifile'$
   call fodurnchange
endfor


procedure fodurnchange

select 'soundID'
durn = Get duration

select Sound 'sound$'
To Manipulation: 0.01, 75, 600
Create DurationTier... 'sound$' 0 'new_dur'
Add point... 0 'new_dur'/'durn'
select Manipulation 'sound$'
plus DurationTier 'sound$'
Replace duration tier
select DurationTier 'sound$'
if delete_useless_file = 1
	Remove
endif

select Manipulation 'sound$'
Get resynthesis (PSOLA)
new_dur_string = new_dur * 1000
		new_dur_name$ = "'sound$'_'new_dur_string'"
		select Sound 'sound$'
		Rename: "'new_dur_name$'"

		if delete_useless_file = 1
			select Manipulation 'sound$'
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
				Remove
			endif
		else
			new_f0_name$ = "'new_dur_name$'"
			endif
		endif
		
	if save_file = 1
		select Sound 'new_f0_name$'
		Save as WAV file... 'Saveto$'\'new_f0_name$''suffix$'.wav
	endif	

endproc



