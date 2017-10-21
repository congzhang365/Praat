## Point Tier for F0 Max and Min Version 2
## Written by Cong Zhang
## Language and Brain Laboratory, University of Oxford
## Last updated 12 July 2017

##  This script:
##  1. Opens all the sound files in a given directory, plus
##     their associated textgrids.
##  2. Get max f0 and min f0 within each interval of your selected tier.
##  3. Insert a point tier with the max and min f0.
##  4. View & Edit.
##  5. Save selected textgrids.
## In Version 2:
##  6. 'Word' field working properly. Fill in "Only analyse the files containing..." 
##		to analyse files with filenames with the word filled in.
##  7. In point tier, now the max point will be "interval text +" and min will be "interval text -".


## This script is edited based on the scripts 
## 'Text grid reviewer' by Mark Antoniou,
## 'Save all selected objects to disk' by Jose J. Atria,
## and praat user group answer by Mauricio Figueroa.

form F0 point tier:
	comment Your working directory:
	sentence Directory C:\Users\rolin\OneDrive\Oxford Research\Thesis related\data\2017\ci\ciall\
	comment Only analyse the files containing...
	sentence Word SJ101
	comment What sound file type would you like to analyse?
	sentence Filetype wav
	comment Which segment tier would you like to analyse?
	integer tier 4
	comment New point tier
	integer newtier 6
	comment ______________________________________________________________________________________________________________
	comment Save selected objects...
	sentence Save_to C:\Users\rolin\OneDrive\Oxford Research\Thesis related\data\2017\ci\ciall\point tier\

endform

Create Strings as file list... list 'directory$'*'Word$'*'filetype$'
number_of_files = Get number of strings
for x from 1 to number_of_files
     select Strings list
     current_file$ = Get string... 1
     Read from file... 'directory$''current_file$'
     object_name$ = selected$ ("Sound")
     Read from file... 'directory$''object_name$'.TextGrid
     plus Sound 'object_name$'
     #Edit
    sound_id    = selected("Sound")
	textgrid_id = selected("TextGrid")
	selectObject: sound_id
	pitch_id = To Pitch: 0.0, 75.0, 550.0

	selectObject: textgrid_id
	n_intervals = Get number of intervals: tier
	Insert point tier: newtier, "f0"
	for i from 1 to n_intervals
	  label$ = Get label of interval: tier, i
	  if length(label$)
		start_interval = Get starting point: tier, i
		end_interval   = Get end point: tier, i
		selectObject:pitch_id
		minimum_f0 = Get time of minimum: start_interval, end_interval, "Hertz", "Parabolic"
		maximum_f0 = Get time of maximum: start_interval, end_interval, "Hertz", "Parabolic"
		selectObject: textgrid_id
		nocheck Insert point: newtier, minimum_f0, "'label$'-"
		nocheck Insert point: newtier, maximum_f0, "'label$'+"
	  endif
	endfor

	##selectObject: sound_id, textgrid_id
	##View & Edit
	selectObject: textgrid_id
	Save as text file... 'Save_to$''object_name$'.TextGrid
	select Strings list
	stringnumber = Get number of strings
	if stringnumber > 1
		Remove string: 1
	endif
	selectObject: sound_id, pitch_id,textgrid_id
	Remove

endfor
select all
Remove