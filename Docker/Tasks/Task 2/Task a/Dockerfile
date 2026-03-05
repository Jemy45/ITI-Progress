# Use alpine as base image
FROM alpine:latest
# Install Python 3, Git, and Bash
RUN apk add --no-cache python3 git bash
# Change to the /app directory 
WORKDIR /app
# Copy the shell file to the container
COPY run_flask.sh .
# Make the shell file executable
RUN chmod +x run_flask.sh
# Run the shell file which clones and download required files for flask
CMD ["./run_flask.sh"]