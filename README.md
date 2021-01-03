# static-file-service
Microservice hosting static files from `/data`.

## Getting started
### Adding the service to your stack
Add the following snippet to your `docker-compose.yml` to include the static file service in your project.

```yaml
static-file:
  image: semtech/static-file-service:0.1.0
  volumes:
    - ./data/static-files:/data
```

Add rules to `dispatcher.ex` to dispatch requests to the static file service.

E.g.
```
  get "/assets/*path" do
    Proxy.forward conn, path, "http://static-file/assets/"
  end
```

## How-to guides
### How to build an image to host an Ember application
Add the following Dockerfile in the root of your Ember application

```
FROM madnificent/ember:3.22.0 as builder

LABEL maintainer="john.doe@example.com"

WORKDIR /app
COPY package.json .
RUN npm install
COPY . .
RUN ember build -prod

FROM semtech/static-file-service:0.1.0

COPY --from=builder /app/dist /data
```

### How to customize the Nginx configuration
The files are hosted by Nginx. The default Nginx configuration of the service is very minimal, but can be extended to your needs.

Custom Nginx configurations with a name like `*.conf` can be mounted in `/config` and will be included automatically in the `server` block.

#### Example configurations
**Set caching to 30s**
```
location / {
    add_header Cache-Control "max-age=30, must-revalidate";
}
```

**Enable GZIP compression**
```
gzip on;
gzip_types application/json application/vnd.api+json application/javascript text/css;
```

**Enable basic auth**
```
location / {
    auth_basic "Static file service";
    auth_basic_user_file /config/.htpasswd;
}
```

### How to configure an Ember application at runtime using environment variables

The service can use environment variables to configure an Ember frontend build at runtime. This is typcially used for environment-specific (development, production, test, ...) configurations. On startup of the service, the environment variables prefixed with `EMBER_` will be used to fill in the values in `/data/index.html` with the value of the environment variables that match.

#### Configuring placeholders in the Ember application
Use placeholders like `{{MY_EXAMPLE}}` in the Ember configuration file `./config/environment.js` where values from an environment variable need to be filled in at runtime.

```javascript
if (environment === 'production') {
    ENV.torii.providers['oauth2'].apiKey = '{{OAUTH_API_KEY}}'
}
```

#### Set environment variables on the static-file service
Configure environment variables on the static-file service in `docker-compose.yml` containing the values to be replaced in the Ember configuration file. The environment variables need to be prefixed with `EMBER_`.

E.g. for the placeholder `{{OAUTH_API_KEY}}` to be replaced, you need to configure an environment variable `EMBER_OAUTH_API_KEY`.

```yaml
services:
  static-file:
    environment:
      EMBER_OAUTH_API_KEY: "my-api-key-for-production"
```


