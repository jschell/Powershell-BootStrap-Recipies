<#
.synopsis
    Checks if script is being invoked by an administrator, in an elevated shell.
If the shell is elevated (and the user has rights), the command will be invoked,
otherwise, the command will be passed to a new, elevated session of powershell.

.description
    Originally created to load the boxStarter module (see related links), could
be repurposed to gracefully attempt to run any script passed to it with elevated 
rights.
    
    
    created
        2012-apr-01
    modified
        2012-oct-12
    version
        
    author
        Matt Wrock    
.link
    http://boxstarter.codeplex.com/
.link
    http://www.mattwrock.com/
#>

$scriptPath = (Split-Path -parent $MyInvocation.MyCommand.path)
$identity  = [System.Security.Principal.WindowsIdentity]::GetCurrent()
$principal = New-Object System.Security.Principal.WindowsPrincipal( $identity )
$isAdmin = $principal.IsInRole( [System.Security.Principal.WindowsBuiltInRole]::Administrator )
$command = "Import-Module `"$scriptPath\BoxStarter.psm1`";Invoke-BoxStarter $args"
if($isAdmin) {  
  Invoke-Expression $command
}
else {
  $command = "-ExecutionPolicy bypass -noexit -command " + $command
  Start-Process powershell -verb runas -argumentlist $command
}
