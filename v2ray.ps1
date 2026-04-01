function proxy {
    $httpAddr = "127.0.0.1:7890"
    $socksAddr = "socks5://127.0.0.1:7891"
    $httpProxy = "http://$httpAddr"
    
    Write-Host "Enabling Clash proxy..." -ForegroundColor Green

    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" `
        -Name ProxyEnable -Value 1
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" `
        -Name ProxyServer -Value $httpAddr

    $env:HTTP_PROXY = $httpProxy
    $env:HTTPS_PROXY = $httpProxy
    $env:SOCKS_PROXY = $socksAddr
    $env:ALL_PROXY = $socksAddr

    [Environment]::SetEnvironmentVariable("HTTP_PROXY", $httpProxy, "User")
    [Environment]::SetEnvironmentVariable("HTTPS_PROXY", $httpProxy, "User")

    if (Get-Command git -ErrorAction SilentlyContinue) {
        git config --global http.proxy $httpProxy
        git config --global https.proxy $httpProxy
    }

    Write-Host "✓ Proxy enabled: HTTP=$httpAddr, SOCKS5=7891" -ForegroundColor Cyan
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
Write-Host "   proxy      - Enable Clash proxy" -ForegroundColor White
Write-Host "   noproxy    - Disable proxy" -ForegroundColor White