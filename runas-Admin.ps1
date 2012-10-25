<#
.synopsis
    Checks if script is being invoked by an administrator, in an elevated shell.
If the shell is elevated (and the user has rights), the command will be invoked,
otherwise, the command will be passed to a new, elevated session of powershell.

.description
    Originally created to load the boxStarter module (see related links), 
repurposed to gracefully attempt to run any script passed to it with elevated 
rights. Will check if the 'isModule' switch is passed, if so, will use 
'import-module', otherwise standarnd
    
    name
        runAs-Admin.ps1
    created
        2012-oct-12
    modified
        2012-oct-12
    version
        1.0
    author
        Matt Wrock (original work)
        Jim Schell (derivative work)
.link
    http://boxstarter.codeplex.com/
.link
    http://www.mattwrock.com/
#>

Param(
	[Parameter(Position=0)]
	[String]$scriptToElevate,
	
	[Switch]$isModule
)

$scriptPath = (Split-Path -parent $MyInvocation.MyCommand.path)
$identity  = [System.Security.Principal.WindowsIdentity]::GetCurrent()
$principal = New-Object System.Security.Principal.WindowsPrincipal( $identity )
$isAdmin = $principal.IsInRole( [System.Security.Principal.WindowsBuiltInRole]::Administrator )

if($isModule)
{
    $command = "Import-Module `"$scriptPath\$scriptToElevate`""
}
else
{
    $commmand = "$scriptPath\$scriptToElevate" 
        # need to add spot for arguments being passed?
}


if($isAdmin) 
{  
    Invoke-Expression $command
}
else 
{
    $command = "-ExecutionPolicy bypass -noexit -command " + $command
    Start-Process powershell -verb runas -argumentlist $command
}
