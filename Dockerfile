# Multi-stage Dockerfile for gazizbek-batyr-student-api (Batyr Gazizbek, IT2-2301)
# Image: gazizbek-batyr-student-api:v1.0-gazizbek-batyr

# ---------- Stage 1: build the jar with the Gradle wrapper on a full JDK ----------
FROM eclipse-temurin:21-jdk AS build
WORKDIR /workspace

# Gradle files first, so the dependency layer is cached when only the code changes
COPY gradlew settings.gradle build.gradle ./
COPY gradle ./gradle
RUN chmod +x gradlew && ./gradlew --no-daemon dependencies > /dev/null

COPY src ./src
# Tests are executed by the Jenkins "Test" stage, the image build only packages the jar
RUN ./gradlew --no-daemon clean bootJar -x test

# ---------- Stage 2: small runtime image with only a JRE and the jar ----------
FROM eclipse-temurin:21-jre

ARG APP_VERSION=1.0.0
LABEL org.opencontainers.image.title="gazizbek-batyr-student-api" \
      org.opencontainers.image.description="Student CRUD API - Batyr Gazizbek" \
      org.opencontainers.image.authors="Batyr Gazizbek" \
      org.opencontainers.image.version="${APP_VERSION}" \
      org.opencontainers.image.source="https://github.com/gazizbekbr-tech/gazizbek-batyr-student-api"

ENV SERVER_PORT=8091 \
    STUDENT_NAME="Batyr Gazizbek"

WORKDIR /app
RUN groupadd --system spring && useradd --system --gid spring --no-create-home spring
COPY --from=build /workspace/build/libs/gazizbek-batyr-student-api.jar app.jar
USER spring

EXPOSE 8091
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
