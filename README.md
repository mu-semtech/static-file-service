# static-file-service
Microservice hosting static files from `/data`.

## Installation
Add the following snippet to your `docker-compose.yml` to include the static file service in your project.

```yaml
static-file:
  image: semtech/static-file-service
  links:
    - database:database
  volumes:
    - ./data/static-files:/data
```

Add rules to `dispatcher.ex` to dispatch requests to the static file service.

More information how to setup a mu.semte.ch project can be found in [mu-project](https://github.com/mu-semtech/mu-project).

## Configuration
The files are hosted by Nginx. The default Nginx configuration of the service is very minimal, but can be extended to your needs.

Custom Nginx configurations with a name like `*.conf` can be mounted in `/config` and will be included automatically in the `server` block.

### Example configurations
* Set caching to 30s:
```
location / {
    add_header Cache-Control "max-age=30, must-revalidate";
}
```

* Enable GZIP compression:
```
gzip on;
gzip_types application/json application/vnd.api+json application/javascript text/css;
```

* Enable basic auth
```
location / {
    auth_basic "Static file service";
    auth_basic_user_file /config/.htpasswd;
}
```




