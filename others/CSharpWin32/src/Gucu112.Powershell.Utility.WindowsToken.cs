
using System;
using System.ComponentModel;
using System.Diagnostics;
using System.Runtime.InteropServices;
using System.Security.Principal;
using Gucu112.Powershell.Utility.Win32;

namespace Gucu112.Powershell.Utility
{
    public class WindowsToken : IDisposable
    {
        #region Private constants
        private int LOGON32_ERROR_LOGON_FAILURE = 1326;
        #endregion

        #region Public fields
        private Win32.SafeHandle processHandle;
        private Win32.SafeHandle referenceTokenHandle;
        private Win32.SafeHandle duplicateTokenHandle;
        private bool isTokenCloned = false;
        #endregion

        #region Public methods
        public WindowsToken(Win32.SafeHandle processHandle, bool cloneToken = true)
        {
            this.processHandle = processHandle;
            GetToken();
            if (cloneToken) {
                isTokenCloned = true;
                CloneToken();
            }
        }

        public WindowsToken(Process process) : this(new Win32.SafeHandle(process.Handle), true)
        {
        }

        public WindowsIdentity GetWindowsIdentity()
        {
            if (isTokenCloned) {
                return duplicateTokenHandle.GetWindowsIdentity();
            }
            return referenceTokenHandle.GetWindowsIdentity();
        }

        public WindowsToken GetToken(
            string username,
            string domain,
            string password,
            AdvApi.LogonType logonType = AdvApi.LogonType.LOGON32_LOGON_INTERACTIVE,
            AdvApi.LogonProvider logonProvider = AdvApi.LogonProvider.LOGON32_PROVIDER_DEFAULT
        )
        {
            bool status = false;
            int returnCode = -1;

            status = AdvApi.LogonUser(username, domain, password, logonType, logonProvider, out referenceTokenHandle);
            returnCode = Marshal.GetLastWin32Error();

            if (returnCode == LOGON32_ERROR_LOGON_FAILURE) {
                status = false;
                // TODO: Check if it is still needed
                // logonType = AdvApi.LogonType.LOGON32_LOGON_NEW_CREDENTIALS;
            }

            // TODO: Check if it is still needed
            if (returnCode != 0) {
                status = AdvApi.LogonUser(username, domain, password, logonType, logonProvider, out referenceTokenHandle);
                returnCode = Marshal.GetLastWin32Error();
            }

            if (status == false) {
                throw new Win32Exception(returnCode, "User login failed.");
            }

            return this;
        }

        public WindowsToken GetToken(
            AdvApi.TokenAccess tokenAccess = AdvApi.TokenAccess.TOKEN_MIN_ACCESS
        )
        {
            if (!AdvApi.OpenProcessToken(processHandle, tokenAccess, out referenceTokenHandle))
            {
                throw new Win32Exception(Marshal.GetLastWin32Error(), "Cannot open process token.");
            }

            return this;
        }

        public WindowsToken GetToken(
            uint processId,
            Kernel.ProcessAccess processAccess = Kernel.ProcessAccess.QueryInformation,
            AdvApi.TokenAccess tokenAccess = AdvApi.TokenAccess.TOKEN_MIN_ACCESS,
            bool inheritHandle = true
        )
        {
            using (Win32.SafeHandle processHandle = Kernel.OpenProcess(processAccess, inheritHandle, processId)) {
                if (processHandle.IsInvalid)
                {
                    throw new Win32Exception(Marshal.GetLastWin32Error(), "Cannot open process.");
                }

                this.processHandle = processHandle;
            }

            GetToken(tokenAccess);
            return this;
        }

        public WindowsToken CloneToken(
            AdvApi.SecurityImpersonationLevel impersonationLevel = AdvApi.SecurityImpersonationLevel.SecurityImpersonation
        )
        {
            if (!AdvApi.DuplicateToken(referenceTokenHandle, impersonationLevel, out duplicateTokenHandle))
            {
                throw new Win32Exception(Marshal.GetLastWin32Error(), "Cannot duplicate token.");
            }

            return this;
        }

        // TODO: Check if CloneTokenEx is needed for impersonation
        public WindowsToken CloneTokenEx(
            AdvApi.TokenAccess tokenAccess = AdvApi.TokenAccess.TOKEN_ALL_ACCESS,
            AdvApi.SecurityImpersonationLevel impersonationLevel = AdvApi.SecurityImpersonationLevel.SecurityImpersonation,
            AdvApi.TokenType tokenType = AdvApi.TokenType.TokenPrimary
        )
        {
            using (Win32.SafeHandle tokenAttributes = new Win32.SafeHandle(IntPtr.Zero)) {
                if (!AdvApi.DuplicateTokenEx(referenceTokenHandle, tokenAccess, tokenAttributes, impersonationLevel, tokenType, out duplicateTokenHandle))
                {
                    throw new Win32Exception(Marshal.GetLastWin32Error(), "Cannot duplicate token ex.");
                }
            }

            return this;
        }

        public void Dispose()
        {
            processHandle.Dispose();
            referenceTokenHandle.Dispose();
            duplicateTokenHandle.Dispose();
        }
        #endregion
    }

}
