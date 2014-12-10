FROM ubuntu:14.04
 
# Install dev tools: jdk, git etc...
RUN apt-get update
RUN apt-get install -y openjdk-7-jdk git wget openssh-server
 
# jdk7 is the default jdk
RUN ln -fs /usr/lib/jvm/java-7-openjdk-amd64/jre/bin/java /etc/alternatives/java
 
# Install vertx
#RUN \
#  mkdir -p /usr/local/vertx && cd /usr/local/vertx && \
#  wget http://dl.bintray.com/vertx/downloads/vert.x-2.1.2.tar.gz -qO - | tar -xz
 
# Add vertx to the path
#ENV PATH /usr/local/vertx/vert.x-2.1.2/bin:$PATH

# SSH
RUN mkdir /var/run/sshd
RUN echo 'root:screencast' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
 
RUN mkdir -p /usr/local/src
WORKDIR /usr/local/src

CMD ["bash"]
