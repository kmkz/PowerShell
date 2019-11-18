$Global:SCCMSQLSERVER = "DB-SRV\SQL"
$Global:DBNAME = "DATABASE"
$Global:uid = "sa"
$Global:pwd = "D4passwd"

Try{
  $SQLConnection = New-Object System.Data.SQLClient.SQLConnection
  $SQLConnection.ConnectionString ="server=$SCCMSQLSERVER;database=$DBNAME;Integrated Security=False; uid=$uid; pwd=$pwd"
  $SQLConnection.Open()
}

catch{
    [System.Windows.Forms.MessageBox]::Show("Failed to connect SQL Server:") 

}

$SQLCommand = New-Object System.Data.SqlClient.SqlCommand
$SQLCommand.CommandText = "SHOW @@version"
$SQLCommand.Connection = $SQLConnection

$SQLAdapter = New-Object System.Data.SqlClient.SqlDataAdapter
$SqlAdapter.SelectCommand = $SQLCommand                 
$SQLDataset = New-Object System.Data.DataSet
$SqlAdapter.fill($SQLDataset) | out-null

$tablevalue = @()
foreach ($data in $SQLDataset.tables[0]){
  $tablevalue = $data[0]
  $tablevalue
} 
$SQLConnection.close()
