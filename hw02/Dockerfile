FROM gradle:9.7.1-jdk25 AS build
WORKDIR /app
COPY . .
RUN chmod +x gradlew && ./gradlew --no-daemon bootJar

FROM amazoncorretto:25-alpine
WORKDIR /app
COPY --from=build /app/build/libs/*.jar app.jar
EXPOSE 8000
ENTRYPOINT ["java", "-jar", "app.jar"]
