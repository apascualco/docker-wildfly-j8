
FROM debian:latest

# Add java repo
RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee /etc/apt/sources.list.d/webupd8team-java.list
RUN echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886

#Debian update
RUN apt-get update

#Install ssh and create user
RUN apt-get install ssh -y
RUN mkdir /home/apascualco 
RUN useradd apascualco -d /home/apascualco -s /bin/bash
RUN echo "apascualco:apascualco" | chpasswd qwerty
RUN mkdir /var/run/sshd

#Install wget
RUN apt-get install wget -y

#Intall zip
RUN apt-get install zip -y

#Create dir and download wildfly
RUN wget http://download.jboss.org/wildfly/10.1.0.Final/wildfly-10.1.0.Final.zip
RUN unzip wildfly-10.1.0.Final.zip -d /home/apascualco/
RUN rm wildfly-10.1.0.Final.zip

# Java 8
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
RUN apt-get install -y oracle-java8-installer oracle-java8-set-default

RUN ./home/apascualco/wildfly-10.1.0.Final/bin/add-user.sh -u admin -p admin -r ManagementRealm

EXPOSE 8080 9990

CMD ["/home/apascualco/wildfly-10.1.0.Final/bin/standalone.sh", "-b", "0.0.0.0", "-bmanagement", "0.0.0.0"]
