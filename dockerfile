FROM tomcat:9-jdk11

# remove default apps
RUN rm -rf /usr/local/tomcat/webapps/*

# copy WAR file into tomcat
COPY target/hello-world-war.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080

CMD ["catalina.sh","run"]
