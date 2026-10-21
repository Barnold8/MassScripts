~/Code/MassScripts/Linux/encdcr.sh -d ~/gitKey.aes
cat gitKey.unencrypted | xclip -selection clipboard 
rm gitKey.unencrypted

