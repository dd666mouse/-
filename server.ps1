$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add('http://localhost:8000/')
$listener.Start()
Write-Host 'Server started at http://localhost:8000/' -ForegroundColor Green
Write-Host 'Press Ctrl+C to stop' -ForegroundColor Yellow

while ($listener.IsListening) {
    $context = $listener.GetContext()
    $request = $context.Request
    $response = $context.Response
    
    $localPath = $request.Url.LocalPath.TrimStart('/')
    if ([string]::IsNullOrEmpty($localPath)) {
        $localPath = 'index.html'
    }
    
    $filePath = Join-Path $PWD $localPath
    
    if ([System.IO.File]::Exists($filePath)) {
        $extension = [System.IO.Path]::GetExtension($filePath)
        switch ($extension) {
            '.html' { $response.ContentType = 'text/html; charset=utf-8' }
            '.css'  { $response.ContentType = 'text/css; charset=utf-8' }
            '.js'   { $response.ContentType = 'application/javascript; charset=utf-8' }
            '.json' { $response.ContentType = 'application/json; charset=utf-8' }
            '.png'  { $response.ContentType = 'image/png' }
            '.jpg'  { $response.ContentType = 'image/jpeg' }
            '.jpeg' { $response.ContentType = 'image/jpeg' }
            '.gif'  { $response.ContentType = 'image/gif' }
            '.svg'  { $response.ContentType = 'image/svg+xml' }
            '.ico'  { $response.ContentType = 'image/x-icon' }
            default { $response.ContentType = 'text/plain; charset=utf-8' }
        }
        
        $content = [System.IO.File]::ReadAllBytes($filePath)
        $response.ContentLength64 = $content.Length
        $response.OutputStream.Write($content, 0, $content.Length)
        Write-Host "200 $localPath" -ForegroundColor Green
    } else {
        $response.StatusCode = 404
        $errorMsg = [System.Text.Encoding]::UTF8.GetBytes('Not Found')
        $response.ContentLength64 = $errorMsg.Length
        $response.OutputStream.Write($errorMsg, 0, $errorMsg.Length)
        Write-Host "404 $localPath" -ForegroundColor Red
    }
    
    $response.Close()
}
