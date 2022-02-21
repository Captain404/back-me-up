[![License](https://img.shields.io/badge/license-MIT-_red.svg)](https://opensource.org/licenses/MIT)


# BackuoHunter
This tool will check for Sensitive Data Leakage with some useful patterns/RegEx. The patterns are mostly targeted on waybackdata and filter everything accordingly. I have modified the tool from the original to have Curl as the tool to pull Wayback data. Curl seems more reliable and controllable. I have also added gospider in to the tool.

## Usage
```
root@me:$ cat > targets.txt
target1.tld
target2.tld

root@me:$ bash BackupHunter.sh
[-] Usage: bash BackupHunter.sh [-f/--file] targets.txt

Output will be saved in "output" directory
```

<h1 align="left">
  <img src="screenshot.png" alt="Dheerajmadhukar" width="700px"></a>
  <br>
</h1>

##### Prerequisites
- gospider [$ GO111MODULE=on go get -u github.com/jaeles-project/gospider] [@j3ssiejjj](https://github.com/jaeles-project/gospider)
- gauplus [$ sudo go get -u -v github.com/bp0lr/gauplus] [@bp0lr](https://github.com/bp0lr/gauplus)
- anew [$ sudo go get -u github.com/tomnomnom/anew] [@tomnomnom](https://github.com/tomnomnom/anew)
- httpx [@pdiscoveryio](https://github.com/projectdiscovery/httpx)
- pv [$ sudo apt install pv -y]
