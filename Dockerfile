FROM nginx:1.19.6

LABEL maintainer="erika.pauwels@gmail.com"

EXPOSE 80

COPY static-file-service.sh /
COPY nginx/default.conf /etc/nginx/conf.d/default.conf

CMD ["/bin/bash", "/static-file-service.sh"]
