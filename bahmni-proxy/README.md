# Bahmni Proxy

This directory contains resources for building Docker image for Bahmni Proxy Container. The proxy container is a Apache Httpd server with overridden configurations. The proxy container is used for the following purposes.
1. Serve `Bahmni Index Page`
2. Proxy rules for different components of the application is configured.
3. SSL configurations for the application are done through this service.

## Building the image locally
1. Checkout the [client_side_logging](https://github.com/Bahmni/client_side_logging) repository in the same location as bahmni-package.
2. Navigate into bahmni-package directory.
3. Set the environment variables. 
     > export BAHMNI_VERSION=0.94 

     > export GITHUB_RUN_NUMBER=1
4. Run the build script `./bahmni-proxy/scripts/docker_build.sh`

## Integrate [speech-assistant-package](https://github.com/Bahmni/speech-assistant-package)
  * [speech-recognition-open-api-proxy](https://github.com/Open-Speech-EkStep/speech-recognition-open-api-proxy) is using websocket protocol
  * To pass a request from bahmni-proxy to speech-recognition-open-api-proxy, put below lines in *<VirtualHost \*:443>* tag:
    ```
    RewriteEngine on 
    RewriteCond %{HTTP:Upgrade} websocket [NC]
    RewriteCond %{HTTP:Connection} upgrade [NC]
    Header set Content-Security-Policy upgrade-insecure-requests
    RewriteRule ^/?(.*) "ws://vakyansh-proxy:9009/$1" [P,L]
    ```
  