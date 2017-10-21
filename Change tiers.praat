## Replace pitch tier

# The pitch tier that you'd like to replace the orginal pitch tier with should be in the same input folder as the sound files

## Written by Cong Zhang
## Language and Brain Laboratory, University of Oxford
## Last updated 21 Oct 2017

form Files
	comment Input folder1
	text input_directory C:\Users\rolin\Desktop\trial\111\
	comment Output folder1
	text output_directory C:\Users\rolin\Desktop\trial\111\
	comment second directory?
	boolean second 1
	comment Input folder2
	text input_directory2 C:\Users\rolin\Desktop\trial\111\
	comment Output folder2
	text output_directory2 C:\Users\rolin\Desktop\trial\111\
	#sentence Word
	#sentence Filetype .wav
	#sentence Pitchtier Pitch
 
endform

#Directory 1#

createDirectory: "'output_directory$'"

Create Strings as file list... list 'input_directory$'*.wav
number_files = Get number of strings


for i from 1 to number_files
	select Strings list
	current_file$=Get string... 'i'
	Read from file... 'input_directory$''current_file$'
	sound_one$ = selected$ ("Sound")
	To Manipulation... 0.01 75 600
	Read from file... 'input_directory$''sound_one$'.Pitch
	Down to PitchTier
	select Manipulation 'sound_one$'
	plus PitchTier 'sound_one$'
	Replace pitch tier
	select Manipulation 'sound_one$'
	Get resynthesis (overlap-add)
	Write to WAV file... 'output_directory$''sound_one$'.wav
	select all
	minus Strings list
	Remove
endfor
select all
Remove

#Directory 2#

createDirectory: "'output_directory2$'"

Create Strings as file list... list 'input_directory2$'*.wav
number_files = Get number of strings

if second = 1
for i from 1 to number_files
	select Strings list
	current_file$=Get string... 'i'
	Read from file... 'input_directory2$''current_file$'
	sound_one$ = selected$ ("Sound")
	To Manipulation... 0.01 75 600
	Read from file... 'input_directory2$''sound_one$'.Pitch
	Down to PitchTier
	select Manipulation 'sound_one$'
	plus PitchTier 'sound_one$'
	Replace pitch tier
	select Manipulation 'sound_one$'
	Get resynthesis (overlap-add)
	Write to WAV file... 'output_directory2$''sound_one$'.wav
	select all
	minus Strings list
	Remove
endfor
select all
Remove
