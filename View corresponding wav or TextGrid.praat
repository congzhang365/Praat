## View sound file and TextGrid together

## Just have a look. It doesn't edit or modify the original file.


## Written by Cong Zhang
## Language and Brain Laboratory, University of Oxford
## Last updated 23 Oct 2017

form Enter directory and search string
	sentence directory C:\Users\rolin\Desktop\trial\222\
comment Open corresponding Sound or TextGrid
	choice type
		button Sound
		button TextGrid
endform


if type = 1
	filetype$ = "Sound"
	file_extension$ = "wav"
	originaltype$ = "TextGrid"
	original_extension$ = "TextGrid"
	
else type = 2
	filetype$ = "TextGrid"
	file_extension$ = "TextGrid"
	originaltype$ = "Sound"
	original_extension$ = "wav"
endif


selected_objects = numberOfSelected()
for i to selected_objects
  my_object[i] = selected(i)
endfor

for i to selected_objects
	selectObject(my_object[i])
	name$ = selected$("'originaltype$'")
	Read from file... 'directory$''name$'.'file_extension$'
	plus 'originaltype$' 'name$'
	View & Edit
endfor


