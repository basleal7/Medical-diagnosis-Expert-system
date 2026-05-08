FROM node:18-bullseye

# Install SWI-Prolog properly
RUN apt-get update && \
    apt-get install -y swi-prolog && \
    apt-get clean

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

EXPOSE 3000

CMD ["node", "server.js"]