# Node official image as base image
FROM node:18.12.0

# Create app directory
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install app dependencies
RUN npm install

# Copy the rest of the application code to the working directory
COPY . .

# Expose the port the app runs on
EXPOSE 4000

# Command to run the app
CMD ["node", "index.js"]