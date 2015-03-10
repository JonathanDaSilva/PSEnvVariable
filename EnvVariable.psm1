function Set-Env
{
  param (
    [Parameter(Mandatory=$True,Position=1)]
    [String]$name  = "",
    [Parameter(Mandatory=$True,Position=2)]
    [String]$value = ""
  )
  process {
    $result = Resolve-Path $value -ErrorAction Ignore
    $path   = $("Env:\"+$name)

    Set-Content $path $value
    [Environment]::SetEnvironmentVariable($name, $value, [System.EnvironmentVariableTarget]::Machine)

    Write-Verbose "$($path) = $($value)"
  }
}

function Remove-Env
{
  param (
    [Parameter(Mandatory=$True,Position=1)]
    [String]$name = ""
  )
  $path = "Env:\"+$name
  if(-not $(Test-Path $path)) {
    Write-Verbose "$($path) :: Doesn't exist"
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
    Write-Verbose "$($dir) :: Added to Path"
  } else {
    Write-Verbose "$($dir) :: Already in Path"
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
    Write-Verbose "$($dir) :: Deleted for the path"
  } else {
    Write-Verbose "$($dir) :: Is not in the path"
  }
}

function Update-Path
{
  $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine")
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
Export-ModuleMember Update-Path
Export-ModuleMember Remove-Path
Export-ModuleMember Test-InPath
