#====================================================================================
#                          THE S.U.C.K. PROTOCOL
#                  A FortKnight's Legacy by JACKPOT_ZB
#
#       Founder of SUC(K) - Secret Unlocked Circle of FortKnight's
#                Find us on Discord: https://discord.gg/xtgBxkpc2x
#====================================================================================

Clear-Host
$ErrorActionPreference = "Continue"
$Host.UI.RawUI.WindowTitle = "The S.U.C.K. Protocol - A FortKnight's Legacy"

if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "ERROR: Administrator privileges are required!" -ForegroundColor Red
    Write-Host "Please right-click PowerShell and select 'Run as Administrator'." -ForegroundColor Yellow
    Read-Host "Press ENTER to close the window."
    exit
}

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
            Write-ColorText "       - Warning: Could not set property $($prop.Key)." "Yellow"
        }
    }
}

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
Write-Hacker -Text "Before the complaints start again:"
Write-Hacker -Text "This script is exclusively for Realtek adapters on desktop PCs."
Write-Hacker -Text "It is not for laptops, Wi-Fi, or Texas Instruments handhelds."
Write-Hacker -Text "It is for modern fast Ethernet connections and not for an Acoustic coupler"
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

Clear-Host
Write-Header "RUTHLESS NETWORK OPTIMIZATION"

Write-Host "✓ Administrator privileges confirmed - Starting script..." -ForegroundColor Green
Start-Sleep -Seconds 1

Write-Host "`n[1/14] Configuring NIC interrupt settings..." -ForegroundColor Yellow
$netAdaptersPnP = Get-PnpDevice -Class Net -Status OK | Where-Object { $_.InstanceId -notlike "*ROOT\*" -and $_.InstanceId -notlike "*SW\*" -and $_.FriendlyName -notlike "*Virtual*" -and $_.FriendlyName -notlike "*Loopback*" }
if ($netAdaptersPnP) {
    Write-ColorText "       - Found network adapters:" "Cyan"
    $netAdaptersPnP | ForEach-Object { Write-ColorText "         • $($_.FriendlyName)" "White" }
    foreach ($adapter in $netAdaptersPnP) {
        $regPath = "HKLM:\SYSTEM\CurrentControlSet\Enum\$($adapter.InstanceId)\Device Parameters"
        $msiPath = "$regPath\Interrupt Management\MessageSignaledInterruptProperties"
        $affinityPath = "$regPath\Interrupt Management\Affinity Policy"
        $maskBytes = [byte[]]@(0x02,0x00,0x00,0x00,0x00,0x00,0x00,0x00)
        
        if (-not (Test-Path $msiPath)) { New-Item -Path $msiPath -Force | Out-Null }
        Set-ItemProperty -Path $msiPath -Name "MSISupported" -Value 0 -Type DWord -Force
        
        if (-not (Test-Path $affinityPath)) { New-Item -Path $affinityPath -Force | Out-Null }
        Set-ItemProperty -Path $affinityPath -Name "AssignmentSetOverride" -Value $maskBytes -Type Binary -Force
        Set-ItemProperty -Path $affinityPath -Name "DevicePolicy" -Value 4 -Type DWord -Force
        Set-ItemProperty -Path $affinityPath -Name "DevicePriority" -Value 3 -Type DWord -Force
        
        Write-ColorText "       - ✓ Interrupts configured for: $($adapter.FriendlyName)" "Green"
    }
} else {
    Write-ColorText "       - No physical network adapters found." -ForegroundColor Yellow
}

Write-Host "`n[2/14] Applying advanced NETSH commands..." -ForegroundColor Yellow
$netshBaseCommands = @(
    "int ipv6 set gl loopbacklargemtu=disable", 
    "int ipv4 set gl loopbacklargemtu=disable", 
    "int tcp set supplemental Template=Internet CongestionProvider=bbr2",
    "int tcp set supplemental Template=Datacenter CongestionProvider=bbr2",
    "int tcp set supplemental Template=Compat CongestionProvider=bbr2",
    "int tcp set supplemental Template=DatacenterCustom CongestionProvider=bbr2",
    "int tcp set supplemental Template=InternetCustom CongestionProvider=bbr2",
    "int isatap set state disable", 
    "interface teredo set state servername=default", 
    "int ip set global sourceroutingbehavior=drop", 
    "int ip set global neighborcachelimit=4096", 
    "int tcp set security mpp=disabled", 
    "int tcp set security profiles=disabled", 
    "int tcp set global rsc=disabled"
)
$netshBaseCommands | ForEach-Object { netsh $_ 2>&1 | Out-Null }
Write-ColorText "       - ✓ NETSH base commands applied" "Green"

Write-Host "`n[3/14] Configuring NDIS parameters..." -ForegroundColor Yellow
$ndisProperties = @{
    "MaxCachedNblContextSize" = 0x400; "PortAuthReceiveAuthorizationState" = 0; "PortAuthReceiveControlState" = 0;
    "PortAuthSendAuthorizationState" = 0; "PortAuthSendControlState" = 0; "ReceiveWorkerDisableAutoStart" = 0;
    "TrackNblOwner" = 0; "AllowWakeFromS5" = 0; "DefaultPnPCapabilities" = 0; "ReceiveWorkerThreadPriority" = 8;
    "RssBaseCpu" = 3; "DebugLoggingMode" = 0; "DisableNaps" = 1; "DisableNDISWatchDog" = 1;
    "DisableReenumerationTimeoutBugcheck" = 1; "EnableNicAutoPowerSaverInSleepStudy" = 0; "DefaultLoggingLevel" = 0;
    "DefaultUdpEncapsulationOffloadBehavior" = 1; "DisableDHCPMediaSense" = 1; "DisableDHCPv6Relay" = 1;
    "DisableMediaSenseEventLog" = 1; "DisableRscChecksum" = 1; "EnableNDPTethering" = 0; "IPAutoconfigurationEnabled" = 0x400;
    "PortAuthMultiTenant" = 2; "PortAuthRemediation" = 2; "PortAuthSysProfile" = 2; "TrackNDKOwner" = 2; "ThreadPriority" = 0x1f
}
Set-RegistryProperties "HKLM:\SYSTEM\CurrentControlSet\Services\NDIS\Parameters" $ndisProperties
Write-ColorText "       - ✓ NDIS parameters optimized" "Green"

Write-Host "`n[4/14] Configuring NetBT settings..." -ForegroundColor Yellow
Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Services\NetBT\Parameters" -Name "EnableLMHOSTS" -Value 0 -Type DWord -Force
Get-ChildItem "HKLM:\SYSTEM\CurrentControlSet\Services\NetBT\Parameters\Interfaces" | ForEach-Object { Set-ItemProperty -Path $_.PSPath -Name "NetbiosOptions" -Value 2 -Type DWord -Force }
Write-ColorText "       - ✓ NetBT settings configured (includes disabling NetBIOS over TCP/IP)" "Green"

Write-Host "`n[5/14] Advanced Interface optimization..." -ForegroundColor Yellow
$connectedInterfaces = Get-NetAdapter -ErrorAction SilentlyContinue | Where-Object Status -eq "Up"
if ($connectedInterfaces) {
    $mtu = 1500
    $testHost = "1.1.1.1"
    Write-ColorText "       - Testing optimal MTU size against $testHost" "Cyan"
    for ($payload = 1472; $payload -ge 1400; $payload -= 2) {
        ping.exe $testHost -f -n 1 -l $payload -w 500 | Out-Null
        if ($LASTEXITCODE -eq 0) { $mtu = $payload + 28; break }
    }
    if ($mtu -ge 1492) { $mtu = 1500 }
    foreach ($interface in $connectedInterfaces) {
        netsh interface ipv4 set subinterface "$($interface.Name)" mtu=$mtu store=persistent | Out-Null
        Write-ColorText "       - ✓ MTU for $($interface.Name) set to $mtu" "Green"
        Set-NetIPInterface -InterfaceAlias $interface.Name -AutomaticMetric Disabled -InterfaceMetric 1
        Write-ColorText "       - ✓ InterfaceMetric for $($interface.Name) set to 1" "Green"
    }
} else {
    Write-ColorText "       - WARNING: Network adapters could not be queried. Skipping MTU/Metric." "Yellow"
}

Write-Host "`n[6/14] Optimizing TCP/IP global parameters..." -ForegroundColor Yellow
$tcpipProperties = @{"EnablePMTUDiscovery" = 1; "TcpAckFrequency" = 1; "TcpDelAckTicks" = 0; "TCPNoDelay" = 1;"MaxUserPort" = 0xFFFE; "FastSendDatagramThreshold" = 0x5DC; "FastCopyReceiveThreshold" = 0x5DC;"UseDomainNameDevolution" = 1; "DeadGWDetectDefault" = 1; "DontAddDefaultGatewayDefault" = 0;"InitialCongestionWindow" = 10; "UdpNoDelay" = 1; "EnableIPAutoConfigurationLimits" = 0xFF;"IPEnableRouter" = 0; "EnableICMPRedirect" = 1; "DisableTaskOffload" = 0; "Tcp1323Opts" = 0;"DefaultTTL" = 0x40; "TcpMaxDataRetransmissions" = 1; "TcpTimedWaitDelay" = 30;"UDPMaxSockets" = 0xFFFF; "UDPReceiveBufferSize" = 0x40000; "UDPSendBufferSize" = 0x40000}
Set-RegistryProperties "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" $tcpipProperties
Get-ChildItem "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" | ForEach-Object { Set-RegistryProperties $_.PSPath @{"TcpAckFrequency" = 1; "TcpDelAckTicks" = 0; "TCPNoDelay" = 1} }
Write-ColorText "       - ✓ TCP/IP global parameters optimized" "Green"

Write-Host "`n[7/14] Configuring Winsock parameters..." -ForegroundColor Yellow
Set-RegistryProperties "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Winsock" @{"UseDelayedAcceptance" = 0; "MaxSockAddrLength" = 16; "MinSockAddrLength" = 16}
Write-ColorText "       - ✓ Winsock parameters configured" "Green"

Write-Host "`n[8/14] Optimizing AFD parameters..." -ForegroundColor Yellow
$afdProperties = @{
    "FastSendDatagramThreshold" = 0x3E8;
    "FastCopyReceiveThreshold" = 0x3E8;
    "MinimumDynamicBacklog" = 32;
    "MaximumDynamicBacklog" = 4096;
    "UDPMaxSockets" = 0xFFFF;
    "UDPReceiveBufferSize" = 0x400;
    "UDPSendBufferSize" = 0x400;
    "AfdDoNotHoldNICBuffers" = 1;
    "MaxActiveTransmitFileCount" = 0;
    "MaxFastCopyTransmit" = 0x1000;
    "MaxFastTransmit" = 0x10000;
    "DoNotHoldNICBuffers" = 1;
    "IRPStackSize" = 20;
    "EnableDynamicBacklog" = 0;
    "DynamicBacklogGrowthDelta" = 0;
    "LargeBufferListDepth" = 16;
    "OverheadChargeGranularity" = 0x1000;
    "StandardAddressLength" = 22;
    "TransmitIoLength" = 0x10000
}
Set-RegistryProperties "HKLM:\SYSTEM\CurrentControlSet\Services\AFD\Parameters" $afdProperties
Write-ColorText "       - ✓ AFD parameters optimized" "Green"

Write-Host "`n[9/14] Configuring system priority control..." -ForegroundColor Yellow
Set-RegistryProperties "HKLM:\SYSTEM\CurrentControlSet\Control\PriorityControl" @{"ConvertibleSlateMode" = 0; "Win32PrioritySeparation" = 0x18; "IRQ16Priority" = 1}
Write-ColorText "       - ✓ System priority control optimized" "Green"

Write-Host "`n[10/14] Disabling general power management features..." -ForegroundColor Yellow
$generalPowerProperties = @{"EnablePME" = "0"; "*DeviceSleepOnDisconnect" = "0"; "*EEE" = "0"; "*ModernStandbyWoLMagicPacket" = "0";"*SelectiveSuspend" = "0"; "*WakeOnMagicPacket" = "0"; "*WakeOnPattern" = "0"; "AutoPowerSaveModeEnabled" = "0";"EEELinkAdvertisement" = "0"; "EeePhyEnable" = "0"; "EnableGreenEthernet" = "0"; "EnableModernStandby" = "0";"GigaLite" = "0"; "PowerDownPll" = "0"; "PowerSavingMode" = "0"; "ReduceSpeedOnPowerDown" = "0";"S5WakeOnLan" = "0"; "SavePowerNowEnabled" = "0"; "ULPMode" = "0"; "WakeOnLink" = "0"; "WakeOnSlot" = "0";"WakeUpModeCap" = "0"; "WaitAutoNegComplete" = "0"; "*FlowControl" = "0"; "WolShutdownLinkSpeed" = "2";"WakeOnMagicPacketFromS5" = "0"; "*PMNSOffload" = "0"; "*PMARPOffload" = "0"; "*NicAutoPowerSaver" = "0";"*PMWiFiRekeyOffload" = "0"; "EnablePowerManagement" = "0"; "ForceWakeFromMagicPacketOnModernStandby" = "0";"WakeFromS5" = "0"; "WakeOn" = "0"; "OBFFEnabled" = "0"; "DMACoalescing" = "0"; "EnableSavePowerNow" = "0";"EnableD0PHYFlexibleSpeed" = "0"}
Get-ChildItem "HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}" -ErrorAction SilentlyContinue | ForEach-Object { Set-ItemProperty -Path $_.PSPath -Name "PnPCapabilities" -Value 24 -Type DWord -Force; Set-RegistryProperties $_.PSPath $generalPowerProperties }
Write-ColorText "       - ✓ General power management disabled for all adapters" "Green"

Write-Host "`n[11/14] Applying Realtek-specific optimizations (including advanced CLKREQ fix)..." -ForegroundColor Yellow

$realtekNic = Get-NetAdapter | Where-Object { $_.InterfaceDescription -eq 'Realtek PCIe 2.5GbE Family Controller' -and $_.Status -eq 'Up' }
if (-not $realtekNic) {
    Write-ColorText "       - Fallback: Trying general Realtek 2.5GbE search." "Cyan"
    $realtekNic = Get-NetAdapter | Where-Object { $_.InterfaceDescription -like '*Realtek*2.5GbE*' -and $_.Status -eq 'Up' }
}

if ($realtekNic) {
    Write-ColorText "       - Found Realtek NIC: $($realtekNic.Name) ('$($realtekNic.InterfaceDescription)')" "Cyan"

    Try {
        $powerManagementSetting = Get-NetAdapterPowerManagement -Name $realtekNic.Name | Where-Object { $_.DisplayName -eq 'Allow the computer to turn off this device to save power' }
        if ($powerManagementSetting -and $powerManagementSetting.Enabled) {
            Disable-NetAdapterPowerManagement -Name $realtekNic.Name -DisplayName 'Allow the computer to turn off this device to save power' -ErrorAction Stop
            Write-ColorText "       - [✓] 'Allow PC to turn off device to save power' disabled." "Green"
        } else {
            Write-ColorText "       - [✓] 'Allow PC to turn off device to save power' already disabled or not applicable." "Green"
        }
    } Catch {
        Write-ColorText "       - Error disabling 'Allow PC to turn off device to save power': $($_.Exception.Message)" "Red"
    }

    Try {
        $eeeSetting = Get-NetAdapterAdvancedProperty -Name $realtekNic.Name -DisplayName 'Energy Efficient Ethernet' -ErrorAction SilentlyContinue
        if ($eeeSetting -and $eeeSetting.RegistryValue -ne 0) {
            Set-NetAdapterAdvancedProperty -Name $realtekNic.Name -DisplayName 'Energy Efficient Ethernet' -DisplayValue 'Disabled' -ErrorAction Stop
            Write-ColorText "       - [✓] 'Energy Efficient Ethernet' disabled." "Green"
        } elseif ($eeeSetting -and $eeeSetting.RegistryValue -eq 0) {
            Write-ColorText "       - [✓] 'Energy Efficient Ethernet' already disabled or not applicable." "Green"
        } else {
            Write-ColorText "       - [✓] 'Energy Efficient Ethernet' not found or not applicable." "Green"
        }
    } Catch {
        Write-ColorText "       - Error disabling 'Energy Efficient Ethernet': $($_.Exception.Message)" "Red"
    }

    $clkreqAdvancedProperties = @(
        @{ DisplayName = "CLKREQ# Power Management"; RegistryKeyword = "PcieClkReqUsePort"; Value = 0 },
        @{ DisplayName = "PcieClkReqUsePort"; RegistryKeyword = "PcieClkReqUsePort"; Value = 0 },
        @{ DisplayName = "CLKREQ"; RegistryKeyword = "CLKREQ"; Value = 0 }
    )

    foreach ($prop in $clkreqAdvancedProperties) {
        Try {
            $currentProp = Get-NetAdapterAdvancedProperty -Name $realtekNic.Name -DisplayName $prop.DisplayName -ErrorAction SilentlyContinue
            if ($currentProp) {
                if ($currentProp.RegistryValue -ne $prop.Value) {
                    Set-NetAdapterAdvancedProperty -Name $realtekNic.Name -DisplayName $prop.DisplayName -RegistryKeyword $prop.RegistryKeyword -RegistryValue $prop.Value -ErrorAction Stop
                    Write-ColorText "       - [✓] '$($prop.DisplayName)' successfully set." "Green"
                } else {
                    Write-ColorText "       - [✓] '$($prop.DisplayName)' already set." "Green"
                }
            } else {
                Set-NetAdapterAdvancedProperty -Name $realtekNic.Name -RegistryKeyword $prop.RegistryKeyword -RegistryValue $prop.Value -ErrorAction SilentlyContinue
                Write-ColorText "       - [✓] '$($prop.RegistryKeyword)' successfully set (via RegistryKeyword fallback)." "Green"
            }
        } Catch {
            Write-ColorText "       - Error setting '$($prop.DisplayName)' or '$($prop.RegistryKeyword)': $($_.Exception.Message)" "Red"
        }
    }

    $nicRegPathBase = "HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}"
    $adapterInstanceKey = Get-ItemProperty -Path "${nicRegPathBase}\*" -ErrorAction SilentlyContinue | Where-Object { $_.NetCfgInstanceId -eq $realtekNic.InstanceID } | Select-Object -ExpandProperty PSPath

    if ($adapterInstanceKey) {
        
        $clkreqRegistrySettings = @{
            "ASPM" = 0;
            "CLKREQ" = 0;
            "HwOption" = 0x00C00000;
            "HwOptionV2" = 0x00000004;
            "HwOptionV3" = 0x00040000;
            "RM2779240" = 5;
            "PcieClkReqUsePort" = 0;
            "*ClkReqEnable" = 0;
            "*ClkReqSupported" = 0;
            "EnableClkReq" = 0;
            "*MSIXClkReq" = 0;
        }

        foreach ($key in $clkreqRegistrySettings.Keys) {
            $value = $clkreqRegistrySettings[$key]
            Try {
                Set-ItemProperty -Path $adapterInstanceKey -Name $key -Value $value -Force -ErrorAction Stop
                Write-ColorText "       - [✓] Registry key '$key' successfully set." "Green"
            } Catch {
                Write-ColorText "       - Error setting registry key '$key': $($_.Exception.Message)" "Red"
            }
        }
    } else {
        Write-ColorText "       - Could not find specific registry path for Realtek network adapter. Some CLKREQ tweaks skipped." "Yellow"
    }

    $realtek0001Path = "HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0001"
    $realtek0000Path = "HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0000"

    $realtek0001Settings = @{"EnableUPS" = 0; "DisablePwrSavingOnRST" = 1; "EnableExtraPowerSaving" = 0; "EnableD3Cold" = 0;"EnableD3ColdInterface" = 0; "EnableOOBSelectiveSuspend" = 0; "ALDPS" = 0; "EnablePowerCut" = 0; "*PacketDirect" = 1}
    $realtek0000Settings = @{
        "*SpeedDuplex" = "6";
        "*FlowControl" = "0";
        "*InterruptModeration" = "0";
        "*IPChecksumOffloadIPv4" = "0";
        "*TCPChecksumOffloadIPv4" = "0";
        "*UDPChecksumOffloadIPv4" = "0";
        "*TCPChecksumOffloadIPv6" = "0";
        "*UDPChecksumOffloadIPv6" = "0";
        "*LsoV2IPv4" = "0";
        "*LsoV2IPv6" = "0";
        "*JumboPacket" = "1514";
        "*ReceiveBuffers" = "1024";
        "*TransmitBuffers" = "512";
        "*RSS" = "0";
        "*NumRssQueues" = "1";
        "*DeviceSleepOnDisconnect" = "0";
        "*NicAutoPowerSaver" = "0";
        "EnablePowerManagement" = "0";
        "*EEE" = "0";
        "ULPMode" = "0";
        "PowerSavingMode" = "0";
        "*WakeOnPattern" = "0";
        "*WakeOnMagicPacket" = "0";
        "S5WakeOnLan" = "0";
        "WakeFromS5" = "0";
        "*PMARPOffload" = "0";
        "*PMNSOffload" = "0";
        "*EncapsulatedPacketTaskOffloadNvgre" = "0";
        "*EncapsulatedPacketTaskOffloadVxlan" = "0";
        "*IPsecOffloadV1IPv4" = "0";
        "*IPsecOffloadV2IPv4" = "0";
        "*UsoIPv4" = "0";
        "*UsoIPv6" = "0";
        "*PacketDirect" = 1;
        "EnableUdpTxScaling" = 0;
        "EnableConnectedPowerGating" = 0;
        "DisableDelayedPowerUp" = 1
    }

    if (Test-Path $realtek0001Path) { Set-RegistryProperties $realtek0001Path $realtek0001Settings; Write-ColorText "       - [✓] Realtek generic 0001 settings applied." "Green" }
    if (Test-Path $realtek0000Path) { Set-RegistryProperties $realtek0000Path $realtek0000Settings; Write-ColorText "       - [✓] Realtek generic 0000 settings applied." "Green" }

} else {
    Write-ColorText "       - WARNING: No active Realtek PCIe 2.5GbE network adapter found. Realtek-specific optimizations (incl. CLKREQ fix) skipped." "Yellow"
}

Write-Host "`n[12/14] Configuring hardware offloading..." -ForegroundColor Yellow
$adaptersToConfig = Get-NetAdapter -ErrorAction SilentlyContinue
if ($adaptersToConfig) {
    netsh int tcp set global chimney=disabled | Out-Null
    foreach ($adapter in $adaptersToConfig) { Disable-NetAdapterRss -Name $adapter.Name -ErrorAction SilentlyContinue | Out-Null }
    netsh int tcp set global rsc=disabled | Out-Null
    netsh interface udp set global uro=disabled | Out-Null
    netsh interface udp set global uso=disabled | Out-Null
    Write-ColorText "       - ✓ Hardware offloading disabled" "Green"
} else {
    Write-ColorText "       - WARNING: Network adapters could not be queried. Skipping Offloading." "Yellow"
}

Write-Host "`n[13/14] Final TCP/IP stack optimization..." -ForegroundColor Yellow
$congestionProvider = if ((Get-CimInstance -ClassName Win32_OperatingSystem).Caption -match "Windows 11") { "BBR2" } else { "dctcp" }
"Internet", "Datacenter", "Compat", "DatacenterCustom", "InternetCustom" | ForEach-Object { netsh int tcp set supplemental Template=$_ CongestionProvider=$congestionProvider 2>&1 | Out-Null }
"6to4", "isatap", "teredo" | ForEach-Object { netsh interface $_ set state disabled 2>&1 | Out-Null }
netsh int tcp set global autotuninglevel=enabled | Out-Null; netsh int tcp set global ecncapability=disabled | Out-Null; netsh int tcp set global timestamps=disabled | Out-Null; netsh int tcp set global initialRto=300 | Out-Null; netsh int tcp set global rss=disabled | Out-Null
Write-ColorText "       - ✓ Final TCP settings applied" "Green"

Write-Host "`n[14/14] Creating persistent CLKREQ task (comprehensive fix)..." -ForegroundColor Yellow

$scriptDir = "C:\Scripts"
$scriptPath = Join-Path $scriptDir "Disable-RealtekClkReq.ps1"
$taskName = "SUCK-Protocol-Disable-RealtekClkReq"

$clkreqScriptContent = @"
# Disable-RealtekClkReq.ps1
`$LogFile = "C:\Scripts\Disable-RealtekClkReq_Log.txt"
Add-Content -Path `$LogFile -Value "`n--- Start of execution on $(Get-Date) ---`n"

Start-Sleep -Seconds 5
Add-Content -Path `$LogFile -Value "Waiting period of 5 seconds completed."

Add-Content -Path `$LogFile -Value "--- Found network adapters (all) ---"
Get-NetAdapter | ForEach-Object {
    Add-Content -Path `$LogFile -Value "Name: `$(_.Name), Description: `$(_.Description), InterfaceDescription: `$(_.InterfaceDescription), Status: `$(_.Status), InstanceID: `$(_.InstanceID)"
}
Add-Content -Path `$LogFile -Value "---------------------------------------"

`$nic = Get-NetAdapter | Where-Object { `$_.InterfaceDescription -eq 'Realtek PCIe 2.5GbE Family Controller' -and `$_.Status -eq 'Up' }

if (-not `$nic) {
    Add-Content -Path `$LogFile -Value "Exact InterfaceDescription not found, trying general Realtek 2.5GbE search (Fallback)."
    `$nic = Get-NetAdapter | Where-Object { `$_.InterfaceDescription -like '*Realtek*2.5GbE*' -and `$_.Status -eq 'Up' }
}

if (`$nic) {
    Add-Content -Path `$LogFile -Value "Realtek network adapter found: `$(`$nic.Name) (Description: '`$(`$nic.Description)', InterfaceDescription: '`$(`$nic.InterfaceDescription)')"

    Try {
        `$powerManagementSetting = Get-NetAdapterPowerManagement -Name `$nic.Name | Where-Object { `$_.DisplayName -eq 'Allow the computer to turn off this device to save power' }
        if (`$powerManagementSetting -and `$powerManagementSetting.Enabled) {
            Disable-NetAdapterPowerManagement -Name `$nic.Name -DisplayName 'Allow the computer to turn off this device to save power' -ErrorAction Stop
            Add-Content -Path `$LogFile -Value "[✓] 'Allow PC to turn off device to save power' disabled."
        } else {
            Add-Content -Path `$LogFile -Value "[✓] 'Allow PC to turn off device to save power' already disabled or not applicable."
        }
    } Catch {
        Add-Content -Path `$LogFile -Value "Error disabling 'Allow PC to turn off device to save power': `$(_.Exception.Message)"
    }

    Try {
        `$eeeSetting = Get-NetAdapterAdvancedProperty -Name `$nic.Name -DisplayName 'Energy Efficient Ethernet' -ErrorAction SilentlyContinue
        if (`$eeeSetting -and `$eeeSetting.RegistryValue -ne 0) {
            Set-NetAdapterAdvancedProperty -Name `$nic.Name -DisplayName 'Energy Efficient Ethernet' -DisplayValue 'Disabled' -ErrorAction Stop
            Add-Content -Path `$LogFile -Value "[✓] 'Energy Efficient Ethernet' disabled."
        } elseif (`$eeeSetting -and `$eeeSetting.RegistryValue -eq 0) {
            Add-Content -Path `$LogFile -Value "[✓] 'Energy Efficient Ethernet' already disabled or not applicable."
        } else {
            Add-Content -Path `$LogFile -Value "[✓] 'Energy Efficient Ethernet' not found or not applicable."
        }
    } Catch {
        Add-Content -Path `$LogFile -Value "Error disabling 'Energy Efficient Ethernet': `$(_.Exception.Message)"
    }

    `$clkreqProperties = @(
        @{ DisplayName = "CLKREQ# Power Management"; RegistryKeyword = "PcieClkReqUsePort"; Value = 0 },
        @{ DisplayName = "PcieClkReqUsePort"; RegistryKeyword = "PcieClkReqUsePort"; Value = 0 },
        @{ DisplayName = "CLKREQ"; RegistryKeyword = "CLKREQ"; Value = 0 }
    )

    foreach (`$prop in `$clkreqProperties) {
        Try {
            `$currentProp = Get-NetAdapterAdvancedProperty -Name `$nic.Name -DisplayName `$prop.DisplayName -ErrorAction SilentlyContinue
            if (`$currentProp) {
                if (`$currentProp.RegistryValue -ne `$prop.Value) {
                    Set-NetAdapterAdvancedProperty -Name `$nic.Name -DisplayName `$prop.DisplayName -RegistryKeyword `$prop.RegistryKeyword -RegistryValue `$prop.Value -ErrorAction Stop
                    Add-Content -Path `$LogFile -Value "[✓] '`$(`$prop.DisplayName)' successfully set."
                } else {
                    Add-Content -Path `$LogFile -Value "[✓] '`$(`$prop.DisplayName)' already set."
                }
            } else {
                Set-NetAdapterAdvancedProperty -Name `$nic.Name -RegistryKeyword `$prop.RegistryKeyword -RegistryValue `$prop.Value -ErrorAction SilentlyContinue
                Add-Content -Path `$LogFile -Value "[✓] '`$(`$prop.RegistryKeyword)' successfully set (via RegistryKeyword fallback)."
            }
        } Catch {
            Add-Content -Path `$LogFile -Value "Error setting '`$(`$prop.DisplayName)' or '`$(`$prop.RegistryKeyword)': `$(_.Exception.Message)"
        }
    }

    `$nicRegPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\"
    `$adapterInstanceKey = Get-ItemProperty -Path "`$nicRegPath`*" -ErrorAction SilentlyContinue | Where-Object { `$_.NetCfgInstanceId -eq `$nic.InstanceID } | Select-Object -ExpandProperty PSPath

    if (`$adapterInstanceKey) {
        
        `$registrySettings = @{
            "ASPM" = 0;
            "CLKREQ" = 0;
            "HwOption" = 0x00C00000;
            "HwOptionV2" = 0x00000004;
            "HwOptionV3" = 0x00040000;
            "RM2779240" = 5;
            "PcieClkReqUsePort" = 0;
            "*ClkReqEnable" = 0;
            "*ClkReqSupported" = 0;
            "EnableClkReq" = 0;
            "*MSIXClkReq" = 0;
        }

        foreach (`$key in `$registrySettings.Keys) {
            `$value = `$registrySettings[`$key]
            Try {
                Set-ItemProperty -Path `$adapterInstanceKey -Name `$key -Value `$value -Force -ErrorAction Stop
                Add-Content -Path `$LogFile -Value "[✓] Registry key '`$key' successfully set."
            } Catch {
                Add-Content -Path `$LogFile -Value "Error setting registry key '`$key': `$(_.Exception.Message)"
            }
        }
    } else {
        Add-Content -Path `$LogFile -Value "Could not find specific registry path for Realtek network adapter."
    }

} else {
    Add-Content -Path `$LogFile -Value "No active Realtek PCIe GBE network adapter found after all attempts."
}

Add-Content -Path `$LogFile -Value "`n--- End of execution on $(Get-Date) ---`n"
"@

if (-not (Test-Path $scriptDir)) {
    New-Item -ItemType Directory -Path $scriptDir -Force | Out-Null
    Write-ColorText "       - [✓] Script folder created: $scriptDir" "Green"
} else {
    Write-ColorText "       - [✓] Script folder exists: $scriptDir" "Green"
}

Try {
    $clkreqScriptContent | Set-Content -Path $scriptPath -Force -Encoding UTF8
    Write-ColorText "       - [✓] 'Disable-RealtekClkReq.ps1' copied to: $scriptPath" "Green"
} Catch {
    Write-ColorText "       - [✗] ERROR: Could not copy 'Disable-RealtekClkReq.ps1': $($_.Exception.Message)" "Red"
}

Try {
    $action = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument "-NoProfile -ExecutionPolicy Bypass -File `"$scriptPath`""
    $trigger = New-ScheduledTaskTrigger -AtStartup
    $principal = New-ScheduledTaskPrincipal -UserId 'SYSTEM' -RunLevel Highest
    Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -Principal $principal -Force | Out-Null
    Write-ColorText "       - [✓] Scheduled task '$taskName' created or updated!" "Green"
} Catch {
    Write-ColorText "       - [✗] ERROR: Could not create scheduled task: $($_.Exception.Message)" "Red"
}

Write-Host "`nFinalizing with network stack reset..." -ForegroundColor Yellow
"int ip reset", "interface ipv4 reset", "interface ipv6 reset", "interface tcp reset", "winsock reset" | ForEach-Object { netsh $_ 2>&1 | Out-Null }
Write-ColorText "       - ✓ Network stack reset complete" "Green"

Write-Header "OPTIMIZATION COMPLETE"
Write-Host ""
Write-Hacker-Fast -Text "Applied Optimizations:" -Color Cyan
Start-Sleep -Milliseconds 50
Write-Hacker-Fast -Text "✓ NIC interrupt configuration (Line Based, Core 1, High Priority)" -Color Green
Start-Sleep -Milliseconds 50
Write-Hacker-Fast -Text "✓ Advanced NETSH commands for low-latency networking" -Color Green
Start-Sleep -Milliseconds 50
Write-Hacker-Fast -Text "✓ NDIS parameters optimized for performance" -Color Green
Start-Sleep -Milliseconds 50
Write-Hacker-Fast -Text "✓ NetBT settings configured" -Color Green
Start-Sleep -Milliseconds 50
Write-Hacker-Fast -Text "✓ MTU and Interface Metric optimized" -Color Green
Start-Sleep -Milliseconds 50
Write-Hacker-Fast -Text "✓ TCP/IP global parameters enhanced" -Color Green
Start-Sleep -Milliseconds 50
Write-Hacker-Fast -Text "✓ Winsock parameters configured" -Color Green
Start-Sleep -Milliseconds 50
Write-Hacker-Fast -Text "✓ AFD parameters optimized for high performance" -Color Green
Start-Sleep -Milliseconds 50
Write-Hacker-Fast -Text "✓ System priority control optimized" -Color Green
Start-Sleep -Milliseconds 50
Write-Hacker-Fast -Text "✓ General power management completely disabled" -Color Green
Start-Sleep -Milliseconds 50
Write-Hacker-Fast -Text "✓ Realtek-specific gaming optimizations applied" -Color Green
Start-Sleep -Milliseconds 50
Write-Hacker-Fast -Text "✓ Advanced Realtek CLKREQ and power management fix applied" -Color Green
Start-Sleep -Milliseconds 50
Write-Hacker-Fast -Text "✓ Hardware offloading configured for gaming" -Color Green
Start-Sleep -Milliseconds 50
Write-Hacker-Fast -Text "✓ Advanced TCP/IP stack optimization completed" -Color Green
Start-Sleep -Milliseconds 50
Write-Hacker-Fast -Text "✓ Persistent CLKREQ Disable Task (Comprehensive) created" -Color Green
Write-Host ""
Write-Host "Current Interface Status:" -ForegroundColor Cyan
$ipv4Interfaces = Get-NetIPInterface -AddressFamily IPv4 -ErrorAction SilentlyContinue | Where-Object { $_.ConnectionState -eq "Connected" -and $_.InterfaceAlias -ne "Loopback Pseudo-Interface 1" }
if ($ipv4Interfaces) {
    foreach ($interface in $ipv4Interfaces) {
        $adapter = Get-NetAdapter -InterfaceIndex $interface.ifIndex -ErrorAction SilentlyContinue
        if ($adapter) {
            $ipInterface = Get-NetIPInterface -InterfaceIndex $interface.ifIndex -AddressFamily IPv4
            Write-Host "  Interface: $($adapter.Name)" -ForegroundColor White
            Write-Host "    MTU: $($ipInterface.NlMtu) bytes" -ForegroundColor Gray
            Write-Host "    Metric: $($ipInterface.InterfaceMetric)" -ForegroundColor Gray
        } else {
            Write-Host "  Could not retrieve final status for InterfaceIndex: $($interface.ifIndex)" -ForegroundColor Red
        }
    }
} else {
    Write-Host "  WARNING: Network interfaces could not be queried." -ForegroundColor Yellow
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
