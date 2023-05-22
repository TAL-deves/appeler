# Use the official Flutter base image
FROM openjdk:8-jdk-slim

# Set the working directory in the container
WORKDIR /app

# Install necessary dependencies
RUN apt-get update && \
    apt-get install -y curl unzip git && \
    rm -rf /var/lib/apt/lists/*

# Download and install Flutter SDK
RUN git clone https://github.com/flutter/flutter.git /flutter
ENV PATH="/flutter/bin:${PATH}"
RUN flutter precache

# Enable web support
RUN flutter config --enable-web

# Copy the app files to the container
COPY . .

# Install app dependencies
RUN flutter pub get

# Build the Flutter app for the desired platform
RUN flutter build web

# Expose the default Flutter web port
EXPOSE 8989

# Run the flutter app
CMD ["flutter", "run", "-d", "web-server", "--web-hostname", "0.0.0.0", "--web-port", "8989"]