import winim
import std/os
import std/strutils  # Pour convertir la chaîne en entier

var puke = "\x41\x41\x41\x41\x41\x41\x41\x41\x41\x41\x41\x41\x41\x41\x41\x41\x41\x41\x41\x41\x41\x41\x41\x41\x41\x41\x41"

# Convertir le paramètre en entier (ID de processus)
var processId = paramStr(1).parseInt().DWORD

var hProcess = OpenProcess(PROCESS_ALL_ACCESS, FALSE, processId)
echo "You got a handle on : ", hProcess, " !"


var rBuffer = VirtualAllocEx(hProcess, NULL, sizeof(puke), (MEM_COMMIT or MEM_RESERVE), PAGE_EXECUTE_READWRITE)
echo "Allocated with ", sizeof(puke), " bytes"
echo "valeur de retour : 0x", toHex(cast[int](rBuffer))

