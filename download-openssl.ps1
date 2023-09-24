cd .\vendor

if (Test-Path '.\openssl-1.1') {
  rm -r '.\openssl-1.1'
}

$resp = Invoke-WebRequest -Uri 'https://kb.firedaemon.com/support/solutions/articles/4000121705#Download-OpenSSL'
$found = $resp.RawContent -match 'https://download\.firedaemon\.com/FireDaemon-OpenSSL/openssl-1\.1\.1[^\"]+\.zip'
if ($found) {
  Invoke-WebRequest -Uri $matches[0] -OutFile openssl.zip
  Expand-Archive openssl.zip -DestinationPath .
  rm openssl.zip
  rm README.txt
}
