# Build stage
FROM gradle:8.11.1-jdk21 as builder
WORKDIR /app
COPY . .
RUN gradle build -x test --no-daemon && ls -la build/libs/

# Runtime stage
FROM openjdk:21
WORKDIR /app
COPY --from=builder /app/build/libs/*.jar ./app.jar
EXPOSE 8088
ENTRYPOINT ["java", "-jar", "app.jar"]