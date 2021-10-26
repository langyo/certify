﻿# Posh-ACME Wrapper script to allow direct use of DNS Plugins

# $PoshACMERoot = "\Posh-ACME"
$Public  = @( Get-ChildItem -Path $PoshACMERoot\Public\*.ps1 -ErrorAction Ignore )
$Private = @( Get-ChildItem -Path $PoshACMERoot\Private\*.ps1 -ErrorAction Ignore )

# Load Assembly without using Add-Type to avoid locking assembly dll
$assemblyBytes = [System.IO.File]::ReadAllBytes("$($PoshACMERoot)\..\..\..\BouncyCastle.Crypto.dll")
[System.Reflection.Assembly]::Load($assemblyBytes) | out-null

# Dot source the files (in the same manner as Posh-ACME would)
Foreach($import in @($Public + $Private))
{
    Try { . $import.fullname }
    Catch
    {
        Write-Error -Message "Failed to import function $($import.fullname): $_"
    }
}

# Replace Posh-ACME specific methods which don't apply when we're using them
function Export-PluginVar { param([Parameter(ValueFromRemainingArguments)]$DumpArgs) }
function Import-PluginVar { param([Parameter(ValueFromRemainingArguments)]$DumpArgs) }

$script:UseBasic = @{} 
if ('UseBasicParsing' -in (Get-Command Invoke-WebRequest).Parameters.Keys) {  $script:UseBasic.UseBasicParsing = $true } 