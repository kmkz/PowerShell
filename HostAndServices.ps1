# A short and (a bit) slow script for reconnaissance purpose on restritect environment.
# Step 1: perform ping_sweep
# Step 2: when host is up, do services scan based on the pre-defined port list (web, db or lateral_movement, create your own!)

50..100 | %{

# ping sweep part
$ip = "10.0.0.$_";
write-host "Tesing host $ip ..."

$Check=$(Test-Connection -count 1 -comp 10.0.0.$_ -quiet)


$ErrorActionPreference = "SilentlyContinue"

if ($Check -eq "True") {
    write-host "Host: $ip is alive!"
    

    #port scan part
    write-host "Scanning ports ..."

    $lateral_mov=@(135,445,3389,5985)
    $web=@(80,8080,8443,443)
    $db=@(1433,3306,5432)

    ForEach($port in $web){
        
        $socket = new-object System.Net.Sockets.TcpClient($ip, $port)
        if ($socket -eq $null) {
           write-host "$port closed - " -ForegroundColor Red -NoNewline
        }
        else{
             write-host "$port open !"-foregroundcolor Green -NoNewline
             $socket = $null
            }
        }
    write-host "Port scan finished."
    }

}
