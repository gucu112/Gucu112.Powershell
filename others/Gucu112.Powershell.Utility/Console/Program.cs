using Gucu112.Powershell.Utility.Windows;

Console.WriteLine("GetSystem()");
var systemProcess = Process.GetSystem();
Console.WriteLine($"System Process: {systemProcess?.Id} - {systemProcess?.ProcessName}");

// REMARK: Can't take the token of the system process directly due to access restrictions
//var systemToken = new Token(systemProcess);
//var systemIdentity = systemToken.GetWindowsIdentity();
//Console.WriteLine($"System Identity: {systemIdentity?.Name} - {systemIdentity?.User} - {systemIdentity?.AuthenticationType}");

Console.WriteLine("GetExplorer()");
var explorerProcess = Process.GetExplorer();
Console.WriteLine($"Explorer Process: {explorerProcess?.Id} - {explorerProcess?.ProcessName}");
var explorerToken = new Token(explorerProcess);
var explorerIdentity = explorerToken.GetWindowsIdentity();
Console.WriteLine($"Explorer Identity: {explorerIdentity?.Name} - {explorerIdentity?.User} - {explorerIdentity?.AuthenticationType}");

Console.WriteLine("GetCurrent()");
var currentProcess = Process.GetCurrent();
Console.WriteLine($"Current Process: {currentProcess?.Id} - {currentProcess?.ProcessName}");
var currentToken = new Token(currentProcess);
var currentIdentity = currentToken.GetWindowsIdentity();
Console.WriteLine($"Current Identity: {currentIdentity?.Name} - {currentIdentity?.User} - {currentIdentity?.AuthenticationType}");
