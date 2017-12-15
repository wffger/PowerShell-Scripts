##############################################################
# (C) 2017 wffger 
# https://github.com/wffger
# 此脚本根据传入文件参数
# 获取收件人地址，根据desc匹配当前目录下的csv，并作为附件发送
##############################################################

#读入配置文件，源文件
param($a,$b)
$data_xml=[xml](Get-Content $a)
$data_csv=Import-Csv -Path $b -Delimiter ','

Write-Host "配置参数..."
$smtp = $data_xml.root.smtp.server
$username= $data_xml.root.smtp.username
$password = $data_xml.root.smtp.password | ConvertTo-SecureString -asPlainText -Force
$from = $username
$cred = New-Object System.Management.Automation.PSCredential($username,$password)

foreach ($line in $data_csv) 
{ 
    $to = $line.addressee
    $subject = $line.subject  
    $body = $line.body
    $file =  $line.desc 
    $str = '*'+$file+'.csv'
    $file = Dir .\ -filter $str
    Send-MailMessage -SmtpServer $smtp -To $to -From $from -Credential $cred -Subject $subject -Body $body -attachment $file -Encoding UTF8 
}  

Write-Host "发送完毕..."