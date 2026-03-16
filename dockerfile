FROM tomcat:9

COPY target/hello-world-war.war /usr/local/tomcat/webapps/

EXPOSE 8080
