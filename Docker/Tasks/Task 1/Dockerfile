FROM nginx:alpine
# Download python on nginx
RUN apk add --no-cache python3 
# Copy the file from host into the container
COPY consumer.py /app/consumer.py
# Run the code on the container
CMD ["python3", "/app/consumer.py"]