#!/bin/bash
right=$(printf '\xE2\x9C\x94')
red="\e[31m"
green="\e[32m"
end="\e[0m"
target=$1
out="output"
Usage() {
       echo -e "$green
       Usage: ./BackupHunter.sh -f targets.txt
       "$end
       exit 1
      }
collect() {
printf "Total targets: $(wc -l $target | awk '{print $1}')\n"
for domain in $(cat $target)
do
curl -k -s "http://web.archive.org/cdx/search/cdx?url=$domain*&output=tx&limit=999999" -H 'User-Agent: Mozilla/5.0' | grep -o -E "(([a-zA-Z][a-zA-Z0-9+-.]*\:\/\/)|mailto|data\:)([a-zA-Z0-9\.\&\/\?\:@\+-\_=#%;,])*" | anew -q waybackurls.txt
done
cat $target | gauplus --random-agent --subs | anew -q waybackurls.txt
wait 
cat $target | httpx -silent -ports 80,443,8080,8443 | anew -q valid_urls.txt
wait
gospider -S valid_urls.txt --quiet -d 3 -t 20 -c 10 | grep -o -E "(([a-zA-Z][a-zA-Z0-9+-.]*\:\/\/)|mailto|data\:)([a-zA-Z0-9\.\&\/\?\:@\+-\_=#%;,])*" | anew -q gospider.txt
wait
cat waybackurls.txt | cut -d"?" -f1 | cut -d"=" -f1 > filtered.txt
wait
cat gospider.txt | cut -d"?" -f1 | cut -d"=" -f1 >> filtered.txt
wait
#mv waybackurls.txt .waybackurls.txt 
#printf "Wayback Data: $(wc -l .waybackurls.txt | awk '{print $1}')\n"
}
filter() {
echo "##############################"
grep -iaE "([^.]+)\.zip$|([^.]+)\.zip\.[0-9]+$|([^.]+)\.zip[0-9]+$|([^.]+)\.zip[a-z][A-Z][0-9]+$|([^.]+)\.zip\.[a-z][A-Z][0-9]+$|([^.]+)\.rar$|([^.]+)\.tar$|([^.]+)\.tar\.gz$|([^.]+)\.tgz$|([^.]+)\.sql$|([^.]+)\.db$|([^.]+)\.sqlite$|([^.]+)\.pgsql\.txt$|([^.]+)\.mysql\.txt$|([^.]+)\.gz$|([^.]+)\.config$|([^.]+)\.log$|([^.]+)\.bak$|([^.]+)\.backup$|([^.]+)\.bkp$|([^.]+)\.crt$|([^.]+)\.dat$|([^.]+)\.eml$|([^.]+)\.java$|([^.]+)\.lst$|([^.]+)\.key$|([^.]+)\.passwd$|([^.]+)\.pl$|([^.]+)\.pwd$|([^.]+)\.mysql-connect$|([^.]+)\.jar$|([^.]+)\.cfg$|([^.]+)\.dir$|([^.]+)\.orig$|([^.]+)\.bz2$|([^.]+)\.old$|([^.]+)\.vbs$|([^.]+)\.img$|([^.]+)\.inf$|([^.]+)\.sh$|([^.]+)\.py$|([^.]+)\.vbproj$|([^.]+)\.mysql-pconnect$|([^.]+)\.war$|([^.]+)\.go$|([^.]+)\.psql$|([^.]+)\.sql\.gz$|([^.]+)\.vb$|([^.]+)\.webinfo$|([^.]+)\.jnlp$|([^.]+)\.cgi$|([^.]+)\.temp$|([^.]+)\.ini$|([^.]+)\.webproj$|([^.]+)\.xsql$|([^.]+)\.raw$|([^.]+)\.inc$|([^.]+)\.lck$|([^.]+)\.nz$|([^.]+)\.rc$|([^.]+)\.html\.gz$|([^.]+)\.gz$|([^.]+)\.env$|([^.]+)\.yml$|([^.]+)\.env$|([^.]+)\.json$|([^.]+)\.txt$" filtered.txt | sort -u | httpx -silent -follow-redirects -threads 100 -mc 200 > leaks.txt
#rm filtered.txt
}
found() {
mkdir $out 2> /dev/null
o=$(grep -aiE "([^.]+)\.zip$" leaks.txt | tee $out/zip.txt | wc -l);if [[ $o -gt 0 ]];then echo -e "$green[$o]$red zip $end Files Found."$end;fi
o=$(grep -aiE "([^.]+)\.zip\.[0-9]+$" leaks.txt | tee $out/zip.NUM.txt | wc -l);if [[ $o -gt 0 ]];then echo -e "$green[$o]$red zip.NUM $end Files Found."$end;fi
o=$(grep -aiE "([^.]+)\.zip[0-9]+$" leaks.txt | tee $out/zip_NUM.txt | wc -l);if [[ $o -gt 0 ]];then echo -e "$green[$o]$red zip_NUM $end Files Found."$end;fi
o=$(grep -aiE "([^.]+)\.zip[a-z][A-Z][0-9]+$" leaks.txt | tee $out/zip_alpha_ALPHA_NUM.txt | wc -l);if [[ $o -gt 0 ]];then echo -e "$green[$o]$red zip_alpha_ALPHA_NUM $end Files Found."$end;fi
o=$(grep -aiE "([^.]+)\.zip\.[a-z][A-Z][0-9]+$" leaks.txt | tee $out/zip.alpha_ALPHA_NUM.txt | wc -l);if [[ $o -gt 0 ]];then echo -e "$green[$o]$red zip.alpha_ALPHA_NUM $end Files Found."$end;fi
o=$(grep -aiE "([^.]+)\.rar$" leaks.txt | tee $out/rar.txt | wc -l);if [[ $o -gt 0 ]];then echo -e "$green[$o]$red rar $end Files Found."$end;fi
o=$(grep -aiE "([^.]+)\.tar$" leaks.txt | tee $out/tar.txt | wc -l);if [[ $o -gt 0 ]];then echo -e "$green[$o]$red tar $end Files Found."$end;fi
o=$(grep -aiE "([^.]+)\.tar\.gz$" leaks.txt | tee $out/tar.gz.txt | wc -l);if [[ $o -gt 0 ]];then echo -e "$green[$o]$red tar.gz $end Files Found."$end;fi
o=$(grep -aiE "([^.]+)\.tgz$" leaks.txt | tee $out/tgz.txt | wc -l);if [[ $o -gt 0 ]];then echo -e "$green[$o]$red tgz $end Files Found."$end;fi
o=$(grep -aiE "([^.]+)\.sql$" leaks.txt | tee $out/sql.txt | wc -l);if [[ $o -gt 0 ]];then echo -e "$green[$o]$red sql $end Files Found."$end;fi
o=$(grep -aiE "([^.]+)\.db$" leaks.txt | tee $out/db.txt | wc -l);if [[ $o -gt 0 ]];then echo -e "$green[$o]$red db $end Files Found."$end;fi
o=$(grep -aiE "([^.]+)\.sqlite$" leaks.txt | tee $out/sqlite.txt | wc -l);if [[ $o -gt 0 ]];then echo -e "$green[$o]$red sqlite $end Files Found."$end;fi
o=$(grep -aiE "([^.]+)\.pgsql\.txt$" leaks.txt | tee $out/pgsql.txt | wc -l);if [[ $o -gt 0 ]];then echo -e "$green[$o]$red pgsql $end Files Found."$end;fi
o=$(grep -aiE "([^.]+)\.mysql\.txt$" leaks.txt | tee $out/mysql.txt | wc -l);if [[ $o -gt 0 ]];then echo -e "$green[$o]$red mysql $end Files Found."$end;fi
o=$(grep -aiE "([^.]+)\.gz$" leaks.txt | tee $out/gz.txt | wc -l);if [[ $o -gt 0 ]];then echo -e "$green[$o]$red gz $end Files Found."$end;fi
o=$(grep -aiE "([^.]+)\.config$" leaks.txt | tee $out/config.txt | wc -l);if [[ $o -gt 0 ]];then echo -e "$green[$o]$red config $end Files Found."$end;fi
o=$(grep -aiE "([^.]+)\.log$" leaks.txt | tee $out/log.txt | wc -l);if [[ $o -gt 0 ]];then echo -e "$green[$o]$red log $end Files Found."$end;fi
o=$(grep -aiE "([^.]+)\.bak$" leaks.txt | tee $out/bak.txt | wc -l);if [[ $o -gt 0 ]];then echo -e "$green[$o]$red bak $end Files Found."$end;fi
o=$(grep -aiE "([^.]+)\.backup$" leaks.txt | tee $out/backup.txt | wc -l);if [[ $o -gt 0 ]];then echo -e "$green[$o]$red backup $end Files Found."$end;fi
o=$(grep -aiE "([^.]+)\.bkp$" leaks.txt | tee $out/bkp.txt | wc -l);if [[ $o -gt 0 ]];then echo -e "$green[$o]$red bkp $end Files Found."$end;fi
o=$(grep -aiE "([^.]+)\.crt$" leaks.txt | tee $out/crt.txt | wc -l);if [[ $o -gt 0 ]];then echo -e "$green[$o]$red crt $end Files Found."$end;fi
o=$(grep -aiE "([^.]+)\.dat$" leaks.txt | tee $out/dat.txt | wc -l);if [[ $o -gt 0 ]];then echo -e "$green[$o]$red dat $end Files Found."$end;fi
o=$(grep -aiE "([^.]+)\.eml$" leaks.txt | tee $out/eml.txt | wc -l);if [[ $o -gt 0 ]];then echo -e "$green[$o]$red eml $end Files Found."$end;fi
o=$(grep -aiE "([^.]+)\.java$" leaks.txt | tee $out/java.txt | wc -l);if [[ $o -gt 0 ]];then echo -e "$green[$o]$red java $end Files Found."$end;fi
o=$(grep -aiE "([^.]+)\.lst$" leaks.txt | tee $out/lst.txt | wc -l);if [[ $o -gt 0 ]];then echo -e "$green[$o]$red lst $end Files Found."$end;fi
o=$(grep -aiE "([^.]+)\.key$" leaks.txt | tee $out/key.txt | wc -l);if [[ $o -gt 0 ]];then echo -e "$green[$o]$red key $end Files Found."$end;fi
o=$(grep -aiE "([^.]+)\.passwd$" leaks.txt | tee $out/passwd.txt | wc -l);if [[ $o -gt 0 ]];then echo -e "$green[$o]$red passwd $end Files Found."$end;fi
o=$(grep -aiE "([^.]+)\.pl$" leaks.txt | tee $out/pl.txt | wc -l);if [[ $o -gt 0 ]];then echo -e "$green[$o]$red pl $end Files Found."$end;fi
o=$(grep -aiE "([^.]+)\.pwd$" leaks.txt | tee $out/pwd.txt | wc -l);if [[ $o -gt 0 ]];then echo -e "$green[$o]$red pwd $end Files Found."$end;fi
o=$(grep -aiE "([^.]+)\.mysql-connect$" leaks.txt | tee $out/mysql-connect.txt | wc -l);if [[ $o -gt 0 ]];then echo -e "$green[$o]$red mysql-connect $end Files Found."$end;fi
o=$(grep -aiE "([^.]+)\.jar$" leaks.txt | tee $out/jar.txt | wc -l);if [[ $o -gt 0 ]];then echo -e "$green[$o]$red jar $end Files Found."$end;fi
o=$(grep -aiE "([^.]+)\.cfg$" leaks.txt | tee $out/cfg.txt | wc -l);if [[ $o -gt 0 ]];then echo -e "$green[$o]$red cfg $end Files Found."$end;fi
o=$(grep -aiE "([^.]+)\.dir$" leaks.txt | tee $out/dir.txt | wc -l);if [[ $o -gt 0 ]];then echo -e "$green[$o]$red dir $end Files Found."$end;fi
o=$(grep -aiE "([^.]+)\.orig$" leaks.txt | tee $out/orig.txt | wc -l);if [[ $o -gt 0 ]];then echo -e "$green[$o]$red orig $end Files Found."$end;fi
o=$(grep -aiE "([^.]+)\.bz2$" leaks.txt | tee $out/bz2.txt | wc -l);if [[ $o -gt 0 ]];then echo -e "$green[$o]$red bz2 $end Files Found."$end;fi
o=$(grep -aiE "([^.]+)\.old$" leaks.txt | tee $out/old.txt | wc -l);if [[ $o -gt 0 ]];then echo -e "$green[$o]$red old $end Files Found."$end;fi
o=$(grep -aiE "([^.]+)\.vbs$" leaks.txt | tee $out/vbs.txt | wc -l);if [[ $o -gt 0 ]];then echo -e "$green[$o]$red vbs $end Files Found."$end;fi
o=$(grep -aiE "([^.]+)\.img$" leaks.txt | tee $out/img.txt | wc -l);if [[ $o -gt 0 ]];then echo -e "$green[$o]$red img $end Files Found."$end;fi
o=$(grep -aiE "([^.]+)\.inf$" leaks.txt | tee $out/inf.txt | wc -l);if [[ $o -gt 0 ]];then echo -e "$green[$o]$red inf $end Files Found."$end;fi
o=$(grep -aiE "([^.]+)\.sh$" leaks.txt | tee $out/sh.txt | wc -l);if [[ $o -gt 0 ]];then echo -e "$green[$o]$red sh $end Files Found."$end;fi
o=$(grep -aiE "([^.]+)\.py$" leaks.txt | tee $out/py.txt | wc -l);if [[ $o -gt 0 ]];then echo -e "$green[$o]$red py $end Files Found."$end;fi
o=$(grep -aiE "([^.]+)\.vbproj$" leaks.txt | tee $out/vbproj.txt | wc -l);if [[ $o -gt 0 ]];then echo -e "$green[$o]$red vbproj $end Files Found."$end;fi
o=$(grep -aiE "([^.]+)\.mysql-pconnect$" leaks.txt | tee $out/mysql-pconnect.txt | wc -l);if [[ $o -gt 0 ]];then echo -e "$green[$o]$red mysql-pconnect $end Files Found."$end;fi
o=$(grep -aiE "([^.]+)\.war$" leaks.txt | tee $out/war.txt | wc -l);if [[ $o -gt 0 ]];then echo -e "$green[$o]$red war $end Files Found."$end;fi
o=$(grep -aiE "([^.]+)\.go$" leaks.txt | tee $out/go.txt | wc -l);if [[ $o -gt 0 ]];then echo -e "$green[$o]$red go $end Files Found."$end;fi
o=$(grep -aiE "([^.]+)\.psql$" leaks.txt | tee $out/psql.txt | wc -l);if [[ $o -gt 0 ]];then echo -e "$green[$o]$red psql $end Files Found."$end;fi
o=$(grep -aiE "([^.]+)\.sql\.gz$" leaks.txt | tee $out/sql.gz.txt | wc -l);if [[ $o -gt 0 ]];then echo -e "$green[$o]$red sql.gz $end Files Found."$end;fi
o=$(grep -aiE "([^.]+)\.vb$" leaks.txt | tee $out/vb.txt | wc -l);if [[ $o -gt 0 ]];then echo -e "$green[$o]$red vb $end Files Found."$end;fi
o=$(grep -aiE "([^.]+)\.webinfo$" leaks.txt | tee $out/webinfo.txt | wc -l);if [[ $o -gt 0 ]];then echo -e "$green[$o]$red webinfo $end Files Found."$end;fi
o=$(grep -aiE "([^.]+)\.jnlp$" leaks.txt | tee $out/jnlp.txt | wc -l);if [[ $o -gt 0 ]];then echo -e "$green[$o]$red jnlp $end Files Found."$end;fi
o=$(grep -aiE "([^.]+)\.cgi$" leaks.txt | tee $out/cgi.txt | wc -l);if [[ $o -gt 0 ]];then echo -e "$green[$o]$red cgi $end Files Found."$end;fi
o=$(grep -aiE "([^.]+)\.temp$" leaks.txt | tee $out/temp.txt | wc -l);if [[ $o -gt 0 ]];then echo -e "$green[$o]$red temp $end Files Found."$end;fi
o=$(grep -aiE "([^.]+)\.ini$" leaks.txt | tee $out/ini.txt | wc -l);if [[ $o -gt 0 ]];then echo -e "$green[$o]$red ini $end Files Found."$end;fi
o=$(grep -aiE "([^.]+)\.webproj$" leaks.txt | tee $out/webproj.txt | wc -l);if [[ $o -gt 0 ]];then echo -e "$green[$o]$red webproj $end Files Found."$end;fi
o=$(grep -aiE "([^.]+)\.xsql$" leaks.txt | tee $out/xsql.txt | wc -l);if [[ $o -gt 0 ]];then echo -e "$green[$o]$red xsql $end Files Found."$end;fi
o=$(grep -aiE "([^.]+)\.raw$" leaks.txt | tee $out/raw.txt | wc -l);if [[ $o -gt 0 ]];then echo -e "$green[$o]$red raw $end Files Found."$end;fi
o=$(grep -aiE "([^.]+)\.inc$" leaks.txt | tee $out/inc.txt | wc -l);if [[ $o -gt 0 ]];then echo -e "$green[$o]$red inc $end Files Found."$end;fi
o=$(grep -aiE "([^.]+)\.lck$" leaks.txt | tee $out/lck.txt | wc -l);if [[ $o -gt 0 ]];then echo -e "$green[$o]$red lck $end Files Found."$end;fi
o=$(grep -aiE "([^.]+)\.nz$" leaks.txt | tee $out/nz.txt | wc -l);if [[ $o -gt 0 ]];then echo -e "$green[$o]$red nz $end Files Found."$end;fi
o=$(grep -aiE "([^.]+)\.rc$" leaks.txt | tee $out/rc.txt | wc -l);if [[ $o -gt 0 ]];then echo -e "$green[$o]$red rc $end Files Found."$end;fi
o=$(grep -aiE "([^.]+)\.html\.gz$" leaks.txt | tee $out/html.gz.txt | wc -l);if [[ $o -gt 0 ]];then echo -e "$green[$o]$red html.gz $end Files Found."$end;fi
o=$(grep -aiE "([^.]+)\.gz$" leaks.txt | tee $out/gz.txt | wc -l);if [[ $o -gt 0 ]];then echo -e "$green[$o]$red gz $end Files Found."$end;fi
o=$(grep -aiE "([^.]+)\.env$" leaks.txt | tee $out/env.txt | wc -l);if [[ $o -gt 0 ]];then echo -e "$green[$o]$red env $end Files Found."$end;fi
o=$(grep -aiE "([^.]+)\.yml$" leaks.txt | tee $out/yml.txt | wc -l);if [[ $o -gt 0 ]];then echo -e "$green[$o]$red yml $end Files Found."$end;fi
o=$(grep -aiE "([^.]+)\.json$" leaks.txt | tee $out/json.txt | wc -l);if [[ $o -gt 0 ]];then echo -e "$green[$o]$red json $end Files Found."$end;fi
o=$(grep -aiE "([^.]+)\.txt$" leaks.txt | tee $out/txt.txt | wc -l);if [[ $o -gt 0 ]];then echo -e "$green[$o]$red txt $end Files Found."$end;fi
find $out/ -type f -empty -delete
}
target=False
list=(
        collect
        filter
        found
)
while [ -n "$1" ]; do
                case "$1" in
                        -f | --file)
                                target=$2
                                shift
                                ;;
                        *)
                                echo -e $red"[-]"$end "Unknown Option: $1"
                                Usage
                                ;;
                esac
        shift
done
[[ $target == "False" ]] && { echo -e $red"[-]"$end "Argument: -f/--file targets.txt missing."
Usage
}
(
        collect | pv -l -r -b -F "%t %e Data Collection Progress: %p"
        filter | pv -l -r -b -F "%t %e Filtering Data Progress: %p"
        found
)
