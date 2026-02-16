# Stage 1: Build using Maven
FROM maven:3.8.2-openjdk-8 AS mavenbuilder
ARG TEST=/var/lib
WORKDIR ${TEST}
COPY . .
RUN mvn clean package

# Stage 2: Deploy WAR to Tomcat
FROM tomcat:jre8-temurin-focal
ARG TEST=/var/lib
COPY --from=mavenbuilder ${TEST}/targe

