function proxy {
    $proxyAddr = "127.0.0.1:10808"
    $socksAddr = "socks5://$proxyAddr"
    
    Write-Host "Enabling V2Ray proxy..." -ForegroundColor Green

    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" `
        -Name ProxyEnable -Value 1
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" `
        -Name ProxyServer -Value "socks5=$proxyAddr" 

    $env:HTTP_PROXY = $socksAddr
    $env:HTTPS_PROXY = $socksAddr
    $env:SOCKS_PROXY = $socksAddr
    $env:ALL_PROXY = $socksAddr

    [Environment]::SetEnvironmentVariable("HTTP_PROXY", $socksAddr, "User")
    [Environment]::SetEnvironmentVariable("HTTPS_PROXY", $socksAddr, "User")

    if (Get-Command git -ErrorAction SilentlyContinue) {
        git config --global http.proxy $socksAddr
        git config --global https.proxy $socksAddr
    }

    Write-Host "✓ Proxy enabled: $proxyAddr" -ForegroundColor Cyan
}

function noproxy {
    Write-Host "Disabling proxy..." -ForegroundColor Yellow

    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" `
        -Name ProxyEnable -Value 0
    Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" `
        -Name ProxyServer -ErrorAction SilentlyContinue

    $env:HTTP_PROXY = $null
    $env:HTTPS_PROXY = $null
    $env:SOCKS_PROXY = $null
    $env:ALL_PROXY = $null

    [Environment]::SetEnvironmentVariable("HTTP_PROXY", $null, "User")
    [Environment]::SetEnvironmentVariable("HTTPS_PROXY", $null, "User")

    if (Get-Command git -ErrorAction SilentlyContinue) {
        git config --global --unset http.proxy
        git config --global --unset https.proxy
    }

    Write-Host "✓ Proxy disabled" -ForegroundColor Green
}

Write-Host "Usage:" -ForegroundColor Magenta
Write-Host "   proxy      - Enable V2Ray proxy" -ForegroundColor White
Write-Host "   noproxy    - Disable proxy" -ForegroundColor White