# Script: UserADGroupsUtility.ps1
# Version: 1.0.0 (Generic Public Version)
# Created: 07/07/2025
# Author: Saeed Rather

# This version has been sanitized for public sharing.
# No internal domains, no sensitive attributes, no proprietary identifiers.

# Hide Console Window
Add-Type -Name Win32 -Namespace Console -MemberDefinition @"
    [DllImport("user32.dll")]
    public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
    [DllImport("kernel32.dll")]
    public static extern IntPtr GetConsoleWindow();
"@

$consolePtr = [Console.Win32]::GetConsoleWindow()
[Console.Win32]::ShowWindow($consolePtr, 0)   # 0 = Hide

Add-Type -AssemblyName System.Windows.Forms

# Form
$form = New-Object System.Windows.Forms.Form
$form.Text = "AD Groups Lookup Utility"
$form.Size = New-Object System.Drawing.Size(600, 650)
$form.StartPosition = "CenterScreen"

# Label: User ID
$label = New-Object System.Windows.Forms.Label
$label.Text = "Enter User ID:"
$label.Location = New-Object System.Drawing.Point(10, 20)
$label.Size = New-Object System.Drawing.Size(200, 20)
$form.Controls.Add($label)

# Input Textbox
$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Location = New-Object System.Drawing.Point(220, 20)
$textBox.Size = New-Object System.Drawing.Size(330, 20)
$form.Controls.Add($textBox)

# Output Box 1 (User Info)
$resultsBox1 = New-Object System.Windows.Forms.TextBox
$resultsBox1.Location = New-Object System.Drawing.Point(10, 80)
$resultsBox1.Size = New-Object System.Drawing.Size(550, 55)
$resultsBox1.Multiline = $true
$resultsBox1.ScrollBars = "Vertical"
$form.Controls.Add($resultsBox1)

# Output Box 2 (Group List)
$resultsBox2 = New-Object System.Windows.Forms.TextBox
$resultsBox2.Location = New-Object System.Drawing.Point(10, 140)
$resultsBox2.Size = New-Object System.Drawing.Size(550, 460)
$resultsBox2.Multiline = $true
$resultsBox2.ScrollBars = "Vertical"
$form.Controls.Add($resultsBox2)

# Label: Domain Selection
$label2 = New-Object System.Windows.Forms.Label
$label2.Text = "Select Domain:"
$label2.Location = New-Object System.Drawing.Point(10, 45)
$label2.Size = New-Object System.Drawing.Size(200, 20)
$form.Controls.Add($label2)

# Domain Dropdown (Generic Example Domains)
$ComboBox1 = New-Object System.Windows.Forms.ComboBox
$ComboBox1.Location = New-Object System.Drawing.Point(220, 45)
$ComboBox1.Size = New-Object System.Drawing.Size(250, 20)

# Replace these with your own domains when using internally
$Domains = @(
    "domain1.local",
    "domain2.corp",
    "example.org",
    "testlab.local"
)

$ComboBox1.Items.AddRange($Domains)
$ComboBox1.SelectedIndex = 0
$form.Controls.Add($ComboBox1)

# Search Button
$button = New-Object System.Windows.Forms.Button
$button.Text = "Search"
$button.Location = New-Object System.Drawing.Point(475, 45)
$button.Size = New-Object System.Drawing.Size(75, 23)

$button.Add_Click({
    $resultsBox1.Clear()
    $resultsBox2.Clear()

    $UserID = $textBox.Text.Trim()
    $selected_domain = $ComboBox1.SelectedItem

    if ([string]::IsNullOrWhiteSpace($UserID)) {
        $resultsBox1.Text = "Please enter a valid User ID."
        return
    }

    try {
        # Generic AD attributes (safe for public use). You can add the required attributes based on your organisational needs.
        $User = Get-ADUser -Identity $UserID -Server $selected_domain -Properties DisplayName, SamAccountName

        $info_user = "Name: $($User.DisplayName)`r`n" +
                     "SAM Account: $($User.SamAccountName)"

        # Query Global Catalog
        $Server_AD_GC = ((Get-ADDomainController -DomainName $selected_domain -Discover -Service ADWS).hostname) + ":3268"

        $results = @(Get-ADUser $UserID -Server $Server_AD_GC -Properties memberof | ForEach-Object {
            $_.MemberOf | ForEach-Object {
                Get-ADGroup $_ -Server $Server_AD_GC | Select-Object @{n='Group';e={$_.Name}}
            }
        }) | Sort-Object Group

        $info = $results.Group -join "`r`n"
    }
    catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException] {
        $info_user = "User '$UserID' not found in domain '$selected_domain'."
    }
    catch {
        $info_user = "Error connecting to domain '$selected_domain':`r`n$($_.Exception.Message)"
    }

    $resultsBox1.Text = $info_user
    $resultsBox2.Text = $info
})

$form.Controls.Add($button)

[void]$form.ShowDialog()
