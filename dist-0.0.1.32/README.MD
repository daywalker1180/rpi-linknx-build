#Installation
to run this linknx binary some shared libs have to be installed:
```bash
apt-get update
apt-get install liblua5.1-0 liblog4cpp5 libesmtp6

# install the libpthsem packages from this dist directory
dpkg -i libpthsem*.deb

# check if linknx runs
./linknx --version
```
