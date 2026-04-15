# --- STAGE 1: Build Stage ---
# We name this stage 'builder' so we can refer to it later.
FROM node:18-slim AS builder

# Set the directory where we will work
WORKDIR /app

# Copy only the files that define our dependencies
COPY package.json package-lock.json ./

# Install the dependencies in this builder stage
RUN npm install

# Copy the rest of your application code
COPY . .


# --- STAGE 2: Production Stage ---
# We start FRESH with a new, clean image. 
# This removes all the temporary files created during 'npm install'.
FROM node:18-slim

# Create a clean folder for the final app
WORKDIR /app

# IMPORTANT: Instead of running 'npm install' again, 
# we COPY the results from the 'builder' stage.
# This keeps the final image very clean and small.
COPY --from=builder /app ./

# Tell Docker that the container listens on port 3000
EXPOSE 3000

# Start the application
ENTRYPOINT ["node", "server.js"]

