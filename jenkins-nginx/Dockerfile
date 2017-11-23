FROM nginx:1.13

#cleanup unneeded conf files
#RUN ls /etc/nginx/conf.d
RUN rm /etc/nginx/conf.d/default.conf
#RUN rm /etc/nginx/conf.d/example_ssl.conf

# add conf files
COPY ./conf/jenkins.conf /etc/nginx/conf.d/jenkins.conf
COPY ./conf/nginx.conf /etc/nginx/nginx.conf
