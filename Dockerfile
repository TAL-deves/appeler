# Base image
FROM ubuntu:latest

# Set environment variables
ENV FLUTTER_HOME /opt/flutter
ENV PATH ${PATH}:${FLUTTER_HOME}/bin

# Update and install necessary packages
RUN apt-get update -y && \
    apt-get install -y curl git unzip xz-utils zip libglu1-mesa openjdk-8-jdk wget && \
    apt-get clean

# Download and install Flutter SDK
RUN git clone https://github.com/flutter/flutter.git ${FLUTTER_HOME}

# Set up Flutter environment variables
RUN flutter doctor -v

## Install Firebase CLI
#RUN curl -sL https://firebase.tools | bash

# Set working directory
WORKDIR /app

# Copy the project to the working directory
COPY . .

# Install Flutter dependencies
RUN flutter pub get

# Build the Flutter project
RUN flutter build web

# Expose necessary ports
EXPOSE 8080

# Run the Flutter app
CMD ["flutter", "run", "-d", "web-server", "--web-hostname", "0.0.0.0"]