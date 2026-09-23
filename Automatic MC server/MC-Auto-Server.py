from pathlib import Path
import time

try:
    from selenium import webdriver
    from selenium.webdriver.common.by import By
    
except ModuleNotFoundError as MNFE:
    print("Error while importing selenium module. Will be fixed with VENV")

import os
import sys
import subprocess

def restart():
    os.execv(sys.executable, ['python'] + sys.argv)

def get_running_path():
    path = os.path.abspath(__file__)
    path = path.split("\\")
    path = path[:-1]
    path = "\\".join(path)
    return path

class Browser:

    def __init__(self):
        try:

            options = webdriver.ChromeOptions()
            options.add_argument("--no-sandbox")
            options.add_argument("--disable-features=InsecureDownloadWarnings")
            options.add_argument("--unsafely-treat-insecure-origin-as-secure=https://www.minecraft.net/en-us/download/server")
            prefs = {"download.default_directory" : get_running_path(),
                    "download.prompt_for_download": False,
                    "download.directory_upgrade": True,
                    "safebrowsing.enabled": True
            }

            options.add_experimental_option("prefs",prefs)
            self.driver = webdriver.Chrome(options=options)

        except Exception as e:
            print(f"Error initialising chrome object, reason {e}")
            restart()

    def get_page(self,web_address : str) -> None:
        self.driver.get(web_address)

    def get_server_download(self,web_address:str,class_name:str):
        content = None
        self.get_page(web_address)
        content = self.driver.find_element(By.CLASS_NAME, class_name)
        return content

def is_dir(path:str) -> bool:
    return Path(path).is_dir()

def is_file(path:str) -> bool:
    return Path(path).is_file()

def init():

    REQUIREMENTS = "requirements.txt"
    with open(REQUIREMENTS,"w") as file:
        file.write("selenium")

    os.system(f"pip install -r {REQUIREMENTS}")

    os.remove(REQUIREMENTS)

def get_server(page_load:int=2,sleep:int=20):
    print("If the downloaded file is a .tmp, make sure to increase sleep value in \"get_server function\"")
    MC_PAGE      = "https://www.minecraft.net/en-us/download/server"
    DOWNLOAD_TAG = "MC_codeDefinition_downloadText"

    b = Browser()
    server_content = b.get_server_download(MC_PAGE,DOWNLOAD_TAG)
    time.sleep(page_load) # wait for page to load

    try:
        download_link = server_content.find_element(By.TAG_NAME, 'a')
    except Exception as wait_error:
        print(f"Error when reading download link for minecraft server.\nThis is usually because the page hasnt loaded fully before the page has been read.\nChange the page_load time in \"get_MC_page to wait longer\"\nError log:{wait_error} ")
        exit(-1)

    download_link.click()
    time.sleep(sleep)
    b.driver.close()

def verify_eula(sleep:int = 5):

    eula = False
    num = 0
    time.sleep(sleep)

    while not eula:
        print(num)
        num = num + 1 
        try:
            with open("eula.txt","r") as file:
                contents = file.read()
                contents = contents.replace("false","true")
            with open("eula.txt","w") as file:
                file.write(contents)
                eula = True

        except FileNotFoundError as fe:
            pass

def get_gateway_IP():

    result = subprocess.run(['ipconfig'], stdout=subprocess.PIPE)
    result = str(result).split("Default Gateway")
    result = result[1]
    result = result.split("\\n")
    IP = None
    for elem in result:
        if "192" in elem:
            IP = elem
    IP = IP.replace("\\r","")
    IP = IP.replace(" ", "")
    return IP

def open_gateway(IP:str):

    os.system(f"start http://{IP}")

def start_server():

    os.system("start server.jar")


def main():

    if is_file("eula.txt"):
        verify_eula(0)
        start_server()
        print("it is now safe to exit the program. Grab your IP from the internet (google, \"what is my IP?\") and port forward the port 25565")


    elif is_dir("venv"):
        DOWNLOAD_WAIT = 3
        init()
        get_server(2,13)
        time.sleep(DOWNLOAD_WAIT)
        os.system("start server.jar")
        verify_eula()
        open_gateway(get_gateway_IP())
        restart()
        

    else:
        print("\nNo VENV found.Initialising venv now... Make sure to run the venv before running the python script.\n\n\tWrite .\\venv\\bin\\activate to run the venv, then re run the program")
        os.system ("python -m venv venv")
        exit(-1)

main()
