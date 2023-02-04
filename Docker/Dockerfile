FROM ubuntu:20.04
LABEL owner="awsdevops.pavan@gmail.com"
LABEL version="1.0"
LABEL team="javateam@tcs.com"
ARG VERSION='1.3.7'
#ENV AWS_ACCESS_KEY="ASDSADADADASDAS"
#ENV AWS_SECRET_ACCESS_KEY='ADSDASDASSDDASDSD'
RUN apt update
RUN apt install -y nginx jq unzip curl wget
COPY index.html /var/www/html/index.nginx-debian.html
COPY style.css /var/www/html/style.css
COPY scorekeeper.js /var/www/html/scorekeeper.js
ADD error.html /var/www/html/error.html
ADD https://releases.hashicorp.com/terraform/${VERSION}/terraform_${VERSION}_linux_amd64.zip /usr/local/bin/terraform.zip
RUN cd /usr/local/bin/ && unzip terraform.zip && rm -f *.zip && terraform version