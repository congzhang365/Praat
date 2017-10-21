## Written by Cong Zhang
## Language and Brain Laboratory, University of Oxford
## Last updated 3 June 2016

##  This script:
##  1. Opens all the sound files in a given directory, plus
##     their associated textgrids.
##  2. Get max f0 and min f0 within each interval of your selected tier.
##  3. Insert a point tier with the max and min f0.
##  4. View & Edit.
##  5. Save selected textgrids.


## This script is edited based on the scripts 
## 'Text grid reviewer' by Mark Antoniou,
## 'Save all selected objects to disk' by Jose J. Atria,
## and praat user group answer by Mauricio Figueroa.

form F0 point tier:
# Be sure not to forget the slash (Windows: backslash, OSX: forward
# slash)  at the end of the directory name.
	comment Your working directory:
	sentence Directory C:\Users\
#  Leaving the "Word" field blank will open all sound files in a
#  directory. By specifying a Word, you can open only those files
#  that begin with a particular sequence of characters. For example,
#  you may wish to only open tokens whose filenames begin with ba.
	comment Only analyse the files starting with...
	sentence Word
	comment What sound file type would you like to analyse?
	sentence Filetype wav
	comment Which segment tier would you like to analyse?
	integer tier 2
	comment New point tier
	integer newtier 4
	comment ______________________________________________________________________________________________________________
	comment Save selected objects...
	sentence Save_to C:\Users\point tier\
	comment Leave empty for GUI selector
	sentence Pad_name_with 
	comment Name padding used to create unique names
	boolean Overwrite no
	boolean Quiet yes
endform

Create Strings as file list... list 'directory$'*'filetype$'
number_of_files = Get number of strings
for x from 1 to number_of_files
     select Strings list
     current_file$ = Get string... x
     Read from file... 'directory$''current_file$'
     object_name$ = selected$ ("Sound")
     Read from file... 'directory$''object_name$'.TextGrid
     plus Sound 'object_name$'
     Edit
    sound_id    = selected("Sound")
	textgrid_id = selected("TextGrid")

	selectObject: sound_id
	pitch_id = To Pitch: 0.0, 75.0, 800.0

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
		nocheck Insert point: newtier, minimum_f0, "-"
		nocheck Insert point: newtier, maximum_f0, "+"
	  endif
	endfor

	selectObject: sound_id, textgrid_id
	View & Edit
	
	selectObject: sound_id, pitch_id
	Remove
endfor

####save the new textgrids####
pause select the new textgrids

verbose = if quiet then 0 else 1 fi
cleared_info = 0

@checkDirectory(save_to$, "Save objects to...")
directory$ = checkDirectory.name$

# Save selection
selected_objects = numberOfSelected()
for i to selected_objects
  my_object[i] = selected(i)
endfor

# Create Table to store object data
object_data = Create Table with column names: "objects", selected_objects,
  ..."id type name extension num"

# Populate Table with data
for i to selected_objects
  selectObject(my_object[i])
  type$ = extractWord$(selected$(), "")
  name$ = selected$(type$)

  if type$ = "Sound"
    extension$ = ".wav"
  elsif type$ != "LongSound"
    extension$ = "." + type$
  endif
    
  selectObject(object_data)
  Set numeric value: i, "id",        my_object[i]
  Set string value:  i, "type",      type$
  Set string value:  i, "name",      name$
  Set string value:  i, "extension", extension$
  Set numeric value: i, "num",       number(name$)
endfor

# Sort Table rows, 
Sort rows: "num name"

# create name conversion table
conversion_table = Collapse rows: "name type", "", "", "", "", ""
Append column: "new_name"

if !overwrite
  n = Get number of rows
  for i to n
    name$ = Get value: i, "name"
    type$ = Get value: i, "type"

    pad$ = ""
    repeat
      file_name$ = name$ + pad$ + extension$
      full_name$ = directory$ + "/" + file_name$
      
      pad$ = pad$ + pad_name_with$
      new_name$ = file_name$ - extension$
      converted = Search column: "new_name", new_name$
    until !(fileReadable(full_name$) or converted)

    if name$ != new_name$
      Set string value: i, "new_name", new_name$
    else
      Set string value: i, "name", ""
    endif
  endfor
endif

# Create saved names hash
used_names = Create Table with column names: "used_names", 0, "name n"

saved_files = 0

# Loop through objects, for saving
for i to selected_objects
  selectObject(object_data)
  id         = Get value: i, "id"
  type$      = Get value: i, "type"
  name$      = Get value: i, "name"
  extension$ = Get value: i, "extension"

  if !overwrite
    selectObject(conversion_table)
    converted = Search column: "name", name$
    if converted
      converted_name$ = Get value: converted, "new_name"
      name$ = converted_name$
    endif
  endif
    
  selectObject(used_names)
  used = Search column: "name", name$
  counter = 0
  if used
    counter = Get value: used, "n"
    Set numeric value: used, "n", counter+1
  else
    Append row
    r = Get number of rows
    Set numeric value: r, "n", 1
    Set string value: r, "name", name$
  endif
  
  counter$ = string$(counter)
  counter$ = if counter$ = "0" then "" else counter$ fi
  
  selectObject(id)

  file_name$ = name$ + counter$ + extension$
  full_name$ = directory$ + "/" + file_name$
  if type$ = "Sound"
    Save as WAV file: full_name$
  elsif type$ != "LongSound"
    Save as text file: full_name$
  endif

  if verbose
    if !cleared_info
      clearinfo
      cleared_info = 1
    endif
    appendInfoLine("Saved ", selected$(type$), " as ", full_name$)
  endif
  
endfor

removeObject(object_data, conversion_table, used_names)

if selected_objects
  selectObject(my_object[1])
  for i from 2 to selected_objects
    plusObject(my_object[i])
  endfor
endif

procedure checkDirectory (.name$, .label$)
  if .name$ = "" and praatVersion >= 5204
    .name$ = chooseDirectory$(.label$)
  endif
  if .name$ = ""
    exit
  endif
endproc


