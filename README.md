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
$ openssl pkcs12 -inkey jenkins-ssl.key -in jenkins-ssl.pem -export -out jenkins-cert.p12 -passout 'pass:mypassW0rd'

### convert the intermediate format (PKCS12) to Java Keystore (JKS). This way Jenkins can use the JKS

$ keytool -importkeystore -srckeystore jenkins-cert.p12 -srcstorepass 'mypassW0rd' -srcstoretype PKCS12 -deststoretype JKS -destkeystore jenkins_keystore.jks -deststorepass 'mypassW0rd'


### Configure kernel to allow port forwarding

$ sysctl -w net.ipv4.ip_forward=1

### allow forwarding to localhost on eth0

$ sysctl -w net.ipv4.conf.eth0.route_localnet=1

### Configure iptables for port forwarding (for remote connections)

$ iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 443 -j DNAT --to-destination 127.0.0.1:8443
$ iptables -A FORWARD -i eth0 -m state --state NEW -m tcp -p tcp -d 127.0.0.1 --dport 8443 -j ACCEPT

### for localhost connections

$ iptables -t nat -A OUTPUT -p tcp --dport 443 -d 127.0.0.1 -j DNAT --to-destination 127.0.0.1:8443

### Run Jenkins in a Docker container
$ docker run --rm --name jenkins-aug-container -p 443:443 --env JENKINS_ARGS="--httpPort=-1 --httpsKeyStore=/var/jenkins_home/jenkins_keystore.jks --httpsKeyStorePassword=mypassW0rd --httpsPort=443" Jenkins/jenkins
