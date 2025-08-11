if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process powershell -ArgumentList "-File `"$($MyInvocation.MyCommand.Path)`"" -Verb RunAs
    exit
}

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$registryPath = "HKLM:\SOFTWARE\Policies\BraveSoftware\Brave"

if (-not (Test-Path -Path $registryPath)) {
    New-Item -Path $registryPath -Force
}

Clear-Host

# Modern color scheme
$primaryColor = [System.Drawing.Color]::FromArgb(255, 255, 87, 34)  # Brave Orange
$primaryDark = [System.Drawing.Color]::FromArgb(255, 230, 74, 25)
$backgroundColor = [System.Drawing.Color]::FromArgb(255, 18, 18, 18)
$surfaceColor = [System.Drawing.Color]::FromArgb(255, 28, 28, 28)
$cardColor = [System.Drawing.Color]::FromArgb(255, 38, 38, 38)
$textPrimary = [System.Drawing.Color]::White
$textSecondary = [System.Drawing.Color]::FromArgb(255, 189, 189, 189)
$accentGreen = [System.Drawing.Color]::FromArgb(255, 76, 175, 80)
$accentRed = [System.Drawing.Color]::FromArgb(255, 244, 67, 54)

function Set-DnsMode {
    param ([string] $dnsMode)
    $regKey = "HKLM:\\Software\\Policies\\BraveSoftware\\Brave"
    Set-ItemProperty -Path $regKey -Name "DnsOverHttpsMode" -Value $dnsMode -Type String -Force
    [System.Windows.Forms.MessageBox]::Show("DNS Over HTTPS Mode has been set to $dnsMode.", "Success", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
}

# Create main form with modern design
$form = New-Object System.Windows.Forms.Form
$form.Text = "SlimBrave v3.0 - Modern Debloater"
$form.Size = New-Object System.Drawing.Size(1200, 800)
$form.StartPosition = "CenterScreen"
$form.BackColor = $backgroundColor
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::None

# Custom title bar
$titleBar = New-Object System.Windows.Forms.Panel
$titleBar.Size = New-Object System.Drawing.Size(1200, 40)
$titleBar.BackColor = $surfaceColor
$titleBar.Dock = [System.Windows.Forms.DockStyle]::Top
$form.Controls.Add($titleBar)

$titleLabel = New-Object System.Windows.Forms.Label
$titleLabel.Text = "SlimBrave v3.0"
$titleLabel.Font = New-Object System.Drawing.Font("Segoe UI", 14, [System.Drawing.FontStyle]::Bold)
$titleLabel.ForeColor = $textPrimary
$titleLabel.Location = New-Object System.Drawing.Point(15, 8)
$titleLabel.Size = New-Object System.Drawing.Size(300, 25)
$titleBar.Controls.Add($titleLabel)

# Window controls
$closeButton = New-Object System.Windows.Forms.Button
$closeButton.Text = "X"
$closeButton.Font = New-Object System.Drawing.Font("Segoe UI", 12)
$closeButton.ForeColor = $textPrimary
$closeButton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$closeButton.FlatAppearance.BorderSize = 0
$closeButton.Size = New-Object System.Drawing.Size(40, 40)
$closeButton.Location = New-Object System.Drawing.Point(1160, 0)
$closeButton.Add_Click({ $form.Close() })
$titleBar.Controls.Add($closeButton)

$minimizeButton = New-Object System.Windows.Forms.Button
$minimizeButton.Text = "-"
$minimizeButton.Font = New-Object System.Drawing.Font("Segoe UI", 12)
$minimizeButton.ForeColor = $textPrimary
$minimizeButton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$minimizeButton.FlatAppearance.BorderSize = 0
$minimizeButton.Size = New-Object System.Drawing.Size(40, 40)
$minimizeButton.Location = New-Object System.Drawing.Point(1120, 0)
$minimizeButton.Add_Click({ $form.WindowState = [System.Windows.Forms.FormWindowState]::Minimized })
$titleBar.Controls.Add($minimizeButton)

# Make title bar draggable
$script:isDragging = $false
$script:dragLocation = [System.Drawing.Point]::Empty

$titleBar.Add_MouseDown({
    $script:isDragging = $true
    $script:dragLocation = New-Object System.Drawing.Point($_.X, $_.Y)
})

$titleBar.Add_MouseMove({
    if ($script:isDragging) {
        $form.Location = New-Object System.Drawing.Point(
            ($form.Location.X + $_.X - $script:dragLocation.X),
            ($form.Location.Y + $_.Y - $script:dragLocation.Y)
        )
    }
})

$titleBar.Add_MouseUp({ $script:isDragging = $false })

# Header panel with stats
$headerPanel = New-Object System.Windows.Forms.Panel
$headerPanel.Location = New-Object System.Drawing.Point(0, 40)
$headerPanel.Size = New-Object System.Drawing.Size(1200, 120)
$headerPanel.BackColor = $surfaceColor
$form.Controls.Add($headerPanel)

# Stats cards
$selectedCard = New-Object System.Windows.Forms.Panel
$selectedCard.Size = New-Object System.Drawing.Size(280, 80)
$selectedCard.Location = New-Object System.Drawing.Point(250, 20)
$selectedCard.BackColor = $cardColor
$headerPanel.Controls.Add($selectedCard)

$selectedIcon = New-Object System.Windows.Forms.Label
$selectedIcon.Text = "Selected"
$selectedIcon.Font = New-Object System.Drawing.Font("Segoe UI", 24)
$selectedIcon.Location = New-Object System.Drawing.Point(20, 20)
$selectedIcon.Size = New-Object System.Drawing.Size(40, 40)
$selectedCard.Controls.Add($selectedIcon)

$selectedLabel = New-Object System.Windows.Forms.Label
$selectedLabel.Text = "SELECTED"
$selectedLabel.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$selectedLabel.ForeColor = $textSecondary
$selectedLabel.Location = New-Object System.Drawing.Point(70, 15)
$selectedLabel.Size = New-Object System.Drawing.Size(100, 20)
$selectedCard.Controls.Add($selectedLabel)

$selectedCount = New-Object System.Windows.Forms.Label
$selectedCount.Text = "0 / 0"
$selectedCount.Font = New-Object System.Drawing.Font("Segoe UI", 20, [System.Drawing.FontStyle]::Bold)
$selectedCount.ForeColor = $primaryColor
$selectedCount.Location = New-Object System.Drawing.Point(70, 35)
$selectedCount.Size = New-Object System.Drawing.Size(150, 30)
$selectedCard.Controls.Add($selectedCount)

$appliedCard = New-Object System.Windows.Forms.Panel
$appliedCard.Size = New-Object System.Drawing.Size(280, 80)
$appliedCard.Location = New-Object System.Drawing.Point(550, 20)
$appliedCard.BackColor = $cardColor
$headerPanel.Controls.Add($appliedCard)

$appliedIcon = New-Object System.Windows.Forms.Label
$appliedIcon.Text = "Applied"
$appliedIcon.Font = New-Object System.Drawing.Font("Segoe UI", 24)
$appliedIcon.Location = New-Object System.Drawing.Point(20, 20)
$appliedIcon.Size = New-Object System.Drawing.Size(40, 40)
$appliedCard.Controls.Add($appliedIcon)

$appliedLabel = New-Object System.Windows.Forms.Label
$appliedLabel.Text = "APPLIED"
$appliedLabel.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$appliedLabel.ForeColor = $textSecondary
$appliedLabel.Location = New-Object System.Drawing.Point(70, 15)
$appliedLabel.Size = New-Object System.Drawing.Size(100, 20)
$appliedCard.Controls.Add($appliedLabel)

$appliedCount = New-Object System.Windows.Forms.Label
$appliedCount.Text = "0"
$appliedCount.Font = New-Object System.Drawing.Font("Segoe UI", 20, [System.Drawing.FontStyle]::Bold)
$appliedCount.ForeColor = $accentGreen
$appliedCount.Location = New-Object System.Drawing.Point(70, 35)
$appliedCount.Size = New-Object System.Drawing.Size(150, 30)
$appliedCard.Controls.Add($appliedCount)

# Search box with modern style
$searchPanel = New-Object System.Windows.Forms.Panel
$searchPanel.Size = New-Object System.Drawing.Size(360, 40)
$searchPanel.Location = New-Object System.Drawing.Point(850, 40)
$searchPanel.BackColor = $cardColor
$headerPanel.Controls.Add($searchPanel)

$searchIcon = New-Object System.Windows.Forms.Label
$searchIcon.Text = "Search:"
$searchIcon.Font = New-Object System.Drawing.Font("Segoe UI", 12)
$searchIcon.Location = New-Object System.Drawing.Point(10, 10)
$searchIcon.Size = New-Object System.Drawing.Size(25, 20)
$searchPanel.Controls.Add($searchIcon)

$searchBox = New-Object System.Windows.Forms.TextBox
$searchBox.Location = New-Object System.Drawing.Point(40, 9)
$searchBox.Size = New-Object System.Drawing.Size(310, 22)
$searchBox.BorderStyle = [System.Windows.Forms.BorderStyle]::None
$searchBox.BackColor = $cardColor
$searchBox.ForeColor = $textPrimary
$searchBox.Font = New-Object System.Drawing.Font("Segoe UI", 11)
$searchPanel.Controls.Add($searchBox)

# Sidebar navigation
$sidebar = New-Object System.Windows.Forms.Panel
$sidebar.Location = New-Object System.Drawing.Point(0, 160)
$sidebar.Size = New-Object System.Drawing.Size(240, 560)
$sidebar.BackColor = $surfaceColor
$form.Controls.Add($sidebar)

$categories = @(
    @{Name = "Privacy & Security"; Tag = "privacy"},
    @{Name = "Telemetry & Data"; Tag = "telemetry"},
    @{Name = "Brave Features"; Tag = "brave"},
    @{Name = "Performance"; Tag = "performance"},
    @{Name = "Advanced"; Tag = "advanced"}
)

$categoryButtons = @()
$y = 20
foreach ($cat in $categories) {
    $btn = New-Object System.Windows.Forms.Button
    $btn.Text = $cat.Name
    $btn.Tag = $cat.Tag
    $btn.Font = New-Object System.Drawing.Font("Segoe UI", 11)
    $btn.ForeColor = $textPrimary
    $btn.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
    $btn.FlatAppearance.BorderSize = 0
    $btn.Size = New-Object System.Drawing.Size(220, 50)
    $btn.Location = New-Object System.Drawing.Point(10, $y)
    $btn.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
    $btn.Padding = New-Object System.Windows.Forms.Padding(20, 0, 0, 0)
    $sidebar.Controls.Add($btn)
    $categoryButtons += $btn
    $y += 60
}

# Main content area
$contentPanel = New-Object System.Windows.Forms.Panel
$contentPanel.Location = New-Object System.Drawing.Point(250, 170)
$contentPanel.Size = New-Object System.Drawing.Size(940, 500)
$contentPanel.BackColor = $backgroundColor
$contentPanel.AutoScroll = $true
$form.Controls.Add($contentPanel)

# Footer with actions
$footer = New-Object System.Windows.Forms.Panel
$footer.Location = New-Object System.Drawing.Point(0, 680)
$footer.Size = New-Object System.Drawing.Size(1200, 120)
$footer.BackColor = $surfaceColor
$form.Controls.Add($footer)

# DNS settings
$dnsPanel = New-Object System.Windows.Forms.Panel
$dnsPanel.Size = New-Object System.Drawing.Size(350, 40)
$dnsPanel.Location = New-Object System.Drawing.Point(30, 20)
$dnsPanel.BackColor = $cardColor
$footer.Controls.Add($dnsPanel)

$dnsLabel = New-Object System.Windows.Forms.Label
$dnsLabel.Text = "DNS Mode"
$dnsLabel.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$dnsLabel.ForeColor = $textSecondary
$dnsLabel.Location = New-Object System.Drawing.Point(15, 10)
$dnsLabel.Size = New-Object System.Drawing.Size(80, 20)
$dnsPanel.Controls.Add($dnsLabel)

$dnsDropdown = New-Object System.Windows.Forms.ComboBox
$dnsDropdown.Location = New-Object System.Drawing.Point(100, 8)
$dnsDropdown.Size = New-Object System.Drawing.Size(230, 24)
$dnsDropdown.Items.AddRange(@("automatic", "off", "secure", "custom"))
$dnsDropdown.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$dnsDropdown.BackColor = $cardColor
$dnsDropdown.ForeColor = $textPrimary
$dnsDropdown.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$dnsPanel.Controls.Add($dnsDropdown)

# Action buttons
$buttonY = 20
$buttonX = 400
$buttons = @(
    @{Text = "Import"; Width = 120; Color = $textSecondary},
    @{Text = "Export"; Width = 120; Color = $textSecondary},
    @{Text = "Apply All"; Width = 140; Color = $accentGreen},
    @{Text = "Reset"; Width = 120; Color = $accentRed}
)

foreach ($btn in $buttons) {
    $actionBtn = New-Object System.Windows.Forms.Button
    $actionBtn.Text = $btn.Text
    $actionBtn.Font = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
    $actionBtn.ForeColor = $textPrimary
    $actionBtn.BackColor = $cardColor
    $actionBtn.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
    $actionBtn.FlatAppearance.BorderSize = 2
    $actionBtn.FlatAppearance.BorderColor = $btn.Color
    $actionBtn.Size = New-Object System.Drawing.Size($btn.Width, 40)
    $actionBtn.Location = New-Object System.Drawing.Point($buttonX, $buttonY)
    $footer.Controls.Add($actionBtn)
    $buttonX += $btn.Width + 20
}

# Preset buttons
$presetY = 70
$presetX = 30
$presets = @(
    @{Text = "Maximum Privacy"; Tag = "max_privacy"},
    @{Text = "Balanced"; Tag = "balanced"},
    @{Text = "Performance"; Tag = "performance"},
    @{Text = "Ultimate Privacy"; Tag = "ultimate"}
)

foreach ($preset in $presets) {
    $presetBtn = New-Object System.Windows.Forms.Button
    $presetBtn.Text = $preset.Text
    $presetBtn.Tag = $preset.Tag
    $presetBtn.Font = New-Object System.Drawing.Font("Segoe UI", 10)
    $presetBtn.ForeColor = $textPrimary
    $presetBtn.BackColor = $primaryColor
    $presetBtn.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
    $presetBtn.FlatAppearance.BorderSize = 0
    $presetBtn.Size = New-Object System.Drawing.Size(140, 35)
    $presetBtn.Location = New-Object System.Drawing.Point($presetX, $presetY)
    $footer.Controls.Add($presetBtn)
    $presetX += 150
}

# Features data structure
$script:allFeatures = New-Object System.Collections.Generic.List[System.Windows.Forms.CheckBox]
$featureCategories = @{
    privacy = @(
        @{ Name = "Disable Safe Browsing"; Key = "SafeBrowsingProtectionLevel"; Value = 0; Type = "DWord"; Description = "Disables Google Safe Browsing protection" },
        @{ Name = "Disable Autofill (Addresses)"; Key = "AutofillAddressEnabled"; Value = 0; Type = "DWord"; Description = "Prevents saving and autofilling addresses" },
        @{ Name = "Disable Autofill (Credit Cards)"; Key = "AutofillCreditCardEnabled"; Value = 0; Type = "DWord"; Description = "Prevents saving and autofilling credit card info" },
        @{ Name = "Disable Password Manager"; Key = "PasswordManagerEnabled"; Value = 0; Type = "DWord"; Description = "Disables built-in password manager" },
        @{ Name = "Disable Browser Sign-in"; Key = "BrowserSignin"; Value = 0; Type = "DWord"; Description = "Prevents browser account sign-in" },
        @{ Name = "Disable WebRTC IP Leak"; Key = "WebRtcIPHandling"; Value = "disable_non_proxied_udp"; Type = "String"; Description = "Prevents IP leaks through WebRTC" },
        @{ Name = "Disable QUIC Protocol"; Key = "QuicAllowed"; Value = 0; Type = "DWord"; Description = "Disables experimental QUIC protocol" },
        @{ Name = "Block Third Party Cookies"; Key = "BlockThirdPartyCookies"; Value = 1; Type = "DWord"; Description = "Blocks all third-party cookies" },
        @{ Name = "Enable Do Not Track"; Key = "EnableDoNotTrack"; Value = 1; Type = "DWord"; Description = "Sends Do Not Track header" },
        @{ Name = "Force Google SafeSearch"; Key = "ForceGoogleSafeSearch"; Value = 1; Type = "DWord"; Description = "Enforces SafeSearch on Google" },
        @{ Name = "Disable IPFS"; Key = "IPFSEnabled"; Value = 0; Type = "DWord"; Description = "Disables InterPlanetary File System" },
        @{ Name = "Disable Hardware Acceleration"; Key = "HardwareAccelerationModeEnabled"; Value = 0; Type = "DWord"; Description = "Disables GPU acceleration" },
        @{ Name = "Disable WebGL"; Key = "WebGLDisabled"; Value = 1; Type = "DWord"; Description = "Disables WebGL for security" },
        @{ Name = "Disable WebAssembly"; Key = "WebAssemblyDisabled"; Value = 1; Type = "DWord"; Description = "Disables WebAssembly execution" },
        @{ Name = "Disable Push Notifications"; Key = "DefaultNotificationsSetting"; Value = 2; Type = "DWord"; Description = "Blocks all push notifications" },
        @{ Name = "Disable Geolocation"; Key = "DefaultGeolocationSetting"; Value = 2; Type = "DWord"; Description = "Blocks location access" },
        @{ Name = "Disable Camera Access"; Key = "VideoCaptureAllowed"; Value = 0; Type = "DWord"; Description = "Blocks camera access" },
        @{ Name = "Disable Microphone Access"; Key = "AudioCaptureAllowed"; Value = 0; Type = "DWord"; Description = "Blocks microphone access" }
    )
    telemetry = @(
        @{ Name = "Disable Metrics Reporting"; Key = "MetricsReportingEnabled"; Value = 0; Type = "DWord"; Description = "Stops usage metrics collection" },
        @{ Name = "Disable Safe Browsing Reporting"; Key = "SafeBrowsingExtendedReportingEnabled"; Value = 0; Type = "DWord"; Description = "Stops extended safe browsing reports" },
        @{ Name = "Disable URL Data Collection"; Key = "UrlKeyedAnonymizedDataCollectionEnabled"; Value = 0; Type = "DWord"; Description = "Prevents URL-based data collection" },
        @{ Name = "Disable Feedback Surveys"; Key = "FeedbackSurveysEnabled"; Value = 0; Type = "DWord"; Description = "Blocks feedback survey prompts" }
    )
    brave = @(
        @{ Name = "Disable Brave Rewards"; Key = "BraveRewardsDisabled"; Value = 1; Type = "DWord"; Description = "Disables cryptocurrency rewards system" },
        @{ Name = "Disable Brave Wallet"; Key = "BraveWalletDisabled"; Value = 1; Type = "DWord"; Description = "Disables crypto wallet feature" },
        @{ Name = "Disable Brave VPN"; Key = "BraveVPNDisabled"; Value = 1; Type = "DWord"; Description = "Disables built-in VPN feature" },
        @{ Name = "Disable Brave AI Chat"; Key = "BraveAIChatEnabled"; Value = 0; Type = "DWord"; Description = "Disables AI chat assistant" },
        @{ Name = "Disable Brave News"; Key = "BraveNewsEnabled"; Value = 0; Type = "DWord"; Description = "Disables news feed" },
        @{ Name = "Disable Sidebar"; Key = "SidebarEnabled"; Value = 0; Type = "DWord"; Description = "Removes sidebar feature" },
        @{ Name = "Disable Leo AI Assistant"; Key = "LeoAIAssistantEnabled"; Value = 0; Type = "DWord"; Description = "Disables Leo AI features" }
    )
    performance = @(
        @{ Name = "Disable Background Mode"; Key = "BackgroundModeEnabled"; Value = 0; Type = "DWord"; Description = "Prevents running in background" },
        @{ Name = "Disable Media Recommendations"; Key = "MediaRecommendationsEnabled"; Value = 0; Type = "DWord"; Description = "Stops media suggestions" },
        @{ Name = "Disable Preloading"; Key = "NetworkPredictionOptions"; Value = 2; Type = "DWord"; Description = "Disables page preloading" },
        @{ Name = "Disable Background Sync"; Key = "BackgroundSyncEnabled"; Value = 0; Type = "DWord"; Description = "Prevents background data sync" },
        @{ Name = "Disable AutoPlay"; Key = "AutoplayPolicy"; Value = 2; Type = "DWord"; Description = "Blocks media autoplay" }
    )
    advanced = @(
        @{ Name = "Disable Developer Tools"; Key = "DeveloperToolsDisabled"; Value = 1; Type = "DWord"; Description = "Blocks developer tools access" },
        @{ Name = "Disable Printing"; Key = "PrintingEnabled"; Value = 0; Type = "DWord"; Description = "Disables printing functionality" },
        @{ Name = "Disable Incognito Mode"; Key = "IncognitoModeAvailability"; Value = 1; Type = "DWord"; Description = "Removes private browsing option" },
        @{ Name = "Always Open PDF Externally"; Key = "AlwaysOpenPdfExternally"; Value = 1; Type = "DWord"; Description = "Forces PDFs to open in external app" }
    )
}

# Create feature cards
function Create-FeatureCard {
    param($feature, $parent, $x, $y)
    
    $card = New-Object System.Windows.Forms.Panel
    $card.Size = New-Object System.Drawing.Size(450, 100)
    $card.Location = New-Object System.Drawing.Point($x, $y)
    $card.BackColor = $cardColor
    $parent.Controls.Add($card)
    
    $checkbox = New-Object System.Windows.Forms.CheckBox
    $checkbox.Size = New-Object System.Drawing.Size(20, 20)
    $checkbox.Location = New-Object System.Drawing.Point(20, 40)
    $checkbox.Tag = $feature
    $card.Controls.Add($checkbox)
    
    $nameLabel = New-Object System.Windows.Forms.Label
    $nameLabel.Text = $feature.Name
    $nameLabel.Font = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
    $nameLabel.ForeColor = $textPrimary
    $nameLabel.Location = New-Object System.Drawing.Point(50, 20)
    $nameLabel.Size = New-Object System.Drawing.Size(380, 25)
    $card.Controls.Add($nameLabel)
    
    $descLabel = New-Object System.Windows.Forms.Label
    $descLabel.Text = $feature.Description
    $descLabel.Font = New-Object System.Drawing.Font("Segoe UI", 9)
    $descLabel.ForeColor = $textSecondary
    $descLabel.Location = New-Object System.Drawing.Point(50, 50)
    $descLabel.Size = New-Object System.Drawing.Size(380, 40)
    $card.Controls.Add($descLabel)
    
    return $checkbox
}

# Show category content
function Show-Category {
    param($category)
    
    $contentPanel.Controls.Clear()
    $script:allFeatures.Clear()
    $x = 10
    $y = 10
    $col = 0
    
    foreach ($feature in $featureCategories[$category]) {
        $checkbox = Create-FeatureCard -feature $feature -parent $contentPanel -x $x -y $y
        $script:allFeatures.Add($checkbox) | Out-Null
        $checkbox.add_CheckedChanged({ Update-Counts })
        
        $col++
        if ($col -eq 2) {
            $col = 0
            $x = 10
            $y += 110
        } else {
            $x += 460
        }
    }
}

# Initialize with first category
Show-Category -category "privacy"
$categoryButtons[0].BackColor = $primaryColor

# Category button clicks
foreach ($btn in $categoryButtons) {
    $btn.Add_Click({
        foreach ($b in $categoryButtons) {
            $b.BackColor = $surfaceColor
        }
        $this.BackColor = $primaryColor
        Show-Category -category $this.Tag
    })
}

# Update counters
function Update-Counts {
    $selected = ($script:allFeatures | Where-Object { $_.Checked }).Count
    $total = $script:allFeatures.Count
    $selectedCount.Text = "$selected / $total"
    
    # Check applied settings
    $applied = 0
    foreach ($cb in $script:allFeatures) {
        if ($cb.Tag) {
            try {
                $current = (Get-ItemProperty -Path $registryPath -Name $cb.Tag.Key -ErrorAction SilentlyContinue).$($cb.Tag.Key)
                if ($null -ne $current -and $current -eq $cb.Tag.Value) {
                    $applied++
                }
            } catch {}
        }
    }
    $appliedCount.Text = "$applied"
}

# Search functionality
$searchBox.add_TextChanged({
    $query = $searchBox.Text.ToLower()
    foreach ($ctrl in $contentPanel.Controls) {
        if ($ctrl -is [System.Windows.Forms.Panel]) {
            $checkbox = $ctrl.Controls | Where-Object { $_ -is [System.Windows.Forms.CheckBox] }
            if ($checkbox) {
                $visible = $checkbox.Tag.Name.ToLower().Contains($query) -or 
                          $checkbox.Tag.Description.ToLower().Contains($query)
                $ctrl.Visible = $visible
            }
        }
    }
    Update-Counts
})

# Initialize
Update-Counts

[void] $form.ShowDialog()
