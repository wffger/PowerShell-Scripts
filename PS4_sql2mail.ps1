##############################################################
# (C) 2017 wffger
# https://github.com/wffger
# 此脚本根据传入文件参数
# 查询Oracle数据库获取收件人及主题内容，发送邮件
##############################################################

#读入配置文件，源文件
param($a)
$data_xml=[xml](Get-Content $a)
Write-Host "配置参数..."
#配置邮件服务器
$smtp = $data_xml.root.smtp.server
$username= $data_xml.root.smtp.username
$password = $data_xml.root.smtp.password | ConvertTo-SecureString -asPlainText -Force
$from = $username
$cred = New-Object System.Management.Automation.PSCredential($username,$password)

#连接Oracle数据库
$username = $data_xml.root.oracle.username
$password = $data_xml.root.oracle.password
$datasource = $data_xml.root.oracle.datasource
$connection_string = "User Id=$username;Password=$password;Data Source=$datasource"
$statement = "select t.fill_table, t.email from check_rqman t"

add-type -AssemblyName System.Data.OracleClient
try{
    $con = New-Object System.Data.OracleClient.OracleConnection($connection_string)
    $con.Open()
    $cmd = $con.CreateCommand()
    $cmd.CommandText = $statement
    $result = $cmd.ExecuteReader()
    $data = New-Object System.Data.DataTable
    $data.Load($result)
    foreach ($line in $data)
    {
        #多个收件人地址使用逗号分隔
        $to = ($line.email -split ",")
        $subject = "填报平台提醒"
        $fill_table = $line.fill_table
        $body = "您好，请您及时填报${fill_table}。"

        try {
            Send-MailMessage -SmtpServer $smtp -To $to -From $from -Credential $cred -Subject $subject -Body $body -Encoding UTF8
        } catch {
            Write-Host "发送失败..."
        } finally{
            Write-Host "发送完毕..."
        }
    }
} catch {
    Write-Error (“Database Exception: {0}`n{1}” -f `
        $con.ConnectionString, $_.Exception.ToString())
} finally{
    if ($con.State -eq ‘Open’) { $con.close() }
}
