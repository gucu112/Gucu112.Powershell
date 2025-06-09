using Microsoft.Win32.SafeHandles;
using System;
using System.Runtime.InteropServices;

namespace Gucu112.Powershell.Utility.Win32
{
    public static class User
    {
        [DllImport("user32.dll", SetLastError = true)]
        public static extern IntPtr GetShellWindow();

        [DllImport("user32.dll", SetLastError = true)]
        public static extern uint GetWindowThreadProcessId(
            SafeProcessHandle windowHandle,
            out uint processId
        );
    }
}
