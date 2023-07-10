FROM tomcat:9.0.76-jdk17
RUN sed -i 's/port="8080"/port="10001"/' ${CATALINA_HOME}/conf/server.xml
EXPOSE 10001
#ADD ./tomcat-cas/war/ ${CATALINA_HOME}/webapps/
CMD ["catalina.sh", "run"]