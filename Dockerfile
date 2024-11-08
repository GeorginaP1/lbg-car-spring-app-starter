# Stage 1: Build the Spring Boot application
FROM maven:3.8.1-openjdk-11 as build

# Set the working directory inside the container
WORKDIR /app

# Copy the pom.xml file and download dependencies
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy the rest of the application source code and build the project
COPY src ./src
RUN mvn package -DskipTests

# Stage 2: Run the Spring Boot application
FROM openjdk:11
COPY --from=build /app/target/*.jar app.jar

# Expose the port the application runs on
EXPOSE 8080

# Command to run the application
ENTRYPOINT ["java", "-jar", "/app.jar"]