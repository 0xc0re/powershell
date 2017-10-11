$Users = @(
"Brian.Haynes",
"Brian.Hill",
"Butch.Jamieson",
"Carla.Larrieu",
"Chamoan.Greene",
"Cole.Gonet",
"Dan.Heath",
"Dana.Conley",
"David.Beagles",
"Edward.Young",
"Emily.Abee",
"Erica.Frye",
"Farrah.Stanford",
"Finnessa.Sandy",
"Glen.Ernst",
"Jamie.Rockwood",
"Jason.Allen",
"Jenifer.Terry",
"Jenna.Sadler",
"Jocelyn.Mennenga",
"Julie.Lillback",
"Kate.Short",
"Kyle.Sowers",
"Larry.Forrest",
"Leon.Putman",
"Marina.Peters",
"Mark.Holoman",
"Melissa.Wilder",
"Michael.McDonald",
"Nathan.Beam",
"Nicole.Simmons",
"Reinaldo.Torres",
"Sam.Watson"
)

$Users | foreach {
    Write-Host $_ -ForegroundColor White
    set-ADUser -Identity $_ -Replace @{"msDS-cloudExtensionAttribute1"='TRUE'}
}