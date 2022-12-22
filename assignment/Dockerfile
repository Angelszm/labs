FROM node:16.5.0-alpine

# Create app directory
WORKDIR /usr/src/app

# Copy whole code to app directory.
COPY website/* /usr/src/app
# COPY website/index.html /usr/src/app

# Copy package.json app directory.
COPY package.json /app

RUN npm install -only=production

EXPOSE 4000
CMD [ "npm", "start"]