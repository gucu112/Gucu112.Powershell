using System.Runtime.InteropServices;
using ComType = System.Runtime.InteropServices.ComTypes;

namespace Gucu112.Powershell.Utility.Win32
{
    public static class RestartManager
    {
        public const int RM_ERROR_MORE_DATA = 234;

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
            ref RM_REBOOT_REASON rebootReasons
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

        public enum RM_REBOOT_REASON
        {
            RmRebootReasonNone = 0x0,
            RmRebootReasonPermissionDenied = 0x1,
            RmRebootReasonSessionMismatch = 0x2,
            RmRebootReasonCriticalProcess = 0x4,
            RmRebootReasonCriticalService = 0x8,
            RmRebootReasonDetectedSelf
        }
    }
}
