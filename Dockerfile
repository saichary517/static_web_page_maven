# Use Maven image to build the project
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

# Use Tomcat image to run the built WAR
FROM tomcat:10.1-jdk17
WORKDIR /usr/local/tomcat/webapps/
# Remove default ROOT app
RUN rm -rf ROOT
# Copy the generated WAR file to Tomcat webapps
COPY --from=build /app/target/*.war ./ROOT.war

# Expose port 8080
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
