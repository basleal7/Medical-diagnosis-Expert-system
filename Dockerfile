# Use Node base image
FROM node:18

# Install SWI-Prolog
RUN apt-get update && apt-get install -y swi-prolog

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install Node dependencies
RUN npm install

# Copy all project files
COPY . .

# Expose port
EXPOSE 3000

# Start server
CMD ["node", "server.js"]