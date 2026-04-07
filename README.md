🧩 User AD Groups Lookup Utility<br>
A lightweight PowerShell GUI tool that retrieves a user’s Active Directory group memberships across a selected domain.

📌 Features<br>
- Clean and simple Windows Forms GUI
- Lookup AD user information:
- Display Name
- SAM Account Name
- Retrieve all AD group memberships
- Supports multiple domains via dropdown selection
- Uses Global Catalog for cross-domain group resolution
- Scrollable output windows for easy reading
- Console window hidden for a cleaner user experience

🛠️ Requirements<br>
- PowerShell 7.x
- ActiveDirectory module
- Install via RSAT or:
Install-WindowsFeature RSAT-AD-PowerShell
- Windows OS with .NET Framework support for WinForms

🚀 How to Use<br>
- Download or clone the repository.
- Unblock the script if needed:
Unblock-File .\UserADGroupsUtility.ps1
- Run the script:
pwsh .\UserADGroupsUtility.ps1
- In the GUI:
- Enter a User ID
- Select a domain
- Click Search
- The top output box displays user information.
The bottom output box displays all AD groups the user belongs to.

🌐 Domain Configuration<br>
The script includes generic placeholder domains:
$Domains = @(
    "domain1.local",
    "domain2.corp",
    "example.org",
    "testlab.local"
)

Replace these with your actual internal domains when deploying in your environment.

📄 Script Behavior<br>
✔ Retrieves user attributes
The script queries AD for:
- DisplayName
- SamAccountName
You can add more attributes as needed.
✔ Retrieves group memberships
Uses the Global Catalog (:3268) to ensure cross-domain group resolution.
✔ Handles errors gracefully
- User not found
- Domain connection issues
- Invalid input

🧪 Example Output<br>
User Info Box:<br>
Name: John Doe
SAM Account: jdoe

Group List Box:<br>
Domain Users
HR-Access
VPN-Users
Workstation-Admins

🧩 Customization Options<br>
You can easily modify:
- Domain list
- Displayed user attributes
- GUI layout (fonts, sizes, labels)
- Group sorting or filtering
- Error messages

📷 Screenshot <br><br>
<img width="225" height="303" alt="image" src="https://github.com/user-attachments/assets/e7b589e3-42d2-45ff-9e7f-a377385c59cf" />

📄 License<br>
- You may release this project under any license you prefer (MIT recommended).

🤝 Contributing<br>
- Contributions, suggestions, and improvements are welcome.
- Feel free to open an issue or submit a pull request.
