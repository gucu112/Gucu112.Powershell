
using Microsoft.Win32.SafeHandles;
using System;
using System.Runtime.ConstrainedExecution;
using System.Runtime.InteropServices;
using System.Security;
using System.Security.Principal;
using ComType = System.Runtime.InteropServices.ComTypes;

namespace Gucu112.Powershell.Utility.Win32
{
    public static class AdvApi
    {
        [DllImport("advapi32.dll", SetLastError = true)]
        [return: MarshalAs(UnmanagedType.Bool)]
        public static extern bool OpenProcessToken(
            SafeHandle processHandle,
            TokenAccess tokenAccess,
            out SafeHandle tokenHandle
        );

        [DllImport("advapi32.dll", SetLastError = true)]
        public static extern bool DuplicateToken(
            SafeHandle existingTokenHandle,
            SecurityImpersonationLevel impersonationLevel,
            out SafeHandle duplicateTokenHandle
        );

        [DllImport("advapi32.dll", SetLastError = true, CharSet = CharSet.Auto)]
        public static extern bool DuplicateTokenEx(
            SafeHandle existingTokenHandle,
            TokenAccess tokenAccess,
            SafeHandle tokenAttributes,
            SecurityImpersonationLevel impersonationLevel,
            TokenType tokenType,
            out SafeHandle duplicateTokenHandle
        );

        [DllImport("advapi32.dll", SetLastError = true, CharSet = CharSet.Unicode)]
        [return: MarshalAs(UnmanagedType.Bool)]
        public static extern bool LogonUser(
            [MarshalAs(UnmanagedType.LPStr)] string username,
            [MarshalAs(UnmanagedType.LPStr)] string domain,
            [MarshalAs(UnmanagedType.LPStr)] string password,
            LogonType logonType,
            LogonProvider logonProvider,
            out SafeHandle token);

        [Flags()]
        public enum TokenAccess : int
        {
            STANDARD_RIGHTS_REQUIRED = 0x000F0000,
            STANDARD_RIGHTS_READ = 0x00020000,
            TOKEN_ASSIGN_PRIMARY = 0x0001,
            TOKEN_DUPLICATE = 0x0002,
            TOKEN_IMPERSONATE = 0x0004,
            TOKEN_QUERY = 0x0008,
            TOKEN_QUERY_SOURCE = 0x0010,
            TOKEN_ADJUST_PRIVILEGES = 0x0020,
            TOKEN_ADJUST_GROUPS = 0x0040,
            TOKEN_ADJUST_DEFAULT = 0x0080,
            TOKEN_ADJUST_SESSIONID = 0x0100,
            TOKEN_READ = (STANDARD_RIGHTS_READ | TOKEN_QUERY),
            TOKEN_MIN_ACCESS = (TOKEN_DUPLICATE | TOKEN_IMPERSONATE | TOKEN_QUERY),
            TOKEN_ALL_ACCESS = (STANDARD_RIGHTS_REQUIRED | TOKEN_ASSIGN_PRIMARY |
                TOKEN_DUPLICATE | TOKEN_IMPERSONATE | TOKEN_QUERY | TOKEN_QUERY_SOURCE |
                TOKEN_ADJUST_PRIVILEGES | TOKEN_ADJUST_GROUPS | TOKEN_ADJUST_DEFAULT |
                TOKEN_ADJUST_SESSIONID)
        }

        public enum SecurityImpersonationLevel
        {
            SecurityAnonymous = 0,
            SecurityIdentification = 1,
            SecurityImpersonation = 2,
            SecurityDelegation = 3
        }

        public enum TokenType
        {
            TokenPrimary = 1,
            TokenImpersonation = 2
        }

        public enum LogonType
        {
            LOGON32_LOGON_INTERACTIVE = 2,
            LOGON32_LOGON_NETWORK = 3,
            LOGON32_LOGON_BATCH = 4,
            LOGON32_LOGON_SERVICE = 5,
            LOGON32_LOGON_UNLOCK = 7,
            LOGON32_LOGON_NETWORK_CLEARTEXT = 8,
            LOGON32_LOGON_NEW_CREDENTIALS = 9
        }

        public enum LogonProvider
        {
            LOGON32_PROVIDER_DEFAULT = 0,
            LOGON32_PROVIDER_WINNT35 = 1,
            LOGON32_PROVIDER_WINNT40 = 2,
            LOGON32_PROVIDER_WINNT50 = 3
        }
    }

    public static class Kernel
    {
        [DllImport("kernel32.dll", SetLastError = true)]
        public static extern SafeHandle GetCurrentProcess();

        [DllImport("kernel32.dll", SetLastError = true)]
        public static extern SafeHandle OpenProcess(
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

    public static class RM
    {
        [DllImport("rstrtmgr.dll", CharSet = CharSet.Auto)]
        public static extern int RmStartSession(
            out SafeHandle sessionHandle,
            int sessionFlags,
            string sessionKey
        );

        [DllImport("rstrtmgr.dll", CharSet = CharSet.Unicode)]
        public static extern int RmRegisterResources(
            SafeHandle sessionHandle,
            uint files,
            string[] fileNamesList,
            uint applications,
            RM_UNIQUE_PROCESS[] applicationsList,
            uint services,
            string[] serviceNamesList
        );

        [DllImport("rstrtmgr.dll")]
        public static extern int RmGetList(
            SafeHandle sessionHandle,
            out uint procInfoNeeded,
            ref uint procInfo,
            out RM_PROCESS_INFO[] affectedApps,
            ref SafeHandle rebootReasons
        );

        [DllImport("rstrtmgr.dll")]
        public static extern int RmEndSession(
            SafeHandle sessionHandle
        );

        [StructLayout(LayoutKind.Sequential)]
        public struct RM_UNIQUE_PROCESS
        {
            public uint processId;
            public ComType.FILETIME processStartTime;
        }

        [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Unicode)]
        public struct RM_PROCESS_INFO
        {
            public RM_UNIQUE_PROCESS process;
            [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 256)] public string appName;
            [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 64)] public string serviceShortName;
            public RM_APP_TYPE applicationType;
            public ulong appStatus;
            public uint tsSessionId;
            [MarshalAs(UnmanagedType.Bool)] public bool restartable;
        }

        public enum RM_APP_TYPE
        {
            RmUnknownApp = 0,
            RmMainWindow = 1,
            RmOtherWindow = 2,
            RmService = 3,
            RmExplorer = 4,
            RmConsole = 5,
            RmCritical = 1000
        }
    }

    public static class User
    {
        [DllImport("user32.dll", SetLastError = true)]
        public static extern SafeHandle GetShellWindow();

        [DllImport("user32.dll", SetLastError = true)]
        public static extern uint GetWindowThreadProcessId(
            SafeHandle windowHandle,
            out uint processId
        );
    }

    public class SafeHandle : SafeHandleZeroOrMinusOneIsInvalid
    {
        public SafeHandle(bool ownHandle = true) : base(ownHandle)
        {
        }

        public SafeHandle(IntPtr handle, bool ownHandle = true) : base(ownHandle)
        {
            this.SetHandle(handle);
        }

        public WindowsIdentity GetWindowsIdentity()
        {
            if (this.IsClosed)
            {
                throw new ObjectDisposedException("Handle has been released.");
            }

            if (this.IsInvalid)
            {
                throw new InvalidOperationException("Handle is invalid.");
            }

            return new WindowsIdentity(this.handle);
        }

        [ReliabilityContract(Consistency.WillNotCorruptState, Cer.Success)]
        protected override bool ReleaseHandle()
        {
            return Kernel.CloseHandle(this.handle);
        }
    }
}
