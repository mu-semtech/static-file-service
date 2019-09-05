FROM nginx:1.17.3

LABEL maintainer="erika.pauwels@gmail.com"

EXPOSE 80

COPY nginx/default.conf /etc/nginx/conf.d/default.conf

