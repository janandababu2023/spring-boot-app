# Stage 1: Build the application
# Use a Maven image with JDK pre-installed for building
FROM maven:3.9.6-amazoncorretto-17 AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy the Maven pom.xml file first to leverage Docker's layer caching
# This step will only be re-run if pom.xml changes
COPY pom.xml .

# Download dependencies (only if pom.xml changes)
# -DskipTests: Skip tests during the build
RUN mvn dependency:go-offline

# Copy the rest of the source code
COPY src ./src

# Build the Spring Boot application, creating the JAR file
RUN mvn clean install -DskipTests

# Stage 2: Create the final lightweight runtime image
# Use a smaller base image with only the necessary JRE
FROM amazoncorretto:17-alpine-jdk

# Set the working directory
WORKDIR /app

# Copy the built JAR file from the 'builder' stage
# The *.jar will typically pick up 'your-artifact-id-version.jar' from target/
COPY --from=builder /app/target/*.jar app.jar

# Expose the port on which your Spring Boot application runs
EXPOSE 8080

# Define the command to run your Spring Boot application
# 'java -jar app.jar' is the standard way to run a Spring Boot executable JAR
ENTRYPOINT ["java", "-jar", "app.jar"]