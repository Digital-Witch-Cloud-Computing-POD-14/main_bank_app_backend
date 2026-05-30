# Stage 1: Build the application using official Maven with OpenJDK 17
FROM maven:3.8.5-openjdk-17 AS builder
WORKDIR /app

# Copy configuration and dependencies framework
COPY pom.xml .
# Download dependencies beforehand to cache this layer
RUN mvn dependency:go-offline -B

# Copy project source code
COPY src ./src

# Compile and package application without running tests
RUN mvn clean package -DskipTests

# Stage 2: Create the runtime production image
FROM khipu/openjdk17-alpine
WORKDIR /app

# Copy only the compiled artifact from the builder stage
COPY --from=builder /app/target/online-banking-system-0.0.1-SNAPSHOT.jar app.jar

# Expose your application port (adjust if your app runs on a different port like 8080)
EXPOSE 8080

# Execute the application
ENTRYPOINT ["java", "-jar", "app.jar"]

#rrr

