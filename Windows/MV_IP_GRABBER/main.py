# Script to get IPV4 address for mullvad VPN connection so I can bind it to my torrenting software easily in Windows

import os 
import sys

MULLVAD_NAME = "Mullvad"

if __name__ == "__main__":

    ip_text = os.system("ipconfig")
    
    try:
        mullvad_start = ip_text.index(MULLVAD_NAME)
    except ValueError as notFound:
        print()


