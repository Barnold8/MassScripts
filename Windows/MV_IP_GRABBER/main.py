# Script to get IPV4 address for mullvad VPN connection so I can bind it to my torrenting software easily in Windows

import subprocess
import sys

MULLVAD_NAME = "Mullvad"


def eprint(*args, **kwargs): # with thanks to https://stackoverflow.com/questions/5574702/how-do-i-print-to-stderr-in-python 
    print(*args, file=sys.stderr, **kwargs)

if __name__ == "__main__":

    ip_text = subprocess.check_output(['ipconfig']).decode("utf-8") # call ipconfig and convert to string from bytes
    strings = ip_text.split("\n")



