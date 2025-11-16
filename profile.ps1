function proxy {
    $proxyAddr = "127.0.0.1:10808"
    Write-Host "Enabling V2Ray proxy..." -ForegroundColor Green

    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" -Name ProxyEnable -Value 1
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" -Name ProxyServer -Value "socks=$proxyAddr"

    $env:HTTP_PROXY = "http://$proxyAddr"
    $env:HTTPS_PROXY = "http://$proxyAddr"
    $env:SOCKS_PROXY = "socks5://$proxyAddr"
    $env:ALL_PROXY = "socks5://$proxyAddr"

    Write-Host "System and environment variable proxy enabled: $proxyAddr" -ForegroundColor Cyan
}

function noproxy {
    Write-Host "Disabling proxy..." -ForegroundColor Yellow

    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" -Name ProxyEnable -Value 0
    Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" -Name ProxyServer -ErrorAction SilentlyContinue

    $env:HTTP_PROXY = $null
    $env:HTTPS_PROXY = $null
    $env:SOCKS_PROXY = $null
    $env:ALL_PROXY = $null

    Write-Host "Proxy disabled" -ForegroundColor Green
}

Write-Host "Usage:" -ForegroundColor Magenta
Write-Host "   proxy      - Enable V2Ray proxy" -ForegroundColor White
Write-Host "   noproxy    - Disable proxy" -ForegroundColor White