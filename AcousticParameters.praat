!本脚本由何友珏（https://www.heyoujue.com/）改编自冉启斌（https://www.ranqibin.com/）老师的脚本。任何问题欢迎电邮联系info@heyojue.com
# This script was adapted by Youjue He（何友珏 https://www.heyoujue.com/）from Professor Qibin Ran's（冉启斌 https://www.ranqibin.com/）works, feel free to email(info@heyojue.com) me if you have any trouble with it.
!请确保wav文件和TextGrid文件同名，并在同一文件夹目录下。
# Make sure your wav and TextGrid files have the same name and put them in the same filefolder.
!macOs用户请使用"/"，windows用户请使用“\”
# slash"/" for macOs  users while backslash "\" for windows users. 

form Get acoustic parameters of labeled segments
	comment Where are your wav/TextGridfiles?
	text openpath C:\Users\heyoujue\Documents\CW\F1
	comment Which tier of the TextGrid object would you like to analyse?
	integer Tier 1
	comment Enter speaker gender (m or f only)
	sentence Gender m
	comment How many formant numbers would you like to extract?
	integer pointnum 10
	comment Which algorithm would you like to choose?
	choice: "Algorithm", 2
		option: "Autocorrelation(ac)"
		option: "Crosscorrelation(cc)"
	comment Output Name
	sentence outputName: outputName

endform


if right$(openpath$,1)<>"\"
	openpath$=openpath$+"\"
endif

if right$(outputName$,4)<>".txt"
	outputName$=outputName$+".txt"
endif

Create Strings as file list... fileList 'openpath$'*.TextGrid
numberOfFiles=Get number of strings

saveFileName$ =  outputName$
saveFileName$ = openpath$ + saveFileName$

filedelete 'saveFileName$'

fileappend "'saveFileName$'" file'tab$'label'tab$'step'tab$'F1'tab$'F2'tab$'F3'tab$'F0'tab$'HNR'tab$'duration'newline$'

for ifile from 1 to numberOfFiles
	select Strings fileList
	fileName$=Get string... 'ifile'
	rawName$=fileName$-".TextGrid"
	wavName$=rawName$+".wav"

	Read from file... 'openpath$''wavName$'

    	 if gender$ = "f"
     	     To Formant (burg)... 0.0025 5 5500 0.025 50
       	   else
       	   To Formant (burg)... 0.0025 5 5000 0.025 50
    	 endif

	Read from file... 'openpath$''wavName$'
	select Sound 'rawName$'

	if algorithm = 2
		To Harmonicity (cc): 0.01, 75, 0.1, 1
	elsif algorithm = 1
		To Harmonicity (ac): 0.01, 75, 0.1, 4.5
	endif

	select Sound 'rawName$'
	To Pitch... 0.01 75 600


	!Read from file... 'openpath$''wavName$'
	Read from file... 'openpath$''fileName$'


	numberOfIntervals = Get number of intervals... tier

	for interval from 1 to numberOfIntervals
		select TextGrid 'rawName$'
		label$ = Get label of interval... tier interval
		# if the interval has some text as a label, then calculate the duration.
		if label$ <> ""
			start = Get starting point... tier interval
			end = Get end point... tier interval
			duration = end - start
			select Formant 'rawName$'
			stepnum=pointnum-1
			tempstep=duration/stepnum
			for ii from 0 to stepnum
				tempTime=start+tempstep*ii
				stepn = ii+1
				select Formant 'rawName$'

                      			f_one = Get value at time... 1 'tempTime' Hertz Linear
                       			f_two = Get value at time... 2 'tempTime' Hertz Linear
                      			f_three = Get value at time... 3 'tempTime' Hertz Linear

                      		select Pitch 'rawName$'
					f_zero = Get value at time... 'tempTime' Hertz Linear

				select Harmonicity 'rawName$'
                      			hnr = Get value at time: 'tempTime', "cubic"
            	        			duration = (end - start) * 1000
                        	fileappend "'saveFileName$'" 'rawName$''tab$''label$''tab$''stepn''tab$''f_one:0''tab$''f_two:0''tab$''f_three:0''tab$''f_zero:0''tab$''hnr:4''tab$''duration:3''newline$'
                	endfor
		endif
	endfor

select all
minus Strings fileList
Remove

endfor

select all
Remove

exit OK!所有数据已经提取完毕！

