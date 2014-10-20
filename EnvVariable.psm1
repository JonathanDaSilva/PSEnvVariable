function Set-Env
{
  param (
    [Parameter(Mandatory=$True,Position=1)]
    [String]$name  = "",
    [Parameter(Mandatory=$True,Position=2)]
    [String]$value = ""
  )

  $value = Resolve-Path $value
  $path = $("Env:\"+$name)
  if(-not $(Test-Path $path)) {
    Set-Content $path $value
  } else {
    Set-Content $path $value
  }
  [Environment]::SetEnvironmentVariable($name, $value, [System.EnvironmentVariableTarget]::Machine)

  Write-Host "$($path) = $($value)" -ForegroundColor "green"
}

function Remove-Env
{
  param (
    [Parameter(Mandatory=$True,Position=1)]
    [String]$name = ""
  )
  $path = "Env:\"+$name
  if(-not $(Test-Path $path)) {
    Write-Host "$($path) :: Doesn't exist" -ForegroundColor "red"
  } else {
    Remove-Item $path -Force
  }
  [Environment]::SetEnvironmentVariable($name, $value, [System.EnvironmentVariableTarget]::Machine)
}

function Add-Path
{
  param (
    [Parameter(Mandatory=$False,Position=1)]
    [Object]$dir = $(Get-Location)
  )
  $dir = Resolve-Path $dir
  if(-not (Test-InPath $dir)) {
    $env:Path += ";$($dir)"
    [Environment]::SetEnvironmentVariable("Path", $env:Path, [System.EnvironmentVariableTarget]::Machine)
    Write-Host "$($dir) :: Added to Path" -ForegroundColor "green"
  } else {
    Write-Host "$($dir) :: Already in Path" -ForegroundColor "red"
  }
}

function Remove-Path
{
  param (
    [Parameter(Mandatory=$False,Position=1)]
    [Object]$dir = $(Get-Location)
  )
  if(Test-InPath) {
    $env:Path = $env:Path.replace($dir, '')
    $env:Path = $env:Path.replace(';;', ';')
    [Environment]::SetEnvironmentVariable("Path", $env:Path, [System.EnvironmentVariableTarget]::Machine)
    Write-Host "$($dir) :: Deleted for the path" -ForegroundColor "green"
  } else {
    Write-Host "$($dir) :: Is not in the path" -ForegroundColor "red"
  }
}

function Test-InPath
{
  param(
    [Parameter(Mandatory=$False,Position=1)]
    [Object]$dir = $(Get-Location)
  )
  foreach($path in $env:Path.split(';')) {
    if($path -eq $dir) {
      return $TRUE
    }
  }
  return $FALSE
}

Export-ModuleMember Set-Env
Export-ModuleMember Remove-Env
Export-ModuleMember Add-Path
Export-ModuleMember Remove-Path
Export-ModuleMember Test-InPath
