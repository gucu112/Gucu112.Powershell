using Microsoft.Win32.SafeHandles;
using System;
using System.Runtime.ConstrainedExecution;
using System.Runtime.InteropServices;
using System.Security;

namespace Gucu112.Powershell.Utility.Win32
{
    public static class Kernel
    {
        [DllImport("kernel32.dll", SetLastError = true)]
        public static extern SafeProcessHandle GetCurrentProcess();

        [DllImport("kernel32.dll", SetLastError = true)]
        public static extern SafeProcessHandle OpenProcess(
            ProcessAccess processAccess,
            bool inheritHandle,
            uint processId
        );

        [DllImport("kernel32.dll", SetLastError = true)]
        [ReliabilityContract(Consistency.WillNotCorruptState, Cer.Success)]
        [SuppressUnmanagedCodeSecurity]
        public static extern bool CloseHandle(
            IntPtr objectHandle
        );

        [Flags()]
        public enum ProcessAccess : int
        {
            CreateThread = 0x2,
            DuplicateHandle = 0x40,
            QueryInformation = 0x400,
            SetInformation = 0x200,
            Terminate = 0x1,
            VMOperation = 0x8,
            VMRead = 0x10,
            VMWrite = 0x20,
            Synchronize = 0x100000,
            AllAccess = CreateThread | DuplicateHandle | QueryInformation | SetInformation
                | Terminate | VMOperation | VMRead | VMWrite | Synchronize
        }
    }
}
