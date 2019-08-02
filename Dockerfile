FROM jenkins/jenkins
LABEL maintainer="smilemukul2005@gmail.com"
USER jenkins
WORKDIR /var/jenkins_home
USER root

# Generate self-signed certs

RUN openssl req -x509 -newkey rsa:4096 -sha256 -nodes -keyout jenkins.key -out jenkins.pem -subj "/CN=localhost" -days 365 && \
openssl rsa -in jenkins.key -out privkey-rsa.pem && \
mkdir -p /var/lib/jenkins && cp privkey-rsa.pem /var/lib/jenkins/pubkey && cp server.pem /var/lib/jenkins/cert && chown -R jenkins:jenkins /var/lib/jenkins
USER jenkins
ENV JENKINS_OPTS --httpPort=-1 --httpsPort=4430 --httpsCertificate=/var/lib/jenkins/cert --httpsPrivateKey=/var/lib/jenkins/pubkey
EXPOSE 443
