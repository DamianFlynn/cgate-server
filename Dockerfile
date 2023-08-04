FROM alpine:latest

RUN apk add --no-cache curl openjdk8-jre

# C-Gate port 20023 to allow c-bus toolkit connection from PC
EXPOSE 20023
EXPOSE 20024
EXPOSE 20025
EXPOSE 20026
EXPOSE 20123

RUN \
    # Download unpack and copy CGate
    cd /tmp && \
    curl -O https://updates.clipsal.com/ClipsalSoftwareDownload/mainsite/cis/technical/CGate/cgate-2.11.4_3251.zip && \
    unzip cgate-2.11.4_3251.zip && \
    cp -rp cgate /usr/local/bin && \
    rm cgate-2.11.4_3251.zip && \
    rm -rf cgate

# Copy the default c-gate config files so they are available for customisation when the add-on starts.
COPY rootfs/ /usr/local/bin/cgate/config


RUN ln -s /usr/local/bin/cgate/config /config && \
	ln -s /usr/local/bin/cgate/tag /tag && \
	ln -s /usr/local/bin/cgate/logs /logs

VOLUME /config
VOLUME /tag
VOLUME /logs

WORKDIR /usr/local/bin/cgate
CMD ["java", "-jar", "cgate.jar"]