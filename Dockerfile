FROM eclipse-temurin:17-jdk
VOLUME /tmp
ARG JAR_FILE=cc-recommend-app-1.jar
COPY ${JAR_FILE} app.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","/app.jar"]
