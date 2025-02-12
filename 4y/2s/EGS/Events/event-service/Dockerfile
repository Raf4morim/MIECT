# Get image
FROM node:19

# Metadata
LABEL maintainer="Luis Couto 89078"
LABEL version="1.0"

# Install net-tools for debugging purposes
RUN apt update && apt install -y net-tools

# Create the app directory
RUN mkdir /app

# Create the logs directory that will be mounted as a volume
RUN mkdir /app/event-logs

# Working directory for the app
WORKDIR /app

# Copy package.json and package-lock.json into the directory
COPY package*.json ./

# Install the application dependencies
RUN npm install

# Copy the rest of the application code into the container
COPY . .

# Expose port for the application
EXPOSE 1000

# Define the volume for the application logs
VOLUME /app/event-logs

# Define the command to run the application
CMD [ "node", "index.js" ]
