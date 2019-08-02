# docker-jenkins-ssl

## Method-1:

$ openssl req -x509 -newkey rsa:4096 -sha256 -nodes -keyout jenkins.key -out jenkins.pem -subj "/CN=localhost" -days 365

$ docker run --rm -d -p 443:4430 -v /var/jenkins_home:/var/jenkins_home --name jenkins jenkins/jenkins --env JAVA_OPTS="-Xmx8192m" --env JENKINS_OPTS=" --handlerCountMax=300 --httpPort=-1 --httpsPort=4430 --httpsCertificate=/var/lib/jenkins/cert --httpsPrivateKey=/var/lib/jenkins/pubkey"

## Method-2:

$ git clone <repo>

$ docker build -t myjenkins-tls .
