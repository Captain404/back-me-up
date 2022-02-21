[![License](https://img.shields.io/badge/license-MIT-_red.svg)](https://opensource.org/licenses/MIT)


# back-me-up
This tool will check for Sensitive Data Leakage with some useful patterns/RegEx. The patterns are mostly targeted on waybackdata and filter everything accordingly.

## Usage
```
root@me_dheeraj:$ cat > targets.txt
target1.tld
target2.tld

root@me_dheeraj:$ bash bulkyy.sh
[-] Usage: bash bulkyy.sh [-f/--file] targets.txt

Output will be saved in "output" directory
```

<h1 align="left">
  <img src="screenshot.png" alt="Dheerajmadhukar" width="700px"></a>
  <br>
</h1>

##### Prerequisites
- waybackurls [$ sudo go get github.com/tomnomnom/waybackurls] [@tomnomnom](https://github.com/tomnomnom/waybackurls)
- gauplus [$ sudo go get -u -v github.com/bp0lr/gauplus] [@bp0lr](https://github.com/bp0lr/gauplus)
- anew [$ sudo go get -u github.com/tomnomnom/anew] [@tomnomnom](https://github.com/tomnomnom/anew)
- httpx [@pdiscoveryio](https://github.com/projectdiscovery/httpx)
- pv [$ sudo apt install pv -y]
