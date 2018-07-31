# Micael Pedersen, SUND-IT
# Prompt for username and password
# Mapdrive afterwards
# Share variable from parameter call of mapdriveLAB.cmd
# Mapdrive parameter inserted in shortcut
# mapdriveLAB.cmd calls mapdriveLAB.ps1
# ex. C:\Windows\Scripts\SUNDLAB\MAPDriveLAB.cmd \\sund.root.ku.dk\groups\BRIC\ftp


##################################################################
###                    Create VARIABLES BELOW                  ###

$shortname = "LABDATA"
$Drive = "L:"

##################################################################
###   If serviceaccount need to be used, seldome used          ###

#$username = 
#$PlainPassword = 
##################################################################



##################################################################
###                     DO NOT EDIT BELOW                      ###
##################################################################

$share = $Args[0]
if (!$share) {
echo "No share defined as argument for the script"
exit
}


If (!$username) {
  $userid = Read-Host -Prompt "Enter KU-username"
  $username = "sund\$userid"

  $SecurePassword = Read-Host -Prompt "Enter password" -AsSecureString
  $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecurePassword)
  $PlainPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
}


# new-psdrive demand persist, new-smbmapping only from win10 ?, issue with persistent (not shown i explorer ?
#New-PSDrive -name "L:" -psprovider filesystem -root $share -persist
#New-SmbMapping -LocalPath $drive -RemotePath $share -username $username -Password $PlainPassword -persistent $true

net use * /del /y
net use $drive $share /user:$username $PlainPassword

if (test-path $drive) {
  $sh=New-Object -com Shell.Application
  $sh.NameSpace($drive).Self.Name = $shortname
  Add-Type -AssemblyName PresentationFramework
  [System.Windows.MessageBox]::Show("Data can now be saved to " + $shortname + " on drive " +$drive,"SUND-IT", 'ok',64)
}

if (!(test-path $drive)) {
  Add-Type -AssemblyName PresentationFramework
  [System.Windows.MessageBox]::Show("Drive NOT mapped, did you type correct username and password!","SUND-IT", 'ok',64)
}
