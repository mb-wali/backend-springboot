# # docker build -t my-spring-boot-app .
# # docker run -p 8080:8080 my-spring-boot-app

# Stage 1: Build the application
FROM maven:3.8.4-openjdk-17 AS builder

# Set the working directory in the container
WORKDIR /app

# Copy the Maven project file
COPY pom.xml .

# Download the dependencies
RUN mvn dependency:go-offline -B

# Copy the source code into the container
COPY src ./src

# Build the application
RUN mvn install -DskipTests

# Stage 2: Create the runtime container
FROM openjdk:17-jdk-alpine

# Set the working directory in the container
WORKDIR /app

# Copy the built JAR file from the previous stage
COPY --from=builder /app/target/*.jar app.jar

# Expose the port the app runs on
EXPOSE 8080

# Command to run the jar file
CMD ["java", "-jar", "app.jar"]
