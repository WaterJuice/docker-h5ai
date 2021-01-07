# DOCKER-H5AI

**H5AI version: 0.29.2**
## RUN with a basic nginx configuration file



```
$ sudo docker run -d \
  -p 80:80 \
  -v $PWD:/var/www \
  -v $PWD/nginx_config_examples/basic_h5ai.nginx.conf:/etc/nginx/sites-enabled/h5.conf \
  waterjuice/h5ai
```

## HTTPS and PASSWORD

1. Create a password file. [Set up http auth with nginx](https://www.digitalocean.com/community/tutorials/how-to-set-up-http-authentication-with-nginx-on-ubuntu-12-10)
2. Create nginx conf file or look at the one in `nginx_config_examples/`
3. Generate or use a cert and key file. [How to create an ssl certificate on nginx](https://www.digitalocean.com/community/tutorials/how-to-create-an-ssl-certificate-on-nginx-for-ubuntu-14-04)

```
$ sudo docker run -d \
  -p 80:80 \
  -p 443:443 \
  -v $PWD/nginx_config_examples/h5ai.nginx.conf:/etc/nginx/sites-enabled/h5.conf \
  -v $PWD/htpasswd:/mnt/config/htpasswd:ro \
  -v $PWD/ssl:/etc/nginx/ssl:ro \
  -v /home/marcel/media:/var/www \
  waterjuice/h5ai
```
