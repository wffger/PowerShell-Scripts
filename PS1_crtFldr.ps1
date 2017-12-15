##############################################################
# (C) 2017 wffger 
# https://github.com/wffger
# 此脚本创建文件夹
# 
##############################################################

$today = get-date
$lastMon = $today.AddMonths(-1).ToString('yyyyMM')
$prnFldr = '.\'+$lastMon+'营运区'
$mtmFldr = $prnFldr+'\环比'
$ytdFldr = $prnFldr+'\同比\累计同比'
$ytyFldr = $prnFldr+'\同比\月度同比'
$path = $mtnFldr+','+$ytdFldr+','+$ytyFldr
 
md $mtmFldr -Force  
md $ytdFldr -Force  
md $ytyFldr -Force  
###############################
Write-Host "按任意键结束..."
$null = [System.Console]::ReadKey()