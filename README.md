# Zabbix 4.0 Template for PHP-FPM Pools

This is a template for monitoring php-fpm and it's pools with [Zabbix](www.zabbix.com).

What's special about this template, is that it *automatically* detects (using LLD) the running php-fpm pools and creates items for measuring metrics from each pool.

So, if you are running a server with multiple php-fpm pools, this may be a better alternative for monitoring php than other templates available.

# Compatibility

This template was tested using:

| Software | Vesion |
| ------ | ------ |
| Zabbix Server | 4.0.3 |
| Debian | Stretch (9.8) |
| Php-fpm | 7.2 |

It might also work with other combination of versions.

# Metrics

This are the metrics created for each php-fpm pool:

![N|Solid](https://github.com/vigrai/zabbix-template-php-fpm/blob/master/img/metrics.png)

# Requirements

 - Php-status should be enabled in the php-fpm pools.
 - Php-status should be accessible and located in /php-status_POOLNAME for each pool (see step 4 of Setup).

# Setup

Even though this template is made with automation in mind, there's still some manual steps to be done in the client (where php-fpm and zabbix-agent are running) in order to get it working:

 1. Clone this template into a temporary directory.

    ```
    # git clone https://github.com/vigrai/zabbix-template-php-fpm.git /tmp/zabbix-template
    ```

 2. Put the file `php-fpm.discover_pools.pl` into the /etc/zabbix directory and make it executable.

    ```
    # cp /tmp/zabbix-template/php-fpm.discover_pools.pl /etc/zabbix
    # chmod +x /etc/zabbix/php-fpm.discover_pools.pl
    # chown zabbix.zabbix /etc/zabbix/php-fpm.discover_pools.pl
    ```
3. Copy the file userparameter_php-fpm.conf into /etc/zabbix/zabbix_agentd.d.
    ```
    # cp /tmp/zabbix-template/userparameter_php-fpm.conf /etc/zabbix/zabbix_agentd.d
    ```
4. Make sure that your php-fpm is correctly setup:

     [x] The pools should have php-status enabled.

     [x] Php-status should be available in the path /fpm-status_[NAME-OF-THE-POOL]

     Example configuration file for pool called *nms* (/etc/php/7.2/fpm/pool.d/nms.conf):

     ```[nms]```
     
     ```pm.status_path = /fpm-status_nms```

     [x] Php-status should be accessible for each pool. This is an example configuration file for nginx:

     ```
     ## Example configuration file for serving php-status of each php pool using nginx.
     # Take-aways:
     #  1.- The location should be in the format /fpm-status_POOLNAME
     #  2.- The proxy_pass should point to the correct pool. In this case unix sockets are used, but it'd be similar with a network connection (example: fastcgi_pass 127.0.0.1:9001).

     server {
        listen 0.0.0.0:8080;
        server_name status.localhost;

        keepalive_timeout 0;

        allow 127.0.0.1;
        deny all;

        location /fpm-status_nms {
                include fastcgi_params;
                fastcgi_pass unix:/var/run/php/php7.2-nms-fpm.sock;
                fastcgi_param SCRIPT_FILENAME $fastcgi_script_name;
        }

        location /fpm-status_website1 {
                include fastcgi_params;
                fastcgi_pass unix:/var/run/php/php7.2-website1-fpm.sock;
                fastcgi_param SCRIPT_FILENAME $fastcgi_script_name;
        }

        location /fpm-status_website2 {
                include fastcgi_params;
                fastcgi_pass unix:/var/run/php/php7.2-website2-fpm.sock;
                fastcgi_param SCRIPT_FILENAME $fastcgi_script_name;
        }

        location /fpm-status_website3 {
                include fastcgi_params;
                fastcgi_pass unix:/var/run/php/php7.2-website3-fpm.sock;
                fastcgi_param SCRIPT_FILENAME $fastcgi_script_name;
        }

        access_log off;

     }
     ```
5. Check that the script is finding the running pools:
    ```
    # /etc/zabbix/php-fpm.discover_pools.pl
    {
        "data":[

        {
                "{#POOLNAME}":"nms"
        }
        ,
        {
                "{#POOLNAME}":"website1"
        }
        ,
        {
                "{#POOLNAME}":"website2"
        }
        ,
        {
                "{#POOLNAME}":"website3"
        }

        ]

    }
    ```
6. If the script is returning the pools, you are ready to go. Import the zabbix-template-php-fpm.xml file in your Zabbix GUI and make sure that the macros are correctly setup, this are the values by default:
![N|Solid](https://github.com/vigrai/zabbix-template-php-fpm/blob/master/img/macros.png)
