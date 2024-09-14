## Untedted Installation

Navigate to your Home Assistant config directory where packages will be kept.
It's the director with configuration.yaml
> cd /homeassistant

Create the packages directory in the config directory if it doesn't already exist.
WARNING! This package references `packages/iLO3` so it would need modifying if you don't use the `packages` directory name.
> mkdir packages # If it doesn't already exist.

Clone this repo into the packages folder as `iLO3`.
WARNING! This package references `packages/iLO3` so it would need modifying if you don't use the `iLO3` directory name.
> git clone https://github.com/leon-v/homeassistant-packages-iLO3 iLO3

Add the generic packages loading config to your configuration.yaml
If you already load packages differently, you can include iLO in the same way.
```
homeassistant:
  packages: !include_dir_merge_named packages/
```

Add the iLO3 IP address or hostname, username and password to your secrets.yaml
```
ilo_ip_address: "xxx.xxx.xxx.xxx"
ilo_username: Administrator
ilo_password: ABCD1234
```

Restart Home Assistant and you should see various sensors show up.

## Debugging
To debug issues, you can increase the log level for the command_line component by adding this to your configuration.yaml
```
logger:
  default: info
  logs:
    homeassistant.components.command_line: debug
```

The worst part of this API was getting curl to use TLS1 which is obsolete.
The `UseTls1.cnf` file works around this by setting both these options:
```
CipherString = DEFAULT@SECLEVEL=0
Options = UnsafeLegacyServerConnect
```
Some things I read suggested using `DEFAULT@SECLEVEL=1` but only `0` worked with my server.

This config file changes the OpenSSL environment that curl will use by setting `OPENSSL_CONF=packages/iLO3/UseTls1.cnf` before curl is called.
It works by allowing invalid, unsafe and legacy protocols. 
