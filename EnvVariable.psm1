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
    [Environment]::SetEnvironmentVariable($name, $value, "Machine")

    Write-Verbose "$($path) = $($value)"
  }
}

function Add-Path
{
  param (
    [Parameter(Mandatory=$False,Position=1)]
    [Object]$dir = $(Get-Location),
    [Parameter(Mandatory=$False,Position=2)]
    [Switch]$Global = $FALSE
  )
  process {
    $dir = $(Resolve-Path $dir).Path
    if(-not (Test-InPath $dir)) {
      $env:Path += ";$($dir)"

      # GLOBAL PATH
      if($Global) {
        $Path  = [System.Environment]::GetEnvironmentVariable("Path", "Machine")
        Set-Env "Path" "$($Path);$($dir)"
      }

      Write-Verbose "$($dir) :: Added to Path"
    } else {
      Write-Verbose "$($dir) :: Already in Path"
    }
  }
}

function Test-InPath
{
  param(
    [Parameter(Mandatory=$False,Position=1)]
    [Object]$dir = $(Get-Location)
  )
  process {
    foreach($path in $env:Path.split(';')) {
      if($path -eq $dir) {
        return $TRUE
      }
    }
    return $FALSE
  }
}

Export-ModuleMember Set-Env
Export-ModuleMember Add-Path
Export-ModuleMember Test-InPath
