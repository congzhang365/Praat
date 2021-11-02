form Parameters
    comment Directory that contains the textgrids
    sentence indir C:/Users/indir
    sentence outdir C:/Users/outdir
	comment remove text in the following tier
	integer remove_text 3
endform


Create Strings as file list... fileList 'indir$'/*.TextGrid
numberOfFiles = Get number of strings

for ifile from 1 to numberOfFiles
select Strings fileList
fileName$ = Get string... ifile
dotInd = rindex(fileName$, ".")
tgName$ = left$(fileName$, dotInd - 1)
printline Processing file 'tgName$'...
Read from file... 'indir$'/'tgName$'.TextGrid
select TextGrid 'tgName$'

Remove tier: 10
Remove tier: 9
Remove tier: 7
Remove tier: 6
Remove tier: 5
Remove tier: 3
Remove tier: 2

Replace interval texts: remove_text, 1, 0, ".*", "", "Regular Expressions"
# Insert interval tier: 7, "stress"
# Insert interval tier: 8, "distance"
# Insert interval tier: 9, "AM"
# Insert interval tier: 10, "type"
 
Write to text file... 'outdir$'/'tgName$'.TextGrid
writeInfoLine: ifile, "/", numberOfFiles, " files have been processed"

endfor

pause remove all textgrids?

select all
Remove