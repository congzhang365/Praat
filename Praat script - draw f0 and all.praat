## Modified by Cong Zhang
## Language and Brain Laboratory, University of Oxford
## Last updated 28 November 2016
##
## This script draws waveform, spectrogram, F0, and TextGrid
## My changes:
## 	1. Slimmed the form section. Now all contents can be shown even in smaller computer screens.
##		(Original lines are kept for personal preferences.)
## 	2. Can choose to print file names.
##	3. Can choose where the file names are -- 1 top or 2 bottom.
##	4. Can choose picture formats: 
##		1 -- 300dpi png (recommended)
##		2 -- pdf
## 		3, 4, 5 -- wmf, eps, praat picture (original)
## 		6 -- 600dpi png
## 
## This script is edited based on the script
## 'draw-waveform-sgram-f0.praat' by Pauline Welby (welby@ling.ohio-state.edu, welby@icp.inpg.fr).
## This script is distributed under the GNU General Public License.
################################################################

# Form that queries the user to specify the name of various relevant
# directories and other parameters

form Input directory name
    comment Sound file directory, TextGrid directory:
    sentence soundDir C:\Users
    #comment Enter parent directory where TextGrid files are kept:
    sentence textDir C:\Users
    comment Enter directory where figure files will be saved:
    sentence figDir C:\Users
    #comment Superimpose f0 curve?
    #boolean superimp_f0 yes
    comment Enter F0 minimum and maximum:
    positive f0min 75
    #comment Enter F0 maximum:
    positive f0max 350
    comment Enter x axis and y axis labels:
    sentence xaxis Time (s)
    #comment Enter y axis:
    sentence yaxis Pitch (Hz)
    #comment Enter x axis (time) major unit:
    #positive timeMajUnit 0.1
    #comment Enter x axis (time) minor unit:
    #positive timeMinUnit 0.1
    comment Enter right boundary of figure (specify width)
    positive rightBound 10 
    comment Enter lower boundary of TextGrid/inner box:
    positive tgridBot 7
	comment Add file name?
	boolean addfilename yes
	#
	optionmenu NamePosition: 1
	option Top
	option Bottom
	#
    optionmenu Format: 1
	option png-300dpi
	option pdf
	option wmf
	option eps
	option praatPic
	option png-600dpi
	
	#comment Save as Windows media file?
    #boolean wmf yes
    #comment Save as encapsulated Postscript file?
    #boolean eps no
    #comment Save as as praat picture file?
    #boolean praatPic no
endform

# Create list of .wav files

## uncomment to read files from a list
# Read Strings from raw text file... 'soundDir$'\list.txt

Create Strings as file list... list 'soundDir$'\*.wav

# loop that goes through all the specified files

numberOfFiles = Get number of strings
for ifile to numberOfFiles
   select Strings list
   fileName$ = Get string... ifile
   baseFile$ = fileName$ - ".wav"

   # Read in the TextGrid file and .wav file with that base name

   Read from file... 'textDir$'\'baseFile$'.TextGrid
   Read from file... 'soundDir$'\'baseFile$'.wav

   select Sound 'baseFile$'
   # Make Pitch object
   # set whether you want to have f0 superimposed
   superimp_f0 = 1
   
   if superimp_f0 = 1
     To Pitch... 0.005 75 600
   endif

   # Make Spectrogram object
   select Sound 'baseFile$'
   To Spectrogram... 0.005 10000 0.002 20 Gaussian

   # Draw in Praat picture window.  These specifications draw a Sound object (waveform) and under that,
   # a Pitch object superimposed Spectrogram object.  The TextGrid is
   # drawn and then the entire picture is enclosed in a box.
   # 
   # To change these specifications (and indeed, to make all types of changes to a Praat script): 
   # In the Script window: Edit | Clear history. Draw a sample picture in the Praat picture the way you 
   # want it to appear, then place your cursor in the Script window and do: 
   # Edit | Paste history.  You'll have to add in the appropriate variables (here, baseFile), 
   # but you'll get the right structure.

     # Specify font type size, color
     Times
     Font size... 15
     Black

     # Define size and position of waveform (by specifying grid coordinates)
     Viewport... 0 'rightBound' 0 2

     # Draw waveform
     select Sound 'baseFile$'
     Draw... 0 0 0 0 no curve
 
     # Define size and position of spectrogram
     Viewport... 0 'rightBound' 1 5

     # Draw spectrogram
     select Spectrogram 'baseFile$'
     Paint... 0 0 0 0 100 yes 50 6 0 no
	 

     if superimp_f0 = 1
       # Draw Pitch curve
       # first as a thick white line
       select Pitch 'baseFile$'
       Line width... 15
       White
       Draw... 0 0 'f0min' 'f0max' no

       # then as a thin black line
       Line width... 4
       Black
       Draw... 0 0 'f0min' 'f0max' no

       # Label y axis
       # N.B.: can change language of labels here. 
       # Also, Praat default label for y axis is "Pitch".
	   	
       Line width... 1
       One mark left... 'f0max' no no yes
       One mark left... 'f0min' no no yes
       Marks left every... 1 50 yes yes no
       Text left... yes 'yaxis$'
       Draw... 0 0 'f0min' 'f0max' no
     endif

     # Set time units 
	 # Label x axis 
	 timeMinUnit = 0.1
	 timeMajUnit = 0.1
	 
     Text bottom... yes 'xaxis$'
     Marks bottom every... 1 'timeMinUnit' no yes no
     Marks bottom every... 1 'timeMajUnit' yes yes no

# Add filename to the picture
# Choose viewport first:  
#0-rightbound is the width (from 0 to the right bound you set); #0-0.5 is the height(from 0 to 0.5)

if addfilename = 1
	if 'NamePosition' = 1
	Viewport... 0 'rightBound' 0 0.5
	Viewport text... "Centre" "Half" 0 'baseFile$'
	endif
	
	if 'NamePosition' = 2
	Viewport... 0 'rightBound' 6 7
	Viewport text... "Centre" "Bottom" 0 'baseFile$'
	endif
endif

###########################################################

## To print F0 labels that follow the f0 contour,
## create a second TextGrid file (named baseFile2) 
##  with only the F0 label tier
## and uncomment the following lines

## Reads in the F0-labels-only TextGrid
#Read from file... 'textDir$'\'baseFile$'2.TextGrid

## Defines size and position of pitch curve and F0 labels 
## N.B.: must be the same as early pitch curve
#Viewport... 0 'rightBound' 1 5

## Draw first in white

#White

## Select TextGrid and Pitch objects together, so labels will
## follow pitch curve

#select TextGrid 'baseFile$'2
#plus Pitch 'baseFile$'
#Draw... 1 0 0 'f0min' 'f0max' 18 yes Centre no

## Draw in black

#Black
#select TextGrid 'baseFile$'2
#plus Pitch 'baseFile$'
#Draw... 1 0 0 'f0min' 'f0max' 16 yes Centre no

###########################################################

   # Define size and position of TextGrid
   Viewport... 0 'rightBound' 3 'tgridBot'

   # Draw TextGrid
   select TextGrid 'baseFile$'
   Draw... 0 0 yes yes no

   # Define size and position of inner box
   Viewport... 0 'rightBound' 0 'tgridBot'

   # Draw inner box
   Black
   Draw inner box

#change picture type if needed


   
  # Write to a file (see choices under File in the Praat picture window)
     if 'Format' = 1
     Save as 300-dpi PNG file... 'figDir$'\'baseFile$'.png
   endif
      if 'Format' = 2
     Save as PDF file...... 'figDir$'\'baseFile$'.pdf
   endif
  
   if 'Format' = 3
     Write to Windows metafile... 'figDir$'\'baseFile$'.wmf
   endif

   if 'Format' = 4
     Write to EPS file... 'figDir$'\'baseFile$'.eps
   endif

   if 'Format' = 5
     Write to praat picture file... 'figDir$'\'baseFile$'.praapic
   endif
   if 'Format' = 6
     Save as 600-dpi PNG file... 'figDir$'\'baseFile$'.png
   endif

   # Erase picture before going onto next object in list
   Erase all

   # Remove objects from Praat objects list
   select Spectrogram 'baseFile$'
   plus TextGrid 'baseFile$'
   plus Sound 'baseFile$'
   Remove
   
   # Remove Pitch object, if necessary
   if superimp_f0 = 1
     select Pitch 'baseFile$'
     Remove
   endif

endfor

# Remove object list

select Strings list
Remove

################################################################
#END OF SCRIPT -- HAPPY, HAPPY, JOY, JOY!
################################################################
