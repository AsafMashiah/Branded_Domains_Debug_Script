**Branded Domain Debug Script**

This script validates a branded domain configuration by checking its CNAME and CAA configuration, the expiration date of its SSL certificate, and its ability to receive clicks.

Prerequisites
This script requires the following dependencies:

TODO
TODO
Usage
To use this script, run the command below in your command line (terminal) with the domain name as an argument:

```
bash <(curl -Ls https://raw.githubusercontent.com/AF-Support/Branded_Domains_Debug_Script/main/branded_domains_validator.sh) YOUR_BRANDED_DOMAIN
```


For example:

```
bash <(curl -Ls https://raw.githubusercontent.com/AF-Support/Branded_Domains_Debug_Script/main/branded_domains_validator.sh) supporttest.afsdktests.com
```


The script will prompt you to confirm which validation steps you want to perform. Here are the available validation steps:

- Check CNAME configuration
- Check CAA configuration
- Check SSL certificate expiration
- Check ability to receive clicks
The script will output the results of each validation step.

Contributing
This script was created by @Boaz Hiam specifically for support. For any feedback, please send a Slack DM to Asaf Mashiah.
