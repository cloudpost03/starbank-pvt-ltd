FROM openjdk:11
ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} maven-wrapper.jar
ENTRYPOINT ["java","-jar","/maven-wrapper.jar"]
