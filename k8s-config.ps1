# k8s-config.ps1

$curfolder = Get-Location
$pathtofile = $curfolder.Path
$today = Get-Date -UFormat "%Y%m%d"

#If the k8s config does not exist, copy the new config file to $HOME\.kube\
if (-not(Test-Path -Path $HOME\.kube\config -PathType Leaf)) {
     try {
         Copy-Item "$pathtofile\kubeconfig" -Destination "$HOME\.kube\config"
         Write-Host "The k8s config has been created."
     }
     catch {
         throw $_.Exception.Message
     }
 }
# If the file already exists merge the old one and new one
 else {
     Write-Host "Merging existing config with new one."
     Write-Debug "Creating backup."
     Copy-Item "$HOME\.kube\config" -Destination "$HOME\.kube\config_backup$today"
     $env:KUBECONFIG="$HOME\.kube\config;$pathtofile\kubeconfig"
     $command = 'kubectl config view --raw | Out-File -FilePath .\config_tmp'
     Invoke-Expression -Command $command
     Remove-Item $HOME\.kube\config
     Move-Item .\config_tmp $HOME\.kube\config
 }
