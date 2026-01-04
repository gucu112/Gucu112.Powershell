using Gucu112.Powershell.Utility.Win32;
using Microsoft.Win32.SafeHandles;
using System;
using System.ComponentModel;
using System.Runtime.InteropServices;
using System.Security.Principal;
using static Gucu112.Powershell.Utility.Win32.AdvancedApi;
using static Gucu112.Powershell.Utility.Win32.Kernel;
using WindowsProcess = System.Diagnostics.Process;

namespace Gucu112.Powershell.Utility.Windows
{
    public class Token : IDisposable
    {
        #region Private constants
        private readonly int LOGON32_ERROR_LOGON_FAILURE = 1326;
        private readonly bool isTokenCloned = false;
        #endregion

        #region Private fields
        private SafeHandle processHandle;
        private SafeIdentityHandle referenceTokenHandle;
        private SafeIdentityHandle duplicateTokenHandle;
        #endregion

        #region Public methods
        public Token(SafeHandle processHandle, bool cloneToken = true)
        {
            this.processHandle = processHandle;
            GetToken();
            if (cloneToken)
            {
                isTokenCloned = true;
                CloneToken();
            }
        }

        public Token(WindowsProcess process) : this(new SafeIdentityHandle(process.Handle), true)
        {
        }

        public WindowsIdentity GetWindowsIdentity()
        {
            if (isTokenCloned)
            {
                return duplicateTokenHandle.GetWindowsIdentity();
            }
            return referenceTokenHandle.GetWindowsIdentity();
        }

        public Token GetToken(
            string username,
            string domain,
            string password,
            LogonType logonType = LogonType.LOGON32_LOGON_INTERACTIVE,
            LogonProvider logonProvider = LogonProvider.LOGON32_PROVIDER_DEFAULT
        )
        {
            var status = LogonUser(username, domain, password, logonType, logonProvider, out referenceTokenHandle);
            var returnCode = Marshal.GetLastWin32Error();

            if (returnCode == LOGON32_ERROR_LOGON_FAILURE)
            {
                status = false;
                // TODO: Check if it is still needed
                // logonType = AdvApi.LogonType.LOGON32_LOGON_NEW_CREDENTIALS;
            }

            // TODO: Check if it is still needed
            if (returnCode != 0)
            {
                status = LogonUser(username, domain, password, logonType, logonProvider, out referenceTokenHandle);
                returnCode = Marshal.GetLastWin32Error();
            }

            if (status == false)
            {
                throw new Win32Exception(returnCode, "User login failed.");
            }

            return this;
        }

        public Token GetToken(
            TokenAccess tokenAccess = TokenAccess.TOKEN_MIN_ACCESS
        )
        {
            if (!OpenProcessToken(processHandle, tokenAccess, out IntPtr referenceTokenHandlePtr))
            {
                throw new Win32Exception(Marshal.GetLastWin32Error(), "Cannot open process token.");
            }

            referenceTokenHandle = new SafeIdentityHandle(referenceTokenHandlePtr);
            return this;
        }

        public Token GetToken(
            uint processId,
            ProcessAccess processAccess = ProcessAccess.QueryInformation,
            TokenAccess tokenAccess = TokenAccess.TOKEN_MIN_ACCESS,
            bool inheritHandle = true
        )
        {
            using (SafeProcessHandle processHandle = OpenProcess(processAccess, inheritHandle, processId))
            {
                if (processHandle.IsInvalid)
                {
                    throw new Win32Exception(Marshal.GetLastWin32Error(), "Cannot open process.");
                }

                this.processHandle = processHandle;
            }

            GetToken(tokenAccess);
            return this;
        }

        public Token CloneToken(
            SecurityImpersonationLevel impersonationLevel = SecurityImpersonationLevel.SecurityImpersonation
        )
        {
            if (!DuplicateToken(referenceTokenHandle, impersonationLevel, out IntPtr duplicateTokenHandlePtr))
            {
                throw new Win32Exception(Marshal.GetLastWin32Error(), "Cannot duplicate token.");
            }

            duplicateTokenHandle = new SafeIdentityHandle(duplicateTokenHandlePtr);
            return this;
        }

        // TODO: Check if CloneTokenEx is needed for impersonation
        public Token CloneTokenEx(
            TokenAccess tokenAccess = TokenAccess.TOKEN_ALL_ACCESS,
            SecurityImpersonationLevel impersonationLevel = SecurityImpersonationLevel.SecurityImpersonation,
            TokenType tokenType = TokenType.TokenPrimary
        )
        {
            using (SafeIdentityHandle tokenAttributes = new())
            {
                if (!DuplicateTokenEx(referenceTokenHandle, tokenAccess, tokenAttributes, impersonationLevel, tokenType, out duplicateTokenHandle))
                {
                    throw new Win32Exception(Marshal.GetLastWin32Error(), "Cannot duplicate token ex.");
                }
            }

            return this;
        }

        public void Dispose()
        {
            processHandle.Dispose();
            referenceTokenHandle?.Dispose();
            duplicateTokenHandle?.Dispose();
        }
        #endregion
    }
}
