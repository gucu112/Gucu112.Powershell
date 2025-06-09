using Microsoft.Win32.SafeHandles;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Runtime.InteropServices;
using static Gucu112.Powershell.Utility.Win32.RestartManager;
using static Gucu112.Powershell.Utility.Win32.User;
using WindowsProcess = System.Diagnostics.Process;

namespace Gucu112.Powershell.Utility.Windows
{
    public static class Process
    {
        #region Private constants
        private const int SYSTEM_PROCESS_ID = 4;
        #endregion

        #region Public functions
        public static List<WindowsProcess> GetLockingProcesses(string path)
        {
            List<WindowsProcess> lockingProcesses;

            SafeHandle handle = null;
            try
            {
                int status = -1;

                status = RmStartSession(out handle, 0, Guid.NewGuid().ToString());

                if (status != 0)
                {
                    throw new Win32Exception(status, "Unable to start RM session.");
                }

                try
                {
                    string[] resources = new string[] { path };

                    status = RmRegisterResources(handle, (uint)resources.Length, resources, 0, null, 0, null);

                    if (status != 0)
                    {
                        throw new Win32Exception(status, "Unable to register resource.");
                    }

                    uint newCount = 0, count = 0;
                    // TODO: Check if needs to be null
                    RM_PROCESS_INFO[] processInfoArray = null; // new RM.RM_PROCESS_INFO[newCount];
                    RM_REBOOT_REASON restartReason = RM_REBOOT_REASON.RmRebootReasonNone;
                    try
                    {
                        status = RmGetList(handle, out newCount, ref count, out processInfoArray, ref restartReason);

                        if (status != 0 && status != RM_ERROR_MORE_DATA)
                        {
                            throw new Win32Exception(status, "Unable to list processes locking resource.");
                        }

                        if (status == RM_ERROR_MORE_DATA)
                        {
                            processInfoArray = new RM_PROCESS_INFO[count = newCount];
                            status = RmGetList(handle, out newCount, ref count, out processInfoArray, ref restartReason);
                        }

                        if (status != 0)
                        {
                            throw new Win32Exception(status, "Unable to list processes locking resource.");
                        }
                    }
                    finally
                    {
                        //restartReason.Dispose();
                    }

                    lockingProcesses = new List<WindowsProcess>((int)count);

                    for (int i = 0; i < count; i++)
                    {
                        try
                        {
                            lockingProcesses.Add(WindowsProcess.GetProcessById((int)processInfoArray[i].process.processId));
                        }
                        catch (ArgumentException)
                        {
                            // TODO: Filter exception better and log message that process is no longer running
                        }
                    }
                }
                finally
                {
                    status = RmEndSession(handle);

                    if (status != 0)
                    {
                        throw new Win32Exception(status, "Unable to end RM session.");
                    }
                }
            }
            finally
            {
                handle.Dispose();
            }

            return lockingProcesses;
        }

        public static WindowsProcess GetCurrent()
        {
            return WindowsProcess.GetCurrentProcess();
            // return Kernel.GetCurrentProcess();
        }

        public static WindowsProcess GetExplorer()
        {
            uint processId = 0;
            using (SafeProcessHandle shellWindow = new(GetShellWindow(), false))
            {
                if (shellWindow.IsInvalid)
                {
                    throw new Win32Exception(Marshal.GetLastWin32Error(), "Cannot get shell window.");
                }

                uint threadId = GetWindowThreadProcessId(shellWindow, out processId);
                if (processId == 0)
                {
                    throw new Win32Exception(Marshal.GetLastWin32Error(), "Cannot get shell process.");
                }
            }

            return WindowsProcess.GetProcessById((int)processId);
            // return Kernel.OpenProcess(Kernel.ProcessAccess.QueryInformation, true, processId);
        }

        public static WindowsProcess GetSystem()
        {
            return WindowsProcess.GetProcessById(SYSTEM_PROCESS_ID);
            // return Kernel.OpenProcess(Kernel.ProcessAccess.QueryInformation, true, SYSTEM_PROCESS_ID);
        }
        #endregion
    }

}
