$latestVersion = [string](((Invoke-RestMethod -Uri https://releases.hashicorp.com/packer/) -split "\n" | select-string -pattern "(\d+\.){2,3}\d+" | foreach {$_.matches} | select -expandproperty value) | %{[System.Version]$_} | sort | select -last 1)
$url = "https://releases.hashicorp.com/packer/$latestVersion/packer_$latestVersion_windows_amd64.zip"
$output = "$PSScriptRoot\packer.zip"

(New-Object System.Net.WebClient).DownloadFile($url, $output)
$extractPath = (get-item $PSScriptRoot).parent.FullName
$shell = new-object -com shell.application
$zip = $shell.NameSpace($output)
foreach($item in $zip.items()) {
	$shell.Namespace("$extractPath").copyhere($item)
}