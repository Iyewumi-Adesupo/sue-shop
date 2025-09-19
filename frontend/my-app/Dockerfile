# frontend/my-app/Dockerfile
FROM node:20-alpine

# Set working directory
WORKDIR /app 

# Install dependencies first
COPY package*.json ./
RUN npm install

# Copy the rest of the frontend code
COPY . .

# Expose Vite default port
EXPOSE 5173

# Start Vite dev server (hot reload)
CMD ["npm", "run", "dev", "--", "--host"]