# plog.sh
Friendly error log monitor (focus on PHP)

## Installation
```
git clone https://github.com/lazev/plog
cd plog
chmod +x plog.sh
./plog.sh
```

You can also move to the /usr/bin folder if you have permission.
```
sudo mv plog.sh /usr/bin/plog
```

Doing this, any user can run it by typing just 'plog'.

## One line instalattion (with sudo access)
```
cd; git clone https://github.com/lazev/plog; cd plog; chmod +x plog.sh; sudo mv plog.sh /usr/bin/plog; cd ..; rm -rf plog
```

## Usage
By default, plog reads /var/log/nginx/error.log, but you can
change this in the script or pass it as a parameter:
```
./plog.sh /var/log/otherfile.log
```
or
```
./plog /var/log/otherfile.log
```

*Maybe you have to use with ```sudo```*
```
sudo plog
```
