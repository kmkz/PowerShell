# Fix for the SSPR for priv. accounts issue on Azure Entra ID
# Ref.: https://www.cswrld.com/2024/11/how-to-disable-self-service-password-reset-for-administrators/
 
#Import-Module Microsoft.Graph
Import-Module Microsoft.Graph.Identity.SignIns

# Microsoft Graph with the right scopes
# account role should be "Global Administrator" or "Cloud Administrator"
Connect-MgGraph -Scopes "Policy.ReadWrite.Authorization"

# Connection check
Get-MgContext

# Build parameters
$params = @{
   	allowEmailVerifiedUsersToJoinOrganization = $false
	AllowedToUseSspr = $false
}

# Tenant's policy update
Update-MgPolicyAuthorizationPolicy -BodyParameter $params

# Confirm policy is well applied
Get-MgPolicyAuthorizationPolicy
