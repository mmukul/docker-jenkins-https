# docker-jenkins-ssl

### Method-1(Manual):-

### Pre-requisite

$ mkdir -p /var/jenkins_home /var/lib/jenkins /var/lib/jenkins/pubkey /var/lib/jenkins/cert \
$ useradd -u 1000 jenkins \
$ usermod -d /var/jenkins_home \
$ chmod 1000:1000 /var/jenkins_home
$ cd /var/jenkins_home
$ openssl req -x509 -newkey rsa:4096 -sha256 -nodes -keyout jenkins.key -out jenkins.pem -subj "/CN=localhost" -days 365
$ openssl rsa -in jenkins.key -out privkey-rsa.pem
$ cp privkey-rsa.pem /var/lib/jenkins/pubkey && cp server.pem /var/lib/jenkins/cert
$ chown -R jenkins:jenkins /var/lib/jenkins

$ docker run --rm -d -p 443:4430 -v /var/jenkins_home:/var/jenkins_home --name jenkins jenkins/jenkins --env JAVA_OPTS="-Xmx8192m" --env JENKINS_OPTS=" --handlerCountMax=300 --httpPort=-1 --httpsPort=4430 --httpsCertificate=/var/lib/jenkins/cert --httpsPrivateKey=/var/lib/jenkins/pubkey"

### Method-2(Automated):-

$ git clone <repo>

$ docker build -t myjenkins-tls .
