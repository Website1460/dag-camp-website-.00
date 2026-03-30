$Listener = New-Object System.Net.HttpListener
$Listener.Prefixes.Add("http://localhost:8080/")
$Listener.Start()
Write-Host "Listening on http://localhost:8080/"

try {
    while ($Listener.IsListening) {
        $Context = $Listener.GetContext()
        $Request = $Context.Request
        $Response = $Context.Response
        
        $localPath = $Request.Url.LocalPath
        if ($localPath -eq "/") { $localPath = "/index.html" }
        
        $filePath = Join-Path $PWD.Path $localPath
        
        if (Test-Path $filePath -PathType Leaf) {
            $Content = [System.IO.File]::ReadAllBytes($filePath)
            $Response.ContentLength64 = $Content.Length
            $Response.OutputStream.Write($Content, 0, $Content.Length)
        } else {
            $Response.StatusCode = 404
        }
        $Response.Close()
    }
} finally {
    $Listener.Stop()
}
