$servername = "cid7157-dc02"
$domain = "davemungenast.com"
$subject = "CN=$servername.$domain,OU=IT,DC=davemungenast,DC=com,O=Mungenast,L=St.Louis,S=Missouri,C=US"

New-SelfSignedCertificate -Type SSLServerAuthentication -Subject $subject -DnsName "$servername.$domain", "$domain" -KeyAlgorithm RSA -KeyLength 4096 -CertStoreLocation "Cert:\LocalMachine\My" -NotAfter (Get-Date).AddYears(10) 
