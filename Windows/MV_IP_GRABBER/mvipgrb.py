# Script to get IPV4 address for mullvad VPN connection so I can bind it to my torrenting software easily in Windows

import subprocess
import sys
import re
import os


MULLVAD_NAME = "mullvad"
IPV4 = "IPv4 Address"
IP_REGEX = re.compile(r'(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})')
IP_MIN_CHAR_LEN = 7

def eprint(*args, **kwargs): # with thanks to https://stackoverflow.com/questions/5574702/how-do-i-print-to-stderr-in-python 
    print(*args, file=sys.stderr, **kwargs)

def printHelp():
    print("""
Help for setting the VPN address on bit torrent
        
    1.  Open BitTorrent 7.11.

    2.  Go to Options > Preferences.

    3.  In the left-hand menu, click on Advanced.

    4.  In the "Filter" box at the top right, type: net.bind_ip

    5.  Click on the result net.bind_ip and, in the Value field below, paste the Mullvad IPv4 address you found in Phase 1.

    6.  Click Set.

    7.  Now, type net.outgoing_port or net.outgoing_ip in the filter box.

    8.  Select net.outgoing_ip, paste the same Mullvad IP into the Value field, and click Set.

    9.  Click Apply and OK.

    10. Restart BitTorrent (fully exit from the system tray and reopen).
    """)

if __name__ == "__main__":

    ip_text = subprocess.check_output(['ipconfig']).decode("utf-8") # call ipconfig and convert to string from bytes
    strings = ip_text.split("\n")
    mullvad_string = ""
    found = False

    for newline in strings:
        lowered = newline.lower()

        if mullvad_string in lowered:
            found = True

        if found and "ipv4 address" in lowered:
            match = IP_REGEX.search(newline)
            if match:
                mullvad_string = match.group()
                break

    
    if found and len(mullvad_string) < IP_MIN_CHAR_LEN:
        eprint("Error: found mullvad vpn adapter but couldnt find corresponding IPV4 address, try disconnecting and reconnecting to the VPN")
    elif found == False:
        eprint("Error: could not find mullvad vpn adapter, make sure you are connected to mullvad")
        print(mullvad_string,found)
    else:
        os.system(f"echo {mullvad_string} | clip")
        printHelp()