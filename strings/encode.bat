@echo off
set copycmd=/Y
set modDir=D:\acs_strings
set gameDir=D:\The Witcher 3 Wild Hunt GOTY - Ghost Mode
set id_space=2923
set modName=mod_ACS
 
if not exist "%modDir%\w3strings" mkdir "%modDir%\w3strings"

call w3strings.exe --encode "%modDir%\ar.w3strings.csv" --force-ignore-id-space-check-i-know-what-i-am-doing
move /Y ar.w3strings.csv.w3strings "%modDir%\w3strings\ar.w3strings"
del /F ar.w3strings.csv.w3strings.ws

call w3strings.exe --encode "%modDir%\br.w3strings.csv" --force-ignore-id-space-check-i-know-what-i-am-doing
move /Y br.w3strings.csv.w3strings "%modDir%\w3strings\br.w3strings"
del /F br.w3strings.csv.w3strings.ws

call w3strings.exe --encode "%modDir%\cn.w3strings.csv" --force-ignore-id-space-check-i-know-what-i-am-doing
move /Y cn.w3strings.csv.w3strings "%modDir%\w3strings\cn.w3strings"
del /F cn.w3strings.csv.w3strings.ws

call w3strings.exe --encode "%modDir%\cz.w3strings.csv" --force-ignore-id-space-check-i-know-what-i-am-doing
move /Y cz.w3strings.csv.w3strings "%modDir%\w3strings\cz.w3strings"
del /F cz.w3strings.csv.w3strings.ws

call w3strings.exe --encode "%modDir%\de.w3strings.csv" --force-ignore-id-space-check-i-know-what-i-am-doing
move /Y de.w3strings.csv.w3strings "%modDir%\w3strings\de.w3strings"
del /F de.w3strings.csv.w3strings.ws

call w3strings.exe --encode "%modDir%\en.w3strings.csv" --force-ignore-id-space-check-i-know-what-i-am-doing
move /Y en.w3strings.csv.w3strings "%modDir%\w3strings\en.w3strings"
del /F en.w3strings.csv.w3strings.ws

call w3strings.exe --encode "%modDir%\es.w3strings.csv" --force-ignore-id-space-check-i-know-what-i-am-doing
move /Y es.w3strings.csv.w3strings "%modDir%\w3strings\es.w3strings"
del /F es.w3strings.csv.w3strings.ws

call w3strings.exe --encode "%modDir%\esmx.w3strings.csv" --force-ignore-id-space-check-i-know-what-i-am-doing
move /Y esmx.w3strings.csv.w3strings "%modDir%\w3strings\esmx.w3strings"
del /F esmx.w3strings.csv.w3strings.ws

call w3strings.exe --encode "%modDir%\fr.w3strings.csv" --force-ignore-id-space-check-i-know-what-i-am-doing
move /Y fr.w3strings.csv.w3strings "%modDir%\w3strings\fr.w3strings"
del /F fr.w3strings.csv.w3strings.ws

call w3strings.exe --encode "%modDir%\hu.w3strings.csv" --force-ignore-id-space-check-i-know-what-i-am-doing
move /Y hu.w3strings.csv.w3strings "%modDir%\w3strings\hu.w3strings"
del /F hu.w3strings.csv.w3strings.ws

call w3strings.exe --encode "%modDir%\it.w3strings.csv" --force-ignore-id-space-check-i-know-what-i-am-doing
move /Y it.w3strings.csv.w3strings "%modDir%\w3strings\it.w3strings"
del /F it.w3strings.csv.w3strings.ws

call w3strings.exe --encode "%modDir%\jp.w3strings.csv" --force-ignore-id-space-check-i-know-what-i-am-doing
move /Y jp.w3strings.csv.w3strings "%modDir%\w3strings\jp.w3strings"
del /F jp.w3strings.csv.w3strings.ws

call w3strings.exe --encode "%modDir%\kr.w3strings.csv" --force-ignore-id-space-check-i-know-what-i-am-doing
move /Y kr.w3strings.csv.w3strings "%modDir%\w3strings\kr.w3strings"
del /F kr.w3strings.csv.w3strings.ws

call w3strings.exe --encode "%modDir%\pl.w3strings.csv" --force-ignore-id-space-check-i-know-what-i-am-doing
move /Y pl.w3strings.csv.w3strings "%modDir%\w3strings\pl.w3strings"
del /F pl.w3strings.csv.w3strings.ws

call w3strings.exe --encode "%modDir%\ru.w3strings.csv" --force-ignore-id-space-check-i-know-what-i-am-doing
move /Y ru.w3strings.csv.w3strings "%modDir%\w3strings\ru.w3strings"
del /F ru.w3strings.csv.w3strings.ws

call w3strings.exe --encode "%modDir%\tr.w3strings.csv" --force-ignore-id-space-check-i-know-what-i-am-doing
move /Y tr.w3strings.csv.w3strings "%modDir%\w3strings\tr.w3strings"
del /F tr.w3strings.csv.w3strings.ws

call w3strings.exe --encode "%modDir%\zh.w3strings.csv" --force-ignore-id-space-check-i-know-what-i-am-doing
move /Y zh.w3strings.csv.w3strings "%modDir%\w3strings\zh.w3strings"
del /F zh.w3strings.csv.w3strings.ws
 
robocopy "%modDir%\w3strings" "%modDir%\Packed\%modName%\content" /S
robocopy "%modDir%\Packed" "%gameDir%\mods" /S
 
pause