FROM tomcat:9.0.78-jdk17
ARG SERVER_XML=server.xml
ARG LOGGING_PROPERTIES=logging.properties
ARG CATALINA_PROPERTIES=catalina.properties
ARG CATALINA_USERS=tomcat-users.xml

ENV JAVA_OPTS "-Djava.awt.headless=true"

COPY ${SERVER_XML} /usr/local/tomcat/conf/server.xml
COPY ${LOGGING_PROPERTIES} /usr/local/tomcat/conf/logging.properties
COPY ${CATALINA_PROPERTIES} /usr/local/tomcat/conf/catalina.properties
COPY ${CATALINA_USERS} /usr/local/tomcat/conf/tomcat-users.xml


RUN sed -i 's/port="8080"/port="18080"/' ${CATALINA_HOME}/conf/server.xml
RUN cp -R ${CATALINA_HOME}/webapps.dist/* ${CATALINA_HOME}/webapps

COPY ./manager/context.xml /usr/local/tomcat/webapps/manager/META-INF/context.xml
COPY ./host-manager/context.xml /usr/local/tomcat/webapps/host-manager/META-INF/context.xml

RUN export JAVA_OPTS="${JAVA_OPTS}"

EXPOSE 18080

CMD ["catalina.sh", "run"]