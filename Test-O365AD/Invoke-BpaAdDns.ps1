Get-BPAModel | Invoke-BPAModel

$ADRMS = "Microsoft/Windows/ADRMS"
$CertServices = "Microsoft/Windows/CertificateServices"
$DirectoryServices = "Microsoft/Windows/DirectoryServices"
$DNS = "Microsoft/Windows/DNSServer"
$LDS = "Microsoft/Windows/LightweightDirectoryServices"

Invoke-BPAModel -BestPracticesModelId $BPA -ErrorAction SilentlyContinue