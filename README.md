# docker-jenkins-ssl

### Method-1(Manual):-

### Pre-requisite

- A private SSL key (example.com.key)
- An SSL certificate signed by a certificate authority (example.com.crt).
- The SSL certificate of the certificate authority which did the signing (ca.crt).
- To generate a Java Keystore requires:

#### Reference your SSL certificates and key (listed above).

- Convert the SSL certificates into an intermediate format (PKCS12 keystore).
- Convert the intermediate format into a Java Keystore (JKS keystore).

#### The following command will convert SSL certificates into the intermediate format (PKCS12)

$ openssl req -x509 -newkey rsa:4096 -sha256 -nodes -keyout jenkins.key -out jenkins.crt \
  -subj "/CN=localhost" -days 365

$ openssl pkcs12 -export -out jenkins_keystore.p12 \
  -passout 'pass:changeit' -inkey jenkins.key \
  -in jenkins.crt -certfile ca.crt -name jenkins-cert
