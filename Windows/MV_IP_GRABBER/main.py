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