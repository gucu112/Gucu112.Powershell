using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Diagnostics;
using System.Runtime.InteropServices;
using Gucu112.Powershell.Utility.Win32;

namespace Gucu112.Powershell.Utility
{
    public static class WindowsProcess
    {
        #region Private constants
        private const int SYSTEM_PROCESS_ID = 4;
        private const int RM_ERROR_MORE_DATA = 234;
        #endregion

        #region Public functions
        public static List<Process> GetLockingProcesses(string path)
        {
            List<Process> lockingProcesses;

            Win32.SafeHandle handle = new Win32.SafeHandle();
            try {
                int status = -1;

                status = RM.RmStartSession(out handle, 0, Guid.NewGuid().ToString());

                if (status != 0) {
                    throw new Win32Exception(status, "Unable to start RM session.");
                }

                try {
                    string[] resources = new string[] { path };

                    status = RM.RmRegisterResources(handle, (uint)resources.Length, resources, 0, null, 0, null);

                    if (status != 0) {
                        throw new Win32Exception(status, "Unable to register resource.");
                    }

                    uint newCount = 0, count = 0;
                    // TODO: Check if needs to be null
                    RM.RM_PROCESS_INFO[] processInfoArray = null; // new RM.RM_PROCESS_INFO[newCount];
                    Win32.SafeHandle restartReason = new Win32.SafeHandle();
                    try {
                        status = RM.RmGetList(handle, out newCount, ref count, out processInfoArray, ref restartReason);

                        if (status != 0 && status != RM_ERROR_MORE_DATA) {
                            throw new Win32Exception(status, "Unable to list processes locking resource.");
                        }

                        if (status == RM_ERROR_MORE_DATA) {
                            processInfoArray = new RM.RM_PROCESS_INFO[count = newCount];
                            status = RM.RmGetList(handle, out newCount, ref count, out processInfoArray, ref restartReason);
                        }

                        if (status != 0) {
                            throw new Win32Exception(status, "Unable to list processes locking resource.");
                        }
                    } finally {
                        restartReason.Dispose();
                    }

                    lockingProcesses = new List<Process>((int)count);

                    for (int i = 0; i < count; i++)
                    {
                        try
                        {
                            lockingProcesses.Add(Process.GetProcessById((int)processInfoArray[i].process.processId));
                        }
                        catch (ArgumentException)
                        {
                            // TODO: Filter exception better and log message that process is no longer running
                        }
                    }
                } finally {
                    status = RM.RmEndSession(handle);

                    if (status != 0) {
                        throw new Win32Exception(status, "Unable to end RM session.");
                    }
                }
            } finally {
                handle.Dispose();
            }

            return lockingProcesses;
        }

        public static Process GetCurrent() {
            return Process.GetCurrentProcess();
            // return Kernel.GetCurrentProcess();
        }

        public static Process GetExplorer()
        {
            uint processId = 0;
            using (Win32.SafeHandle shellWindow = User.GetShellWindow()) {
                if (shellWindow.IsInvalid)
                {
                    throw new Win32Exception(Marshal.GetLastWin32Error(), "Cannot get shell window.");
                }

                uint threadId = User.GetWindowThreadProcessId(shellWindow, out processId);
                if (processId == 0)
                {
                    throw new Win32Exception(Marshal.GetLastWin32Error(), "Cannot get shell process.");
                }
            }

            return Process.GetProcessById((int)processId);
            // return Kernel.OpenProcess(Kernel.ProcessAccess.QueryInformation, true, processId);
        }

        public static Process GetSystem()
        {
            return Process.GetProcessById(SYSTEM_PROCESS_ID);
            // return Kernel.OpenProcess(Kernel.ProcessAccess.QueryInformation, true, SYSTEM_PROCESS_ID);
        }
        #endregion
    }

}
