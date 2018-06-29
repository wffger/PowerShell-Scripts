# (C) 2017 余东熹	https://github.com/wffger
#
# 此脚本转换当前目录文件为UTF-8编码
# 
############################### 
$filePath = ".\*." + $args[0]
$filePath
$fileArray=@()
$fileArray=Get-ItemPropertyValue -Path $filePath -Name name
If($fileArray -is [array])
{
    For($i=0;$i -lt $fileArray.Count; $i++)
    {
        Write-Host "正在处理第$($i+1)个文件 : $($fileArray[$i])"
        $filePath = ".\"+$fileArray[$i]
        $fileContent = Get-Content -Path $filePath
        $fileContent | Out-File -Encoding UTF8 -FilePath $filePath
    }
}
Else
{
        Write-Host "正在处理文件 : $fileArray"
        $filePath = ".\"+$fileArray
        $fileContent = Get-Content -Path $filePath
        $fileContent | Out-File -Encoding UTF8 -FilePath $filePath
        #Get-Content -Path $filePath | Out-File -Encoding UTF8 -FilePath $filePath
        Write-Host "$fileArray 处理完毕。"
}