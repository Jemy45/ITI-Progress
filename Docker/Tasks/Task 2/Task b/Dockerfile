# Use nginx alpine as base image (lightweight version of nginx)
FROM nginx:alpine
# Change the default port from 80 to 8080 in nginx default config file
# we can also copy a custom nginx config file with the port change instead of using sed command to modify the default config file
# Also nginx.conf run all config files in conf.d directory, 
# so we can also copy our custom config file with the port change to conf.d directory instead of modifying the default config file
RUN sed -i 's/80/8080/g' /etc/nginx/conf.d/default.conf
# Start nginx in the foreground to keep the container running
CMD ["nginx", "-g", "daemon off;"]