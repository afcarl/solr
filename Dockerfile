FROM dockerimages/ubuntu-vm:14.04
RUN sudo apt-get -y update && \
    sudo apt-get -y install software-properties-common python-software-properties tomcat7 tomcat7-admin && \
    apt-get -y clean
RUN sudo echo '<tomcat-users>' > /etc/tomcat7/tomcat-users.xml &&\
    sudo echo '  <role rolename="manager-gui"/>' >> /etc/tomcat7/tomcat-users.xml && \
    sudo echo '  <user username="admin" password="mysecretpassword" roles="manager-gui"/>' >> /etc/tomcat7/tomcat-users.xml && \
    sudo echo '</tomcat-users>' >> /etc/tomcat7/tomcat-users.xml
RUN curl http://www.eu.apache.org/dist/lucene/solr/4.9.0/solr-4.9.0.tgz > solr-4.9.0.tgz
RUN tar xzvf solr-4.9.0.tgz
RUN sudo mv solr-4.9.0 /usr/share/solr
RUN sudo cp /usr/share/solr/example/webapps/solr.war /usr/share/solr/example/multicore/solr.war
RUN rm -rf solr-4.9.0.tgz 
RUN sudo cp -r /usr/share/solr/example/lib/ext/* /usr/share/tomcat7/lib/ && \
    sudo cp -r /usr/share/solr/example/resources/log4j.properties /usr/share/tomcat7/lib/ && \
    sudo echo '<Context docBase="/usr/share/solr/example/multicore/solr.war" debug="0" crossContext="true">' > /etc/tomcat7/Catalina/localhost/solr.xml && \
    sudo echo '  <Environment name="solr/home" type="java.lang.String" value="/usr/share/solr/example/multicore" override="true" />' >> /etc/tomcat7/Catalina/localhost/solr.xml && \
    sudo echo '</Context>' >> /etc/tomcat7/Catalina/localhost/solr.xml &&\
    sudo echo ' solr.log=/usr/share/solr' >> /usr/share/tomcat7/lib/log4j.properties &&\
    sudo chown -R tomcat7 /usr/share/solr/example/multicore
