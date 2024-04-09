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
    curl 'https://download.schneider-electric.com/files?p_Doc_Ref=C-Gate_3_Linux_Package_V3.2.3&p_enDocType=Software+-+Release&p_File_Name=cgate-3.2.3_1760+%281%29.zip' -o cgate-3.zip && \
    unzip cgate-3.zip && \
    cp -rp cgate /usr/local/bin && \
    rm cgate-3.zip && \
    rm -rf cgate

# Remove the old TLS Settings from the JDK version, as per Issue #1
RUN sed -i '/^jdk.tls.disabledAlgorithms=/s/TLSv1, TLSv1.1, //g' /usr/lib/jvm/java-8-openjdk/jre/lib/security/java.security

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