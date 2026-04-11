# Script to get IPV4 address for mullvad VPN connection so I can bind it to my torrenting software easily in Windows

import os 


if __name__ == "__main__":

    ip_text = os.system("ipconfig")
    print()

