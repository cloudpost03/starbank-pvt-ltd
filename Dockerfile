FROM openjdk:11
ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} banking-0.0.1-SNAPSHOT.jar
ENTRYPOINT ["java","-jar","/banking-0.0.1-SNAPSHOT.jar"]
