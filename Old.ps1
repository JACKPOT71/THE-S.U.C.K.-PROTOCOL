#====================================================================================
#                          THE S.U.C.K. PROTOCOL
#                  A FortKnight's Legacy by JACKPOT_ZB
#
#       Founder of SUC(K) - Secret Unlocked Circle of FortKnight's
#                Find us on Discord: https://discord.gg/xtgBxkpc2x
#====================================================================================

# --- INITIAL SETUP & ADMIN CHECK ---
Clear-Host
$ErrorActionPreference = "Continue"
$Host.UI.RawUI.WindowTitle = "The S.U.C.K. Protocol - A FortKnight's Legacy"

if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "FEHLER: Administratorrechte sind erforderlich!" -ForegroundColor Red
    Write-Host "Bitte rechtsklicken Sie auf die PowerShell und wählen Sie 'Als Administrator ausführen'." -ForegroundColor Yellow
    Read-Host "Drücken Sie ENTER, um das Fenster zu schließen."
    exit
}

# --- SCRIPT FUNCTIONS ---
function Write-ColorText($Text, $ForegroundColor) {
    Write-Host $Text -ForegroundColor $ForegroundColor
}

function Write-Header($Title) {
    $boxWidth = 67
    $fullLine = '═' * $boxWidth
    $padding = [math]::Floor(($boxWidth - $Title.Length - 2) / 2)
    $paddedTitle = (' ' * $padding) + $Title.ToUpper()

    Write-Host ""
    Write-Host "╔$fullLine╗" -ForegroundColor Yellow
    Write-Host "║$($paddedTitle.PadRight($boxWidth))║" -ForegroundColor Yellow
    Write-Host "╚$fullLine╝" -ForegroundColor Yellow
    Write-Host ""
}

function Write-Hacker($Text, $Color = "Yellow") {
    $Text.ToCharArray() | ForEach-Object {
        Write-Host -NoNewline $_ -ForegroundColor $Color
        Start-Sleep -Milliseconds 5
    }
    Write-Host ""
}

# NEW: A faster version of the hacker effect for the final summary.
function Write-Hacker-Fast($Text, $Color) {
    $Text.ToCharArray() | ForEach-Object {
        Write-Host -NoNewline $_ -ForegroundColor $Color
        Start-Sleep -Milliseconds 1
    }
    Write-Host ""
}

function Set-RegistryProperties($Path, [hashtable]$Properties) {
    if (-not (Test-Path $Path)) {
        try { New-Item -Path $Path -Force | Out-Null } catch {}
    }
    foreach ($prop in $Properties.GetEnumerator()) {
        try {
            $Type = if ($prop.Value -is [int]) { "DWord" } else { "String" }
            Set-ItemProperty -Path $Path -Name $prop.Key -Value $prop.Value -Type $Type -ErrorAction Stop -Force
        } catch {
            Write-ColorText "       - Warnung: Konnte Eigenschaft $($prop.Key) nicht setzen." "Yellow"
        }
    }
}

# --- WELCOME & WARNING ---
Clear-Host
Write-Header "The S.U.C.K. Protocol"
Write-Hacker -Text "This advanced tool will comprehensively optimize your network settings for"
Write-Hacker -Text "ultra-low ping, great Jitter and a fair Hitreg especially for gaming."
Write-Host ""
Write-Hacker -Text "Features include:"
Write-Hacker -Text "- MTU optimization with automatic detection"
Write-Hacker -Text "- Advanced TCP/IP stack optimization"
Write-Hacker -Text "- Complete hardware offload configuration"
Write-Hacker -Text "- NIC interrupt configuration (Line Based, Core 1, High Priority)"
Write-Hacker -Text "- Realtek driver specific optimizations"
Write-Hacker -Text "- Power management optimizations"
Write-Hacker -Text "- Registry-based performance tweaks"
Write-Hacker -Text "- Persistent CLKREQ Disable Task"
Write-Host ""
$warningText = "IMPORTANT WARNING"
$padding = [math]::Floor((67 - $warningText.Length) / 2)
$paddedWarningText = (' ' * $padding) + $warningText
Write-Host "╔═══════════════════════════════════════════════════════════════════╗" -ForegroundColor Red
Write-Host "║$($paddedWarningText.PadRight(67))║" -ForegroundColor Red
Write-Host "╚═══════════════════════════════════════════════════════════════════╝" -ForegroundColor Red
Write-Host ""
Write-Hacker -Text "Before the whining starts again:"
Write-Hacker -Text "This script is exclusively for Realtek adapters on desktop PCs."
Write-Hacker -Text "It is not for laptops, Wi-Fi, or Texas Instruments handhelds."
Write-Hacker -Text "It is for modern fast Ethernet conections and not for a Acoustic coupler"
Write-Host ""
Write-Hacker -Text "Don't come crying to me if you run it on your Intel Atom 1.0 GHz notebook"
Write-Hacker -Text "against all advice and everything breaks."
Write-Host ""
$promptText = "Press ENTER to continue, or CTRL+C to abort."
$padding = [math]::Floor((67 - $promptText.Length) / 2)
$paddedPromptText = (' ' * $padding) + $promptText
Write-Host "╔═══════════════════════════════════════════════════════════════════╗" -ForegroundColor Yellow
Write-Host "║$($paddedPromptText.PadRight(67))║" -ForegroundColor Yellow
Write-Host "╚═══════════════════════════════════════════════════════════════════╝" -ForegroundColor Yellow
Read-Host | Out-Null

# --- START OPTIMIZATION ---
Clear-Host
Write-Header "RUTHLESS NETWORK OPTIMIZATION"

Write-Host "✓ Administrator privileges confirmed - Starting script..." -ForegroundColor Green
Start-Sleep -Seconds 1

# --- [1/14] NIC INTERRUPT CONFIGURATION ---
Write-Host "`n[1/14] Configuring NIC interrupt settings..." -ForegroundColor Yellow
$netAdapters = Get-PnpDevice -Class Net -Status OK | Where-Object { $_.InstanceId -notlike "*ROOT\*" -and $_.InstanceId -notlike "*SW\*" -and $_.FriendlyName -notlike "*Virtual*" -and $_.FriendlyName -notlike "*Loopback*" }
if ($netAdapters) {
    Write-ColorText "       - Found network adapters:" "Cyan"
    $netAdapters | ForEach-Object { Write-ColorText "         • $($_.FriendlyName)" "White" }
    foreach ($adapter in $netAdapters) {
        $regPath = "HKLM:\SYSTEM\CurrentControlSet\Enum\$($adapter.InstanceId)\Device Parameters"
        $msiPath = "$regPath\Interrupt Management\MessageSignaledInterruptProperties"
        $affinityPath = "$regPath\Interrupt Management\Affinity Policy"
        $maskBytes = [byte[]]@(0x02,0x00,0x00,0x00,0x00,0x00,0x00,0x00) # Core 1
        
        if (-not (Test-Path $msiPath)) { New-Item -Path $msiPath -Force | Out-Null }
        Set-ItemProperty -Path $msiPath -Name "MSISupported" -Value 0 -Type DWord -Force
        
        if (-not (Test-Path $affinityPath)) { New-Item -Path $affinityPath -Force | Out-Null }
        Set-ItemProperty -Path $affinityPath -Name "AssignmentSetOverride" -Value $maskBytes -Type Binary -Force
        Set-ItemProperty -Path $affinityPath -Name "DevicePolicy" -Value 4 -Type DWord -Force
        Set-ItemProperty -Path $affinityPath -Name "DevicePriority" -Value 3 -Type DWord -Force
        
        Write-ColorText "       - ✓ Interrupts configured for: $($adapter.FriendlyName)" "Green"
    }
} else {
    Write-ColorText "       - No physical network adapters found." "Yellow"
}

# --- [2/14] ADVANCED NETSH COMMANDS ---
Write-Host "`n[2/14] Applying advanced NETSH commands..." -ForegroundColor Yellow
$netshBaseCommands = @(
    "int ipv6 set gl loopbacklargemtu=disable", "int ipv4 set gl loopbacklargemtu=disable", "int isatap set state disable", 
    "interface teredo set state servername=default", "int ip set global sourceroutingbehavior=drop", 
    "int ip set global neighborcachelimit=4096", "int tcp set security mpp=disabled", 
    "int tcp set security profiles=disabled", "int tcp set global rsc=disabled"
)
$netshBaseCommands | ForEach-Object { netsh $_ 2>&1 | Out-Null }
Write-ColorText "       - ✓ NETSH base commands applied" "Green"

# --- [3/14] NDIS PARAMETERS CONFIGURATION ---
Write-Host "`n[3/14] Configuring NDIS parameters..." -ForegroundColor Yellow
$ndisProperties = @{
    "MaxCachedNblContextSize" = 0x400; "PortAuthReceiveAuthorizationState" = 0; "PortAuthReceiveControlState" = 0;
    "PortAuthSendAuthorizationState" = 0; "PortAuthSendControlState" = 0; "ReceiveWorkerDisableAutoStart" = 0;
    "TrackNblOwner" = 0; "AllowWakeFromS5" = 0; "DefaultPnPCapabilities" = 0; "ReceiveWorkerThreadPriority" = 8;
    "RssBaseCpu" = 3; "DebugLoggingMode" = 0; "DisableNaps" = 1; "DisableNDISWatchDog" = 1;
    "DisableReenumerationTimeoutBugcheck" = 1; "EnableNicAutoPowerSaverInSleepStudy" = 0; "DefaultLoggingLevel" = 0;
    "DefaultUdpEncapsulationOffloadBehavior" = 1; "DisableDHCPMediaSense" = 1; "DisableDHCPv6Relay" = 1;
    "DisableMediaSenseEventLog" = 1; "DisableRscChecksum" = 1; "EnableNDPTethering" = 0; "IPAutoconfigurationEnabled" = 0x400;
    "PortAuthMultiTenant" = 2; "PortAuthRemediation" = 2; "PortAuthSysProfile" = 2; "TrackNDKOwner" = 2
}
Set-RegistryProperties "HKLM:\SYSTEM\CurrentControlSet\Services\NDIS\Parameters" $ndisProperties
Write-ColorText "       - ✓ NDIS parameters optimized" "Green"

# --- [4/14] NETBT SETTINGS ---
Write-Host "`n[4/14] Configuring NetBT settings..." -ForegroundColor Yellow
Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Services\NetBT\Parameters" -Name "EnableLMHOSTS" -Value 0 -Type DWord -Force
Get-ChildItem "HKLM:\SYSTEM\CurrentControlSet\Services\NetBT\Parameters\Interfaces" | ForEach-Object {
    Set-ItemProperty -Path $_.PSPath -Name "NetbiosOptions" -Value 2 -Type DWord -Force
}
Write-ColorText "       - ✓ NetBT settings configured (includes disabling NetBIOS over TCP/IP)" "Green"

# --- [5/14] MTU & INTERFACE METRIC OPTIMIZATION ---
Write-Host "`n[5/14] Advanced Interface optimization..." -ForegroundColor Yellow
$connectedInterfaces = Get-NetAdapter | Where-Object Status -eq "Up"
$mtu = 1500
$testHost = "1.1.1.1"
Write-ColorText "       - Testing optimal MTU size against $testHost" "Cyan"
for ($payload = 1472; $payload -ge 1400; $payload -= 2) {
    ping.exe $testHost -f -n 1 -l $payload -w 500 | Out-Null
    if ($LASTEXITCODE -eq 0) {
        $mtu = $payload + 28; break
    }
}
if ($mtu -ge 1492) { $mtu = 1500 }
foreach ($interface in $connectedInterfaces) {
    netsh interface ipv4 set subinterface "$($interface.Name)" mtu=$mtu store=persistent | Out-Null
    Write-ColorText "       - ✓ MTU for $($interface.Name) set to $mtu" "Green"
    Set-NetIPInterface -InterfaceAlias $interface.Name -AutomaticMetric Disabled -InterfaceMetric 1
    Write-ColorText "       - ✓ InterfaceMetric for $($interface.Name) set to 1" "Green"
}

# --- [6/14] ADVANCED TCP/IP PARAMETERS ---
Write-Host "`n[6/14] Optimizing TCP/IP global parameters..." -ForegroundColor Yellow
$tcpipProperties = @{
    "EnablePMTUDiscovery" = 1; "TcpAckFrequency" = 1; "TcpDelAckTicks" = 0; "TCPNoDelay" = 1;
    "MaxUserPort" = 0xFFFE; "FastSendDatagramThreshold" = 0x5DC; "FastCopyReceiveThreshold" = 0x5DC;
    "UseDomainNameDevolution" = 1; "DeadGWDetectDefault" = 1; "DontAddDefaultGatewayDefault" = 0;
    "InitialCongestionWindow" = 10; "UdpNoDelay" = 1; "EnableIPAutoConfigurationLimits" = 0xFF;
    "IPEnableRouter" = 0; "EnableICMPRedirect" = 1; "DisableTaskOffload" = 0; "Tcp1323Opts" = 0;
    "DefaultTTL" = 0x40; "TcpMaxDataRetransmissions" = 1; "TcpTimedWaitDelay" = 30;
    "UDPMaxSockets" = 0xFFFF; "UDPReceiveBufferSize" = 0x40000; "UDPSendBufferSize" = 0x40000
}
Set-RegistryProperties "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" $tcpipProperties
Get-ChildItem "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" | ForEach-Object {
    Set-RegistryProperties $_.PSPath @{"TcpAckFrequency" = 1; "TcpDelAckTicks" = 0; "TCPNoDelay" = 1}
}
Write-ColorText "       - ✓ TCP/IP global parameters optimized" "Green"

# --- [7/14] WINSOCK PARAMETERS ---
Write-Host "`n[7/14] Configuring Winsock parameters..." -ForegroundColor Yellow
Set-RegistryProperties "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Winsock" @{"UseDelayedAcceptance" = 0; "MaxSockAddrLength" = 16; "MinSockAddrLength" = 16}
Write-ColorText "       - ✓ Winsock parameters configured" "Green"

# --- [8/14] ADVANCED AFD PARAMETERS ---
Write-Host "`n[8/14] Optimizing AFD parameters..." -ForegroundColor Yellow
$afdProperties = @{
    "FastSendDatagramThreshold" = 0x3E8; "FastCopyReceiveThreshold" = 0x3E8; "DynamicSendBufferDisable" = 1;
    "MinimumDynamicBacklog" = 32; "MaximumDynamicBacklog" = 4096; "UDPMaxSockets" = 0xFFFF;
    "UDPReceiveBufferSize" = 0x400; "UDPSendBufferSize" = 0x400; "AfdDoNotHoldNICBuffers" = 1;
    "MaxActiveTransmitFileCount" = 0; "MaxFastCopyTransmit" = 0x1000; "MaxFastTransmit" = 0x10000;
    "PriorityBoost" = 8; "DoNotHoldNICBuffers" = 1; "TransmitWorker" = 32; "DefaultReceiveWindow" = 512;
    "DefaultSendWindow" = 512; "DisableAddressSharing" = 1; "LargeBufferSize" = 0x2000; "IRPStackSize" = 20;
    "DisableRawSecurity" = 1; "DisableDirectAcceptEx" = 1; "DisableChainedReceive" = 1; "EnableDynamicBacklog" = 0;
    "DynamicBacklogGrowthDelta" = 0; "BufferMultiplier" = 0x400; "IgnorePushBitOnReceives" = 1;
    "LargeBufferListDepth" = 16; "MediumBufferSize" = 0x5DC; "MediumBufferListDepth" = 24;
    "OverheadChargeGranularity" = 0x1000; "SmallBufferSize" = 0x80; "SmallBufferListDepth" = 32;
    "StandardAddressLength" = 22; "TransmitIoLength" = 0x10000
}
Set-RegistryProperties "HKLM:\SYSTEM\CurrentControlSet\Services\AFD\Parameters" $afdProperties
Write-ColorText "       - ✓ AFD parameters optimized" "Green"

# --- [9/14] PRIORITY CONTROL SETTINGS ---
Write-Host "`n[9/14] Configuring system priority control..." -ForegroundColor Yellow
Set-RegistryProperties "HKLM:\SYSTEM\CurrentControlSet\Control\PriorityControl" @{"ConvertibleSlateMode" = 0; "Win32PrioritySeparation" = 0x18; "IRQ16Priority" = 1}
Write-ColorText "       - ✓ System priority control optimized" "Green"

# --- [10/14] NETWORK ADAPTER POWER MANAGEMENT ---
Write-Host "`n[10/14] Disabling power management features..." -ForegroundColor Yellow
$powerProperties = @{
    "EnablePME" = "0"; "*DeviceSleepOnDisconnect" = "0"; "*EEE" = "0"; "*ModernStandbyWoLMagicPacket" = "0";
    "*SelectiveSuspend" = "0"; "*WakeOnMagicPacket" = "0"; "*WakeOnPattern" = "0"; "AutoPowerSaveModeEnabled" = "0";
    "EEELinkAdvertisement" = "0"; "EeePhyEnable" = "0"; "EnableGreenEthernet" = "0"; "EnableModernStandby" = "0";
    "GigaLite" = "0"; "PowerDownPll" = "0"; "PowerSavingMode" = "0"; "ReduceSpeedOnPowerDown" = "0";
    "S5WakeOnLan" = "0"; "SavePowerNowEnabled" = "0"; "ULPMode" = "0"; "WakeOnLink" = "0"; "WakeOnSlot" = "0";
    "WakeUpModeCap" = "0"; "WaitAutoNegComplete" = "0"; "*FlowControl" = "0"; "WolShutdownLinkSpeed" = "2";
    "WakeOnMagicPacketFromS5" = "0"; "*PMNSOffload" = "0"; "*PMARPOffload" = "0"; "*NicAutoPowerSaver" = "0";
    "*PMWiFiRekeyOffload" = "0"; "EnablePowerManagement" = "0"; "ForceWakeFromMagicPacketOnModernStandby" = "0";
    "WakeFromS5" = "0"; "WakeOn" = "0"; "OBFFEnabled" = "0"; "DMACoalescing" = "0"; "EnableSavePowerNow" = "0";
    "EnableD0PHYFlexibleSpeed" = "0"
}
Get-ChildItem "HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}" -ErrorAction SilentlyContinue | ForEach-Object {
    Set-ItemProperty -Path $_.PSPath -Name "PnPCapabilities" -Value 24 -Type DWord -Force
    Set-RegistryProperties $_.PSPath $powerProperties
}
Write-ColorText "       - ✓ Power management disabled for all adapters" "Green"

# --- [11/14] REALTEK SPECIFIC OPTIMIZATIONS ---
Write-Host "`n[11/14] Applying Realtek-specific optimizations..." -ForegroundColor Yellow
$realtek0001Path = "HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0001"
$realtek0000Path = "HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0000"
$realtek0001Settings = @{
    "EnableUPS" = 0; "DisablePwrSavingOnRST" = 1; "EnableExtraPowerSaving" = 0; "EnableD3Cold" = 0;
    "EnableD3ColdInterface" = 0; "EnableOOBSelectiveSuspend" = 0; "ALDPS" = 0; "EnablePowerCut" = 0; "*PacketDirect" = 1; "CLKREQ" = 0
}
$realtek0000Settings = @{
    "*SpeedDuplex" = "6"; "*FlowControl" = "0"; "*InterruptModeration" = "0"; "*IPChecksumOffloadIPv4" = "0";
    "*TCPChecksumOffloadIPv4" = "0"; "*UDPChecksumOffloadIPv4" = "0"; "*TCPChecksumOffloadIPv6" = "0";
    "*UDPChecksumOffloadIPv6" = "0"; "*LsoV2IPv4" = "0"; "*LsoV2IPv6" = "0"; "*JumboPacket" = "1514";
    "*ReceiveBuffers" = "1024"; "*TransmitBuffers" = "512"; "*RSS" = "0"; "*NumRssQueues" = "1";
    "*DeviceSleepOnDisconnect" = "0"; "*NicAutoPowerSaver" = "0"; "EnablePowerManagement" = "0"; "*EEE" = "0";
    "ULPMode" = "0"; "PowerSavingMode" = "0"; "*WakeOnPattern" = "0"; "*WakeOnMagicPacket" = "0";
    "S5WakeOnLan" = "0"; "WakeFromS5" = "0"; "*PMARPOffload" = "0"; "*PMNSOffload" = "0";
    "*EncapsulatedPacketTaskOffloadNvgre" = "0"; "*EncapsulatedPacketTaskOffloadVxlan" = "0";
    "*IPsecOffloadV1IPv4" = "0"; "*IPsecOffloadV2IPv4" = "0"; "*UsoIPv4" = "0"; "*UsoIPv6" = "0"; "*PacketDirect" = 1; "CLKREQ" = 0
}
if (Test-Path $realtek0001Path) { Set-RegistryProperties $realtek0001Path $realtek0001Settings; Write-ColorText "       - ✓ Realtek 0001 settings applied" "Green" }
if (Test-Path $realtek0000Path) { Set-RegistryProperties $realtek0000Path $realtek0000Settings; Write-ColorText "       - ✓ Realtek 0000 settings applied" "Green" }

# --- [12/14] ADVANCED OFFLOADING CONFIGURATION ---
Write-Host "`n[12/14] Configuring hardware offloading..." -ForegroundColor Yellow
netsh int tcp set global chimney=disabled | Out-Null
Get-NetAdapter | ForEach-Object { Disable-NetAdapterRss -Name $_.Name -ErrorAction SilentlyContinue | Out-Null }
netsh int tcp set global rsc=disabled | Out-Null
netsh interface udp set global uro=disabled | Out-Null
netsh interface udp set global uso=disabled | Out-Null
Write-ColorText "       - ✓ Hardware offloading disabled" "Green"

# --- [13/14] FINAL TCP/IP STACK OPTIMIZATION ---
Write-Host "`n[13/14] Final TCP/IP stack optimization..." -ForegroundColor Yellow
$congestionProvider = if ($isWin11) { "BBR2" } else { "dctcp" }
"Internet", "Datacenter", "Compat", "DatacenterCustom", "InternetCustom" | ForEach-Object {
    netsh int tcp set supplemental Template=$_ CongestionProvider=$congestionProvider 2>&1 | Out-Null
}
"6to4", "isatap", "teredo" | ForEach-Object { netsh interface $_ set state disabled 2>&1 | Out-Null }
netsh int tcp set global autotuninglevel=disabled | Out-Null
netsh int tcp set global ecncapability=disabled | Out-Null
netsh int tcp set global timestamps=disabled | Out-Null
netsh int tcp set global initialRto=300 | Out-Null
netsh int tcp set global rss=disabled | Out-Null
Write-ColorText "       - ✓ Final TCP settings applied" "Green"

# --- [14/14] PERSISTENT CLKREQ DISABLE TASK ---
Write-Host "`n[14/14] Creating persistent CLKREQ task..." -ForegroundColor Yellow
$regPath0 = "HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0000"
$regPath1 = "HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0001"
$command = "if (Test-Path '$regPath0') { Set-ItemProperty -Path '$regPath0' -Name 'CLKREQ' -Value 0 -Type DWord -Force }; if (Test-Path '$regPath1') { Set-ItemProperty -Path '$regPath1' -Name 'CLKREQ' -Value 0 -Type DWord -Force }"
$action = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument "-NoProfile -ExecutionPolicy Bypass -Command `"$command`""
$trigger = New-ScheduledTaskTrigger -AtStartup
$principal = New-ScheduledTaskPrincipal -UserId 'SYSTEM' -RunLevel Highest
Register-ScheduledTask -TaskName 'SUCK-Protocol-Disable-ClkReq' -Action $action -Trigger $trigger -Principal $principal -Force | Out-Null
Write-ColorText "       - ✓ Scheduled Task 'SUCK-Protocol-Disable-ClkReq' created" "Green"

# --- FINALIZING NETWORK STACK ---
Write-Host "`nFinalizing with network stack reset..." -ForegroundColor Yellow
"int ip reset", "interface ipv4 reset", "interface ipv6 reset", "interface tcp reset", "winsock reset" | ForEach-Object { netsh $_ 2>&1 | Out-Null }
Write-ColorText "       - ✓ Network stack reset complete" "Green"

# --- FINAL RESULT ---
Write-Header "OPTIMIZATION COMPLETE"
Write-Host ""

# NEW: The final summary now uses the super-fast hacker effect.
Write-Hacker-Fast -Text "Applied Optimizations:" -Color Cyan
Write-Hacker-Fast -Text "✓ NIC interrupt configuration (Line Based, Core 1, High Priority)" -Color Green
Write-Hacker-Fast -Text "✓ Advanced NETSH commands for low-latency networking" -Color Green
Write-Hacker-Fast -Text "✓ NDIS parameters optimized for performance" -Color Green
Write-Hacker-Fast -Text "✓ NetBT settings configured" -Color Green
Write-Hacker-Fast -Text "✓ MTU and Interface Metric optimized" -Color Green
Write-Hacker-Fast -Text "✓ TCP/IP global parameters enhanced" -Color Green
Write-Hacker-Fast -Text "✓ Winsock parameters configured" -Color Green
Write-Hacker-Fast -Text "✓ AFD parameters optimized for high performance" -Color Green
Write-Hacker-Fast -Text "✓ System priority control optimized" -Color Green
Write-Hacker-Fast -Text "✓ Power management completely disabled" -Color Green
Write-Hacker-Fast -Text "✓ Realtek-specific gaming optimizations applied (incl. CLKREQ)" -Color Green
Write-Hacker-Fast -Text "✓ Hardware offloading configured for gaming" -Color Green
Write-Hacker-Fast -Text "✓ Advanced TCP/IP stack optimization completed" -Color Green
Write-Hacker-Fast -Text "✓ Persistent CLKREQ Disable Task created" -Color Green
Write-Host ""
Write-Host "Current Interface Status:" -ForegroundColor Cyan
$ipv4Interfaces = Get-NetIPInterface -AddressFamily IPv4 | Where-Object { $_.ConnectionState -eq "Connected" -and $_.InterfaceAlias -ne "Loopback Pseudo-Interface 1" }
foreach ($interface in $ipv4Interfaces) {
    try {
        $adapter = Get-NetAdapter -InterfaceIndex $interface.ifIndex
        $ipInterface = Get-NetIPInterface -InterfaceIndex $interface.ifIndex -AddressFamily IPv4
        Write-Host "  Interface: $($adapter.Name)" -ForegroundColor White
        Write-Host "    MTU: $($ipInterface.NlMtu) bytes" -ForegroundColor Gray
        Write-Host "    Metric: $($ipInterface.InterfaceMetric)" -ForegroundColor Gray
    } catch {
        Write-Host "  Could not retrieve final status for InterfaceIndex $($interface.ifIndex)" -ForegroundColor Red
    }
}
Write-Host ""

Write-Header "RESTART REQUIRED"
Write-Host "A system restart is required for all optimizations to take effect." -ForegroundColor Red
Write-Host ""
$restart = Read-Host "Would you like to restart now? (y/n)"
if ($restart -eq "y" -or $restart -eq "Y" -or $restart -eq "yes") {
    Write-Host "Initiating system restart..." -ForegroundColor Yellow
    Restart-Computer -Force
} else {
    Write-Host ""
    Write-Host "Please restart your computer manually when convenient." -ForegroundColor Cyan
    Write-Host "Press Enter to exit..." -ForegroundColor Gray
    Read-Host | Out-Null
}
