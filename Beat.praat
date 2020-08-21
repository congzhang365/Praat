## This script is to label beat for songs.
## Please open an audio file in Praat, select the audio file, then run this script. 
## 1. It assumes an initial delay. Please put in the initial delayed time.
## 	  For instance, the regular interval starts from 5.01s, then this number is 5.01.
## 2. It also has a field for the tempo. The formula then caculates the regular interval as 60/tempo
## 3. The last field needs the directory where you would like to save your file. 
## 4. If the textgrid is already in the output folder, 
## 	  a conversation box will come up to ask you which tier you would like the new tier to be.
##
## Dr Cong Zhang, University of Kent
## Last updated 09 June 2020

form Enter directory and search string
	comment Put in the initial delay time (seconds)
	real intercept 0.5
	comment What is the tempo?
	real tempo 150
	comment Save selected TextGrid?
	boolean save_tg 0
	sentence save_to C:\folder\
endform

#New section in Praat info window
appendInfoLine:"------",date$(),"------"


object_name$ = selected$ ("Sound")
audio_dur = Get finishing time
txtgrd$ = object_name$ + ".TextGrid"

if fileReadable(txtgrd$)
	Read from file... 'txtgrd$'
	select TextGrid 'object_name$'
	beginPause: "Textgrid already exist! Add new tier to existing textgrid?" 
		comment: "Which tier would you like to add?"
		natural: "tier_num", 1
	endPause: "ok", 1
	Insert point tier: tier_num, "beat" 
	
else
	select Sound 'object_name$'
	To TextGrid: "beat", "beat"
	tier_num = 1
	select TextGrid 'object_name$'
endif

i = 0
repeat
	if i = 0 or i mod 4 = 0
		Insert point: tier_num, intercept + (60/tempo)*i, "strong"
		i = i + 1
	else
		Insert point: tier_num, intercept + (60/tempo)*i, "weak"
		i = i + 1
	endif
until intercept + (60/tempo)*i > audio_dur

if save_tg = 1
	Save as text file... 'save_to$'\'object_name$'.TextGrid
endif
