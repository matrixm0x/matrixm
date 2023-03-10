# Tools Used:
# =============
# Subdomain Enumeration
# ------------------------
# waybackurls
# findomain
# alienvault
# rapiddns
# omni
# assetfinder
# subfinder
# hackertarget
# anubis
# gau
# osint.sh
# ======================
#         httpx
# ======================
#      waybackurls
# ======================
#      LinkFinder
# ======================
#        nuclei
# ----------------------

rsub()
{
    clear
    mkdir /mnt/c/Users/loler/OneDrive/Desktop/targets/$1
    touch /mnt/c/Users/loler/OneDrive/Desktop/targets/$1/note

    echo "########################################"
    echo "#        Subdomain Enumeration         #"
    echo "########################################"
    echo "# waybackurls     Omni          anubis #"
    echo "# findomain     assetfinder      gau   #"
    echo "# alienvault    subfinder     osint.sh #"
    echo "# rapiddns      hackertarget           #"
    echo "########################################"

    curl -sk "http://web.archive.org/cdx/search/cdx?url=*.$1&output=txt&fl=original&collapse=urlkey&page=" | awk -F/ '{gsub(/:.*/, "", $3); print $3}' >> /mnt/c/Users/loler/OneDrive/Desktop/targets/$1/wayback.txt
    echo "[+] Wayback Done"

    findomain -q -t $1 >> /mnt/c/Users/loler/OneDrive/Desktop/targets/$1/findomain.txt
    echo "[+] Findomain Done"

    curl -s -k "https://otx.alienvault.com/api/v1/indicators/domain/"$1"/passive_dns" | grep -oP '"\K[^"\047]+(?=["\047])' | grep '\.'$1'' | grep -v hostname >> /mnt/c/Users/loler/OneDrive/Desktop/targets/$1/alienvault.txt
    echo "[+] alienvault Done"

    curl -s -k "https://rapiddns.io/subdomain/"$1"?full=1" | grep '\.'$1'' | awk -F'<td>' '{print $2}' | awk -F'<' '{print $1}' >> /mnt/c/Users/loler/OneDrive/Desktop/targets/$1/rapiddns.txt
    echo "[+] rapiddns Done"

    curl --silent --insecure "https://sonar.omnisint.io/subdomains/$1" | tr '"' '\n' | tr ',[]' ' ' >> /mnt/c/Users/loler/OneDrive/Desktop/targets/$1/omni.txt
    echo "[+] Omni Done"

    assetfinder -subs-only $1 >> /mnt/c/Users/loler/OneDrive/Desktop/targets/$1/assetfinder.txt
    echo "[+] Assetfinder Done"

    subfinder -all -silent -d $1 >> /mnt/c/Users/loler/OneDrive/Desktop/targets/$1/subfinder.txt
    echo "[+] Subfinder Done"

    curl -s -k "https://api.hackertarget.com/hostsearch/?q="$1"" | awk -F',' '{print $1}' >> /mnt/c/Users/loler/OneDrive/Desktop/targets/$1/hackertarget.txt
    echo "[+] hackertarget Done"

    curl -s -k "https://jldc.me/anubis/subdomains/"$1"" | grep -oP '"\K[^"\047]+(?=["\047])' | grep '\.'$1'' >> /mnt/c/Users/loler/OneDrive/Desktop/targets/$1/anubis.txt
    echo "[+] anubis Done"

    echo $1 | gau | awk -F/ '{gsub(/:.*/, "", $3); print $3}' >> /mnt/c/Users/loler/OneDrive/Desktop/targets/$1/gau.txt
    echo "[+] Gau Done"

    curl -s -k "https://osint.sh/subdomain/" --data-raw "domain=$1" | grep -oP '"\K[^"\047]+(?=["\047])' | grep '\.'$1'' >> /mnt/c/Users/loler/OneDrive/Desktop/targets/$1/osint.txt
    echo "[+] Osint Done"

    cat /mnt/c/Users/loler/OneDrive/Desktop/targets/$1/*.txt | tr '@' "."  | sed -r '/^\s*$/d' | sort -u >> /mnt/c/Users/loler/OneDrive/Desktop/targets/$1/subdomain.txt
    cat /mnt/c/Users/loler/OneDrive/Desktop/targets/$1/subdomain.txt | sort -u >> /mnt/c/Users/loler/OneDrive/Desktop/targets/$1/subdomains.txt
    rm /mnt/c/Users/loler/OneDrive/Desktop/targets/$1/wayback.txt
    rm /mnt/c/Users/loler/OneDrive/Desktop/targets/$1/gau.txt
    rm /mnt/c/Users/loler/OneDrive/Desktop/targets/$1/findomain.txt
    rm /mnt/c/Users/loler/OneDrive/Desktop/targets/$1/subfinder.txt
    rm /mnt/c/Users/loler/OneDrive/Desktop/targets/$1/assetfinder.txt
    rm /mnt/c/Users/loler/OneDrive/Desktop/targets/$1/omni.txt
    rm /mnt/c/Users/loler/OneDrive/Desktop/targets/$1/hackertarget.txt
    rm /mnt/c/Users/loler/OneDrive/Desktop/targets/$1/alienvault.txt
    rm /mnt/c/Users/loler/OneDrive/Desktop/targets/$1/anubis.txt
    rm /mnt/c/Users/loler/OneDrive/Desktop/targets/$1/rapiddns.txt
    rm /mnt/c/Users/loler/OneDrive/Desktop/targets/$1/osint.txt
    rm /mnt/c/Users/loler/OneDrive/Desktop/targets/$1/subdomain.txt

    echo "###########################################"
    echo "#      Subdomain Enumeration is done      #"
    echo "###########################################"
}

rway()
{
    clear
    mkdir /mnt/c/Users/loler/OneDrive/Desktop/targets/$1/waybackurls
    mkdir /mnt/c/Users/loler/OneDrive/Desktop/targets/$1/waybackurls/ext/
    cat /mnt/c/Users/loler/OneDrive/Desktop/targets/$1/alive.txt | waybackurls | tee -a /mnt/c/Users/loler/OneDrive/Desktop/targets/$1/waybackurls/urls.txt
    cat /mnt/c/Users/loler/OneDrive/Desktop/targets/$1/waybackurls/urls.txt | sort -u | sed -r '/^\s*$/d' | tee -a /mnt/c/Users/loler/OneDrive/Desktop/targets/$1/waybackurls/waybackurls.txt
    rm /mnt/c/Users/loler/OneDrive/Desktop/targets/$1/waybackurls/urls.txt
    cat /mnt/c/Users/loler/OneDrive/Desktop/targets/$1/waybackurls/waybackurls.txt | grep "\\.js" | sort -u | sed -r '/^\s*$/d' | tee -a /mnt/c/Users/loler/OneDrive/Desktop/targets/$1/waybackurls/ext/js.txt
    cat /mnt/c/Users/loler/OneDrive/Desktop/targets/$1/waybackurls/waybackurls.txt | grep "\\.json" | sort -u | sed -r '/^\s*$/d' | tee -a /mnt/c/Users/loler/OneDrive/Desktop/targets/$1/waybackurls/ext/js.txt
    cat /mnt/c/Users/loler/OneDrive/Desktop/targets/$1/waybackurls/waybackurls.txt | grep "\\.txt" | sort -u | sed -r '/^\s*$/d' | tee -a /mnt/c/Users/loler/OneDrive/Desktop/targets/$1/waybackurls/ext/txt.txt
    cat /mnt/c/Users/loler/OneDrive/Desktop/targets/$1/waybackurls/waybackurls.txt | grep "\\.log" | sort -u | sed -r '/^\s*$/d' | tee -a /mnt/c/Users/loler/OneDrive/Desktop/targets/$1/waybackurls/ext/log.txt
    cat /mnt/c/Users/loler/OneDrive/Desktop/targets/$1/waybackurls/waybackurls.txt | grep "\\.bak" | sort -u | sed -r '/^\s*$/d' | tee -a /mnt/c/Users/loler/OneDrive/Desktop/targets/$1/waybackurls/ext/bak.txt
    cat /mnt/c/Users/loler/OneDrive/Desktop/targets/$1/waybackurls/waybackurls.txt | grep "\\.sql" | sort -u | sed -r '/^\s*$/d' | tee -a /mnt/c/Users/loler/OneDrive/Desktop/targets/$1/waybackurls/ext/sql.txt
    cat /mnt/c/Users/loler/OneDrive/Desktop/targets/$1/waybackurls/waybackurls.txt | grep "\\.cgi" | sort -u | sed -r '/^\s*$/d' | tee -a /mnt/c/Users/loler/OneDrive/Desktop/targets/$1/waybackurls/ext/cgi.txt
    cat /mnt/c/Users/loler/OneDrive/Desktop/targets/$1/waybackurls/waybackurls.txt | grep "\\.exe" | sort -u | sed -r '/^\s*$/d' | tee -a /mnt/c/Users/loler/OneDrive/Desktop/targets/$1/waybackurls/ext/exe.txt
    cat /mnt/c/Users/loler/OneDrive/Desktop/targets/$1/waybackurls/waybackurls.txt | grep "\\.xml" | sort -u | sed -r '/^\s*$/d' | tee -a /mnt/c/Users/loler/OneDrive/Desktop/targets/$1/waybackurls/ext/xml.txt
    cat /mnt/c/Users/loler/OneDrive/Desktop/targets/$1/waybackurls/waybackurls.txt | grep "\\.gz" | sort -u | sed -r '/^\s*$/d' | tee -a /mnt/c/Users/loler/OneDrive/Desktop/targets/$1/waybackurls/ext/gz.txt
    cat /mnt/c/Users/loler/OneDrive/Desktop/targets/$1/waybackurls/waybackurls.txt | grep "\\.zip" | sort -u | sed -r '/^\s*$/d' | tee -a /mnt/c/Users/loler/OneDrive/Desktop/targets/$1/waybackurls/ext/zip.txt
    cat /mnt/c/Users/loler/OneDrive/Desktop/targets/$1/waybackurls/waybackurls.txt | grep "\\.bzip2" | sort -u | sed -r '/^\s*$/d' | tee -a /mnt/c/Users/loler/OneDrive/Desktop/targets/$1/waybackurls/ext/bzip2.txt
    cat /mnt/c/Users/loler/OneDrive/Desktop/targets/$1/waybackurls/waybackurls.txt | grep "\\.tar" | sort -u | sed -r '/^\s*$/d' | tee -a /mnt/c/Users/loler/OneDrive/Desktop/targets/$1/waybackurls/ext/tar.txt
    cat /mnt/c/Users/loler/OneDrive/Desktop/targets/$1/waybackurls/waybackurls.txt | grep "\\.bz2" | sort -u | sed -r '/^\s*$/d' | tee -a /mnt/c/Users/loler/OneDrive/Desktop/targets/$1/waybackurls/ext/bz2.txt
    cat /mnt/c/Users/loler/OneDrive/Desktop/targets/$1/waybackurls/waybackurls.txt | grep "\\.7z"  | sed -r '/^\s*$/d' | tee -a /mnt/c/Users/loler/OneDrive/Desktop/targets/$1/waybackurls/ext/7z.txt
    cat /mnt/c/Users/loler/OneDrive/Desktop/targets/$1/waybackurls/waybackurls.txt | grep "/api/" | sort -u | sed -r '/^\s*$/d' | tee -a /mnt/c/Users/loler/OneDrive/Desktop/targets/$1/waybackurls/ext/api.txt
    cat /mnt/c/Users/loler/OneDrive/Desktop/targets/$1/waybackurls/waybackurls.txt | grep "\\.token" | sort -u | sed -r '/^\s*$/d' | tee -a /mnt/c/Users/loler/OneDrive/Desktop/targets/$1/waybackurls/ext/token.txt
    cat /mnt/c/Users/loler/OneDrive/Desktop/targets/$1/waybackurls/waybackurls.txt | grep "\\.py" | sort -u | sed -r '/^\s*$/d' | tee -a /mnt/c/Users/loler/OneDrive/Desktop/targets/$1/waybackurls/ext/py.txt
    cat /mnt/c/Users/loler/OneDrive/Desktop/targets/$1/waybackurls/waybackurls.txt | grep "\\.pl" | sort -u | sed -r '/^\s*$/d' | tee -a /mnt/c/Users/loler/OneDrive/Desktop/targets/$1/waybackurls/ext/pl.txt
    cat /mnt/c/Users/loler/OneDrive/Desktop/targets/$1/waybackurls/waybackurls.txt | grep "\\.db" | sort -u | sed -r '/^\s*$/d' | tee -a /mnt/c/Users/loler/OneDrive/Desktop/targets/$1/waybackurls/ext/db.txt
    cat /mnt/c/Users/loler/OneDrive/Desktop/targets/$1/waybackurls/waybackurls.txt | grep "\\.php" | sort -u | sed -r '/^\s*$/d' | tee -a /mnt/c/Users/loler/OneDrive/Desktop/targets/$1/waybackurls/ext/php.txt
    cat /mnt/c/Users/loler/OneDrive/Desktop/targets/$1/waybackurls/waybackurls.txt | grep "\\.asp" | sort -u | sed -r '/^\s*$/d' | tee -a /mnt/c/Users/loler/OneDrive/Desktop/targets/$1/waybackurls/ext/asp.txt
    cat /mnt/c/Users/loler/OneDrive/Desktop/targets/$1/waybackurls/waybackurls.txt | grep "\\.aspx" | sort -u | sed -r '/^\s*$/d' | tee -a /mnt/c/Users/loler/OneDrive/Desktop/targets/$1/waybackurls/ext/aspx.txt
    cat /mnt/c/Users/loler/OneDrive/Desktop/targets/$1/waybackurls/waybackurls.txt | grep "\\.xlsx" | sort -u | sed -r '/^\s*$/d' | tee -a /mnt/c/Users/loler/OneDrive/Desktop/targets/$1/waybackurls/ext/xlsx.txt
    clear
    echo "#################################"
    echo "#      waybackurls is done      #"
    echo "#################################"
}

rport()
{
    clear
    echo "##########################################"
    echo "#   rustscan for port scaninng is start  #"
    echo "##########################################"
    rustscan -a $1 -r 1-65535 -g
    echo "##########################################"
    echo "#         port scanning is done          #"
    echo "##########################################"
}

djs()
{
    clear
    mkdir /mnt/c/Users/loler/OneDrive/Desktop/targets/$1/jsfiles
    cat /mnt/c/Users/loler/OneDrive/Desktop/targets/$1/waybackurls/ext/js.txt | sort -u > /mnt/c/Users/loler/OneDrive/Desktop/targets/$1/jsfiles/js_filter.txt
    wget -i /mnt/c/Users/loler/OneDrive/Desktop/targets/$1/jsfiles/js_filter.txt -O /mnt/c/Users/loler/OneDrive/Desktop/targets/$1/jsfiles/all.js
    clear
    echo "#################################"
    echo "#     Js downloading is done    #"
    echo "#################################"
}

rjs()
{
    clear
    python3 /mnt/c/Users/loler/OneDrive/Documents/LinkFinder/linkfinder.py -i /mnt/c/Users/loler/OneDrive/Desktop/targets/$1/jsfiles/all.js -o cli
    nuclei -t ~/nuclei-templates/exposures/ -l /mnt/c/Users/loler/OneDrive/Desktop/targets/$1/jsfiles/js_filter.txt
}

rdir()
{
    python3 /mnt/c/Users/loler/OneDrive/Documents/dirsearch/dirsearch.py -u $1
}

rasset()
{
    assetfinder -subs-only $1
}

rhelp()
{
    clear
    echo "#########################################################"
    echo "#                         USAGE                         #"
    echo "#########################################################"
    echo "# commands:                                             #"
    echo "# =========                                             #"
    echo "# rsub: subdomain enumeration                           #"
    echo "# ---------------------------                           #"
    echo "# rway: wayback from subdomains and grep the extensions #"
    echo "# ----------------------------------------------------- #"
    echo "# rport: scanning for opened ports with rustscan        #"
    echo "# ----------------------------------------------        #"
    echo "# djs: downloading all js files                         #"
    echo "# -----------------------------                         #"
    echo "# rjs: Using LinkFinder for gather links and nuclei     #"
    echo "#      for find info exposures on js                    #"
    echo "# -------------------------------------------------     #"
    echo "# rdir: fuzzing with dirsearch                          #"
    echo "# ----------------------------                          #"
    echo "# rasset: finding subdomain with assetfinder            #"
    echo "# ------------------------------------------            #"
    echo "#########################################################"
}

