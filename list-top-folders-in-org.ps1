<#
.SYNOPSIS
    Outputs top level folders in a given Orgnode.
.DESCRIPTION
    Outputs top level folders in a given Orgnode.
    Dependency on gcloud command.  Tested on Powershell for Mac.
.PARAMETER orgname
    Name of the organization.  Parameter is matching the DISPLAY_NAME
    output from gcloud organizations list
.PARAMETER outfile
    Path to output file.  The format will be CSV.
#>

param (
    [Parameter(Mandatory=$true, Position=0)]
    [string]$orgname,
    [switch]$bq = $false
)

# Look up the org id
$orgnumber = gcloud organizations list --filter="displayName~^$orgname" --format="value(name)"

# Check if we found the organization
if ([string]::IsNullOrEmpty($orgnumber))
{
    Write-Host ("ERROR: Organization {0} not found.  Exiting..." -f $orgname)
    exit 1
}

# Get the list of top level folders in the org
[array]$folders = gcloud resource-manager folders list --organization $orgnumber --format json | ConvertFrom-Json


if ($bq) {
    [string] $output
    $output += 'INSERT INTO `myproject.mydataset.gcp_folder`'
    $output += "`n(ancestry_number, name) VALUES"
    foreach ($folder in $folders)
    {
        $output += '{2}("{0}","{1}")' -f $folder.name.split("/")[1],$folder.displayName,"`n"
        if ($folder -ne $folders[-1]) {$output += ","}
    }

    write-host $output

} else {
    foreach ($folder in $folders)
    {
        write-host ('"{0}","{1}"' -f $folder.name.split("/")[1],$folder.displayName)
    }
}