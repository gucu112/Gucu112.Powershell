$FileFoundExceptionClass = @'
namespace System.IO {
    public class FileFoundException : IOException
    {
        public FileFoundException() : base() {}
        public FileFoundException(string message) : base(message) {}
        public FileFoundException(string message, Exception innerException) : base(message, innerException) {}
    }
}
'@

Write-Verbose 'Adding "System.IO.FileFoundException" type.'
Add-Type -TypeDefinition $FileFoundExceptionClass -Language CSharp

$DirectoryFoundExceptionClass = @'
namespace System.IO {
    public class DirectoryFoundException : IOException
    {
        public DirectoryFoundException() : base() {}
        public DirectoryFoundException(string message) : base(message) {}
        public DirectoryFoundException(string message, Exception innerException) : base(message, innerException) {}
    }
}
'@

Write-Verbose 'Adding "System.IO.DirectoryFoundException" type.'
Add-Type -TypeDefinition $DirectoryFoundExceptionClass -Language CSharp
