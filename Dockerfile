FROM nginx

RUN DEBIAN_FRONTEND=noninteractive \
    apt-get update -qq \
 && apt-get -qqy install curl sed runit unzip \
 && rm -rf /var/lib/apt/lists/*

 RUN CONSUL_TEMPLATE_VERSION=`curl -qL "https://releases.hashicorp.com/consul-template/" | sed -n 's#.*href="/consul-template/\([^/]*\).*#\1#p' | head -1` \
 && curl -o consul-template.zip https://releases.hashicorp.com/consul-template/${CONSUL_TEMPLATE_VERSION}/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip \
 && unzip consul-template.zip -d /usr/local/bin/ \
 && rm -f consul-template.zip

ADD nginx.service /etc/service/nginx/run
ADD consul-template.service /etc/service/consul-template/run

RUN rm -v /etc/nginx/nginx.conf
ADD nginx.conf /etc/nginx/nginx.conf

RUN rm -v /etc/nginx/conf.d/*
ADD app.conf /etc/consul-templates/app.conf

CMD ["/usr/bin/runsvdir", "/etc/service"]
