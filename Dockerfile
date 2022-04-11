FROM alpine:3.15.4

# Specifying Java envs.
ENV JAVA_VERSION_MAJOR=8
ENV JAVA_VERSION_MINOR=112
ENV JAVA_VERSION_BUILD=15
ENV JAVA_PACKAGE=server-jre
ENV JAVA_HOME=/opt/jdk
ENV PATH=${PATH}:/opt/jdk/bin

# Specifying OS envs.
ENV LANG=C.UTF
ENV UID=1000
ENV GUID=1000

LABEL maintainer="Kamarad Coal <alex@renoki.org>"

WORKDIR /bungee

ADD bungee/run.sh /bungee/

# Install packages.
RUN apk upgrade --update && \
    apk add --no-cache --update wget curl ca-certificates openssl bash git screen util-linux sudo shadow nss && \
    update-ca-certificates && \
    apk add --no-cache --update openjdk8-jre && \
    # Add "kamarad" user than can access "/bungee"
    addgroup -g 1000 -S kamarad && \
    adduser -u 1000 -S kamarad -G kamarad -h /bungee && \
    echo "kamarad ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/kamarad && \
    chown kamarad:kamarad /bungee && \
    wget https://ci.md-5.net/job/BungeeCord/lastSuccessfulBuild/artifact/bootstrap/target/BungeeCord.jar && \
    wget -P /bungee/modules https://ci.md-5.net/job/BungeeCord/lastSuccessfulBuild/artifact/module/cmd-alert/target/cmd_alert.jar  && \
    wget -P /bungee/modules https://ci.md-5.net/job/BungeeCord/lastSuccessfulBuild/artifact/module/cmd-find/target/cmd_find.jar && \
    wget -P /bungee/modules https://ci.md-5.net/job/BungeeCord/lastSuccessfulBuild/artifact/module/cmd-list/target/cmd_list.jar && \
    wget -P /bungee/modules https://ci.md-5.net/job/BungeeCord/lastSuccessfulBuild/artifact/module/cmd-send/target/cmd_send.jar && \
    wget -P /bungee/modules https://ci.md-5.net/job/BungeeCord/lastSuccessfulBuild/artifact/module/cmd-server/target/cmd_server.jar && \
    wget -P /bungee/modules https://ci.md-5.net/job/BungeeCord/lastSuccessfulBuild/artifact/module/reconnect-yaml/target/reconnect_yaml.jar && \
    chmod +x /bungee/run.sh && \
    rm -rf .git/ .github/ *.md && \
    rm -rf /var/cache/apk/*

EXPOSE 25577

ENTRYPOINT ["/bungee/run.sh"]
