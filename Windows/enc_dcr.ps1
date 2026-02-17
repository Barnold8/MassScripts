param (
    [Parameter(Mandatory=$true)][bool]$method,
    [Parameter(Mandatory=$true)][string]$file,
    [Parameter(Mandatory=$false)][switch]$clipboard = $false
)

if ( $method ){
    openssl enc -aes-256-cbc -in "$($file)" -out "$($file).encrypted"
}
else{
    if ( $clipboard )
    {
        #TODO: copy contents of file to clipboard and delete file 
        openssl enc -d -aes-256-cbc -in $file -out "$($file).unencrypted"
        type "$($file).unencrypted" | clip.exe
        del "$($file).unencrypted"
    }else{
        openssl enc -d -aes-256-cbc -in $file -out "$($file).unencrypted"
    }

}