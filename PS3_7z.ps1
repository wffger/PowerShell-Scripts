##############################################################
# (C) 2017 wffger 
# https://github.com/wffger
# 此脚本调用7z压缩文件夹
# 
##############################################################
 
Write-Host "判断是否已安装7-zip..."
if (-not (test-path "$env:ProgramFiles\7-Zip\7z.exe")) {throw "$env:ProgramFiles\7-Zip\7z.exe needed"} 
set-alias 7z "$env:ProgramFiles\7-Zip\7z.exe" 
Write-Host "配置参数..."
$today = get-date
$lastMon = $today.AddMonths(-1).ToString('yyyyMM')
$prnFldr = $lastMon 
$Source = ".\"+$prnFldr+"\*" 
$Target = ".\"+$prnFldr+".7z"
Write-Host "开始压缩..."
7z a $Target $Source
###############################
Write-Host "压缩完成，按任意键结束..."
$null = [System.Console]::ReadKey()