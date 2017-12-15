############################### 
# (C) 2017 wffger 
# https://github.com/wffger
# 此脚本根据传入文件路径参数
# 从MSSQL导出数据到CSV
############################### 

#读入配置文件，源文件
param($a,$b)
$data_xml=[xml](Get-Content $a)
$data_csv=Import-Csv $b

Write-Host "配置参数..."
$dbserver = $data_xml.root.mssql.server
$dbname	= $data_xml.root.mssql.database
$userid = $data_xml.root.mssql.username
$passwd = $data_xml.root.mssql.password
$today = get-date
$lastMon = $today.AddMonths(-1).ToString('yyyyMM')
$prnFldr = '.\'+$lastMon
###############################
Write-Host "创建连接..."
$con = New-Object System.Data.SqlClient.SqlConnection
$con.ConnectionString = "Server=$dbserver; Database=$dbname; User Id=$userid; Password=$passwd"
$con.Open()
###############################
Write-Host "导出数据..."
$sql = $con.CreateCommand()
$data = New-Object System.Data.DataTable

FOREACH ($line in $data_csv) { 
    $table=$line.table
    $desc=$line.desc
    $query=$line.query

    if (![string]::IsNullOrEmpty($query)) {$sql.CommandText = $query}
    $result = $sql.ExecuteReader()
    $data.Load($result)
    $target = $prnFldr+$desc+'.csv'
    $data |Export-Csv -Encoding UTF8 -NoTypeInformation -Path $target
    Write-Host "已从${table}导出${desc}数据。" 
}

###############################
Write-Host "关闭连接..."
$con.Close()

###############################
Write-Host "按任意键结束..."
$null = [System.Console]::ReadKey()