#######################################################
##
## Wake.ps1, v1.0, 2013
##
## Adapted by Ammaar Limbada
## Original Author: Matthijs ten Seldam, Microsoft (see: http://blogs.technet.com/matthts)
##
#######################################################
 
<#
.SYNOPSIS
Starts a list of physical machines by using Wake On LAN.
 
.DESCRIPTION
Wake sends a Wake On LAN magic packet to a given machine's MAC address.
 
.PARAMETER MacAddress
MacAddress of target machine to wake.
hp_pavillion .\wol.ps1 aabbccddeeff
 
.EXAMPLE
Wake A0DEF169BE02
 
.INPUTS
None
 
.OUTPUTS
None
 
.NOTES
Make sure the MAC addresses supplied don't contain "-" or ".".
#>
 
 
param( [Parameter(Mandatory=$true, HelpMessage="MAC address of target machine to wake up")]
       [string] $MacAddress )
 
 
Set-StrictMode -Version Latest
 
function Send-Packet([string]$MacAddress)
{
    <#
    .SYNOPSIS
    Sends a number of magic packets using UDP broadcast.
 
    .DESCRIPTION
    Send-Packet sends a specified number of magic packets to a MAC address in order to wake up the machine.  
 
    .PARAMETER MacAddress
    The MAC address of the machine to wake up.
    #>
 
    try
    {
        $Broadcast = ([System.Net.IPAddress]::Broadcast)
 
        ## Create UDP client instance
        $UdpClient = New-Object Net.Sockets.UdpClient
 
        ## Create IP endpoints for each port
        $IPEndPoint = New-Object Net.IPEndPoint $Broadcast, 9
 
        ## Construct physical address instance for the MAC address of the machine (string to byte array)
        $MAC = [Net.NetworkInformation.PhysicalAddress]::Parse($MacAddress.ToUpper())
 
        ## Construct the Magic Packet frame
        $Packet =  [Byte[]](,0xFF*6)+($MAC.GetAddressBytes()*16)
 
        ## Broadcast UDP packets to the IP endpoint of the machine
        $UdpClient.Send($Packet, $Packet.Length, $IPEndPoint) | Out-Null
        $UdpClient.Close()
    }
    catch
    {
        $UdpClient.Dispose()
        $Error | Write-Error;
    }
}

## Send magic packet to wake machine
Write "Sending magic packet to $MacAddress"
Send-Packet $MacAddress