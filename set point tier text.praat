form Analyze duration and pitches from labeled segments in files
comment Directory of TextGrid files
text textGrid_directory C:\Users\
comment Which point tier do you want to analyze?
integer point_tier 5
	
endform
# make a listing of all the textgrid files in a directory.
strings = Create Strings as file list: "list", textGrid_directory$ + "*.TextGrid"
numberOfFiles = Get number of strings
for ifile to numberOfFiles
	selectObject: strings
	filename$ = Get string: ifile
	Read from file... 'textGrid_directory$''filename$'
	tg_name$ = selected$ ("TextGrid", 1)

	numberOfpoints = Get number of points: point_tier
		
	for i from 1 to numberOfpoints
		select TextGrid 'tg_name$'
		Set point text: point_tier, i, "beat"
		endif
	endfor
	select TextGrid 'tg_name$'
	Write to text file... 'textGrid_directory$''tg_name$'.TextGrid
endfor
