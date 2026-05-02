# Create temp folder
New-Item -ItemType Directory -Path C:\temp -Force

# Install IIS
Install-WindowsFeature -Name Web-Server -IncludeManagementTools

# Download .NET (direct link - stable)
Invoke-WebRequest https://download.visualstudio.microsoft.com/download/pr/7c2f4d7d-8d2d-4f93-a68b-7fd9a6d9a8a2/dotnet-runtime-8.0.0-win-x64.exe -OutFile C:\temp\dotnet.exe
Start-Process C:\temp\dotnet.exe -ArgumentList "/quiet" -Wait

# Clear IIS
Remove-Item -Recurse -Force C:\inetpub\wwwroot\* -ErrorAction SilentlyContinue

# Download web ZIP
Invoke-WebRequest https://github.com/cvbach/terraform-azure-secure-3tier-architecture/archive/refs/heads/main.zip -OutFile C:\temp\web.zip

# Extract
Expand-Archive C:\temp\web.zip -DestinationPath C:\temp\web -Force

# Find correct extracted folder
$webFolder = Get-ChildItem C:\temp\web | Where-Object {$_.PSIsContainer} | Select-Object -First 1

# Copy to IIS
Copy-Item -Recurse -Force "$($webFolder.FullName)\webapp\publish\*" C:\inetpub\wwwroot\

# Restart IIS
iisreset

# Debug hostname
$hostname = $env:COMPUTERNAME
Add-Content -Path "C:\inetpub\wwwroot\index.html" -Value "<h3>Served from $hostname</h3>"