## Modified by Cong Zhang
## Language and Brain Laboratory, University of Oxford
## Last updated 4 June 2016
##
## This script goes through sound and TextGrid files in a directory,
## opens each pair of Sound and TextGrid, gets 
## 		1.Filename	
## 		2.Segment label	
## 		3.StartTime
## 		4.EndTime 
## and calculates
## 		5. Duration(s)
## 		6. Maximum pitch (Hz)	
##		7. maxTime	[the time when the pitch is max]
##		8. Minimum pitch (Hz)	
## 		9. minTime	[the time when the pitch is min]
## 		10. Mean pitch(Hz)	
## 		11. Pitch Range(Hz)
## of each labeled interval(according to tier number), and saves results to a text file.
##
## This script is edited based on the script
## 'collect_pitch_data_from_files.praat' by Mietta Lennes.
## This script is distributed under the GNU General Public License.



form Analyze duration and pitches from labeled segments in files
	comment Directory of sound files
	text sound_directory C:\Users\sprin\Desktop\test\all\
	sentence Sound_file_extension .wav
	comment Directory of TextGrid files
	text textGrid_directory C:\Users\sprin\Desktop\test\all\
	sentence TextGrid_file_extension .TextGrid
	comment Full path of the resulting text file:
	text resultfile C:\Users\sprin\Desktop\test\all\vowel_f0_listing.csv
	comment Which tier do you want use as the reference tier for analyze?
	integer ref_tier 3
	comment also collect other labels
	integer utterance_tier 1
	integer word_tier 2
	integer segment_tier 3
	# integer vowel_tier 3
	comment Pitch analysis parameters
	positive Time_step 0.01
	positive Minimum_pitch_(Hz) 50
	positive Maximum_pitch_(Hz) 650
	comment intensity analysis
	boolean intensity_analysis 0
	
	
	comment formant analysis
	boolean formant_analysis 0
	positive number_of_formants 5
	positive maximum_formant 5500
endform


# # comment Directory of sound files
 # sound_directory$ = "C:\Users\sprin\SPRINT Dropbox\Academic Research\Related_Projects\Comparison_Study\Full\Processed_Data\cut\vowel-level\all\"
 # sound_file_extension$ = ".wav"
# # comment Directory of TextGrid files
 # textGrid_directory$ = "C:\Users\sprin\SPRINT Dropbox\Academic Research\Related_Projects\Comparison_Study\Full\Processed_Data\cut\vowel-level\all\"
 # textGrid_file_extension$ = ".TextGrid"
# # comment Full path of the resulting text file:
 # resultfile$ = "C:\Users\sprin\SPRINT Dropbox\Academic Research\Related_Projects\Comparison_Study\Full\Analysis\utterance\vowel_5000.csv"
# # comment Which tier do you want to analyze?
 # ref_tier = 4
 # utterance_tier = 1
 # word_tier = 2
 # segment_tier = 3
 # vowel_tier = 4	
# # comment Pitch analysis parameters
 # time_step = 0.01
 # minimum_pitch = 30
 # maximum_pitch = 650
 # number_of_formants = 5
 # maximum_formant = 5000

	
	
	
Text writing preferences: "UTF-8"

preemphasis_from = 50
window_length = 0.025

# Here, you make a listing of all the sound files in a directory.
# The example gets file names ending with ".wav" from C:\Users\
strings = Create Strings as file list: "list", sound_directory$ + "*.wav"
numberOfFiles = Get number of strings

# Check if the result file exists:
if fileReadable (resultfile$)
	pause The result file 'resultfile$' already exists! Do you want to overwrite it?
	filedelete 'resultfile$'
endif

# Write a row with column titles to the result file(comma-delimited):
# (remember to edit this if you add or change the analyses!)

if intensity_analysis=1&formant_analysis=1
titleline$ = "filename,ref,utterance,word,segment,StartTime,EndTime,time,intensity,f0,f1,f2 'newline$'"
fileappend "'resultfile$'" 'titleline$'

elif intensity_analysis=0&formant_analysis=1
titleline$ = "filename,ref,utterance,word,segment,StartTime,EndTime,time,f0,f1,f2 'newline$'"
fileappend "'resultfile$'" 'titleline$'

elif intensity_analysis=1&formant_analysis=0
titleline$ = "filename,ref,utterance,word,segment,StartTime,EndTime,time,intensity,f0 'newline$'"
fileappend "'resultfile$'" 'titleline$'

elif intensity_analysis=0&formant_analysis=0
titleline$ = "filename,ref,utterance,word,segment,StartTime,EndTime,time,f0 'newline$'"
fileappend "'resultfile$'" 'titleline$'
endif


# Go through all the sound files, one by one:
for ifile to numberOfFiles
	selectObject: strings
	filename$ = Get string: ifile
	# A sound file is opened from the listing:
	Read from file... 'sound_directory$''filename$'
	# Starting from here, you can add everything that should be 
	# repeated for every sound file that was opened:
	soundname$ = selected$ ("Sound", 1)
	To Pitch: 0.001, minimum_pitch, maximum_pitch
	if intensity_analysis = 1
		select Sound 'soundname$'
		To Intensity: minimum_pitch, 0.001
	endif
	
	if formant_analysis = 1
		select Sound 'soundname$'
		To Formant (burg): 0.001, number_of_formants, maximum_formant, window_length, preemphasis_from
	endif
	
	# Open a TextGrid by the same name:
	gridfile$ = "'textGrid_directory$''soundname$''textGrid_file_extension$'"
	if fileReadable (gridfile$)
		Read from file... 'gridfile$'
		

		numberOfIntervals = Get number of intervals... ref_tier
		# Pass through all intervals in the selected segment_tier:
		for interval to numberOfIntervals
			ref_label$ = Get label of interval... ref_tier interval
			

			if ref_label$ <> ""
			# if the interval has an unempty label, get its start and end, and duration:
				ref_start = Get starting point... ref_tier interval
				ref_end = Get end point... ref_tier interval
				# duration = ref_end - ref_start

				
				utterance_interval = Get interval at time: utterance_tier, ref_start
				utterance_label$ = Get label of interval: utterance_tier, utterance_interval
				# utterance_start = Get starting point: utterance_tier, utterance_interval
				# utterance_end = Get end point: utterance_tier, utterance_interval
				# utterance_duration = utterance_end - utterance_start
				
				word_interval = Get interval at time: word_tier, ref_start
				word_label$ = Get label of interval: word_tier, word_interval
				# word_start = Get starting point: word_tier, word_interval
				# word_end = Get end point: word_tier, word_interval
				# word_duration = word_end - word_start
				
				segment_interval = Get interval at time: segment_tier, ref_start
				segment_label$ = Get label of interval: segment_tier, segment_interval
				# segment_start = Get starting point: segment_tier, segment_interval
				# segment_end = Get end point: segment_tier, segment_interval
				# segment_duration = segment_end - segment_start
				
				# vowel_interval = Get interval at time: vowel_tier, ref_start
				# vowel_label$ = Get label of interval: vowel_tier, vowel_interval
				# vowel_start = Get starting point: vowel_tier, vowel_interval
				# vowel_end = Get end point: vowel_tier, vowel_interval
				# vowel_duration = vowel_end - vowel_start
				
								
				for i to (ref_end - ref_start)/0.01
					time = ref_start + i * 0.01
					select Pitch 'soundname$'
					f0 = Get value at time: time, "Hertz", "linear"
					if intensity_analysis = 1
						select Intensity 'soundname$'
						intensity = Get value at time: time, "cubic"
					endif
					if formant_analysis = 1

						select Formant 'soundname$'
						f1 = Get value at time: 1, time, "hertz", "linear"
						f2 = Get value at time: 2, time, "hertz", "linear"
					endif
					
					
					if intensity_analysis=1&formant_analysis=1
						resultline$ = "'soundname$','ref_label$','utterance_label$','word_label$','segment_label$','ref_start','ref_end','time','intensity','f0','f1','f2' 'newline$'"
						fileappend "'resultfile$'" 'resultline$'
						
					elif intensity_analysis=0&formant_analysis=1
					resultline$ = "'soundname$','ref_label$','utterance_label$','word_label$','segment_label$','ref_start','ref_end','time','f0','f1','f2' 'newline$'"
						fileappend "'resultfile$'" 'resultline$'
					
					elif intensity_analysis=1&formant_analysis=0
					resultline$ = "'soundname$','ref_label$','utterance_label$','word_label$','segment_label$','ref_start','ref_end','time','intensity','f0' 'newline$'"
						fileappend "'resultfile$'" 'resultline$'
					
					elif intensity_analysis=0&formant_analysis=0
					resultline$ = "'soundname$','ref_label$','utterance_label$','word_label$','segment_label$','ref_start','ref_end','time','f0' 'newline$'"
						fileappend "'resultfile$'" 'resultline$'
					endif
				select TextGrid 'soundname$'
				
				
				endfor

			endif
		endfor
		# Remove the TextGrid object from the object list
		select TextGrid 'soundname$'
		Remove
	endif
	# Remove the temporary objects from the object list
	select Sound 'soundname$'
	plus Pitch 'soundname$'
	Remove
	select Strings list
	# and go on with the next sound file!
	writeInfoLine: ifile, "/", numberOfFiles
endfor

Remove
