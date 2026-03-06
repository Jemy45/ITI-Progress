# Use base image of nginx alpine
FROM nginx:alpine

# Add a custom index page
RUN echo "<h1>Ahmed Gamal-ITI-SA-46</h1>" > /usr/share/nginx/html/index.html

# Start nginx in the foreground to keep the container running
CMD ["nginx", "-g", "daemon off;"] 