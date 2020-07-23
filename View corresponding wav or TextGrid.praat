## View sound file and TextGrid together

## Just have a look. It doesn't edit or modify the original file.
## To use the script:
## 1. Select a wav or textgrid file in Praat
## 2. Put in the address of its counterpart
## 3. 

## Written by Cong Zhang
## Language and Brain Laboratory, University of Oxford
## Last updated 23 Oct 2017

form Enter the directory for the target files 
	sentence directory C:\Users\
comment Open corresponding Sound or TextGrid
	choice type 
		button Sound (Source file: TextGrid)
		button TextGrid (Source file: wav)
endform


if type = 1
	filetype$ = "Sound"
	file_extension$ = "wav"
	originaltype$ = "TextGrid"
	original_extension$ = "TextGrid"
	
elsif type = 2
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


