# docker-jenkins-ssl

### Pre-requisite

- A private SSL key (*.key)
- An SSL certificate signed by a certificate authority (*.crt)
- The SSL certificate of the certificate authority which did the signing (ca.crt)
- To generate a Java Keystore requires:

#### Reference your SSL certificates and key (listed above)

- Convert the SSL certificates into an intermediate format (PKCS12 keystore)
- Convert the intermediate format into a Java Keystore (JKS keystore)


### Create a Java Keystore
$ keytool -genkey -keyalg RSA -alias jenkins -keystore jenkins_keystore.jks -storepass mypassW0rd -keypass mypassW0rd -keysize 2048 -dname "CN=CA"

### Create TLS/SSL certs
$ openssl req -x509 -newkey rsa:4096 -sha256 -nodes -keyout jenkins-ssl.key -out jenkins-ssl.pem -subj "/CN=localhost" -days 365

### Convert SSL certificates into the intermediate format (PKCS12)
openssl pkcs12 -inkey jenkins-ssl.key -in jenkins-ssl.pem -export -out jenkins-cert.p12 -passout 'pass:mypassW0rd'

### convert the intermediate format (PKCS12) to Java Keystore (JKS). This way Jenkins can use the JKS

keytool -importkeystore -srckeystore jenkins-cert.p12 -srcstorepass 'mypassW0rd' -srcstoretype PKCS12 -deststoretype JKS -destkeystore jenkins_keystore.jks -deststorepass 'mypassW0rd'


### Run Jenkins in a Docker container
docker run --rm -e "TZ=America/Chicago" --name jenkins-july-container  -v /home/ec2-user/.ssh:/var/jenkins_home/.ssh -v data2:/var/jenkins_home -p 443:8443 -p 9080:8080 -p 50000:50000 -p 22:22 --env JENKINS_ARGS="--httpPort=-1 -httpsPort=8443 --httpsKeyStore=/home/ec2-user/jenkins-tls/jenkins_keystore.jks --httpsKeyStorePassword=mypassW0rd" jenkins-march
