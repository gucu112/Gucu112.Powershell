using Microsoft.Win32.SafeHandles;
using System;
using System.Runtime.ConstrainedExecution;
using System.Security.Principal;

namespace Gucu112.Powershell.Utility.Win32
{
    public class SafeIdentityHandle : SafeHandleZeroOrMinusOneIsInvalid
    {
        public SafeIdentityHandle(bool ownHandle = true) : base(ownHandle)
        {
        }

        public SafeIdentityHandle(IntPtr handle, bool ownHandle = true) : base(ownHandle)
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
