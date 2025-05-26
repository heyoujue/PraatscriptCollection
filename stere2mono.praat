#This is a script for extracting certain channel batchly.
#Script date（2023.8）
#Author:何友珏 Youjue He （heyoujue.com） 
#Any suggestion or advice email to：info@heyoujue.com


form Information
	sentence Open_File_Path 
	sentence Save_File_Path
	sentence channel
endform

dirPath$=open_File_Path$
savePath$=save_File_Path$
channelopt$=channel$

channelNum = number(channelopt$)

#MacOS should change "\" to "/"

if right$(dirPath$,1)<>"\" 
	dirPath$=dirPath$+"\"
endif
if right$(savePath$,1)<>"\" 
	savePath$=savePath$+"\"
endif


Create Strings as file list... list 'dirPath$'*.wav
fileNum= Get number of strings

for ifile to fileNum
	select Strings list
	fileName$ = Get string... ifile
	newFileName$ = fileName$ - ".wav"
	wavFileName$=newFileName$ +".wav"
	wavFileName$ = dirPath$ +wavFileName$
	saveFileName$= newFileName$ +".wav"
	saveFileName$ = savePath$ +saveFileName$
	Read from file... 'wavFileName$'
	select Sound 'newFileName$'
	Extract one channel: channelNum
	Save as WAV file... 'saveFileName$'
	select all
	minus Strings list
	Remove
endfor

