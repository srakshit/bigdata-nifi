FROM srakshit/alpine-base

MAINTAINER Subham Rakshit

ENV DIST_MIRROR="https://public-repo-1.hortonworks.com/HDF" \
    NIFI_HOME="/opt/nifi" \
    HDF_VERSION="2.1.2.0" \
    NIFI_VERSION="1.1.0"

ADD ./nifi-properties.sh /opt/

RUN curl ${DIST_MIRROR}/${HDF_VERSION}/nifi-${NIFI_VERSION}.${HDF_VERSION}-10-bin.tar.gz | tar xz -C /opt \
    && ln -s /opt/nifi-${NIFI_VERSION}.${HDF_VERSION}-10 ${NIFI_HOME} \
    && sed -i -e "s|^nifi.ui.banner.text=.*$|nifi.ui.banner.text=Docker NiFi ${NIFI_VERSION}|" ${NIFI_HOME}/conf/nifi.properties \
    && mkdir -p ${NIFI_HOME}/database_repository \
    && mkdir -p ${NIFI_HOME}/flowfile_repository \
    && mkdir -p ${NIFI_HOME}/content_repository \
    && mkdir -p ${NIFI_HOME}/provenance_repository \
    && addgroup nifi \
    && adduser -S -G nifi nifi \
    && chown nifi:nifi -R /opt/ \
    && chmod 754 /opt/ \
    && chown nifi:nifi -R /opt/nifi-* \
    && chmod 754 /opt/nifi-*

# These are the volumes (in order) for the following:
# 1) user access and flow controller history
# 2) FlowFile attributes and current state in the system
# 3) content for all the FlowFiles in the system
# 4) information related to Data Provenance
# You can find more information about the system properties here - https://nifi.apache.org/docs/nifi-docs/html/administration-guide.html#system_properties

VOLUME ["${NIFI_HOME}/database_repository", \
        "${NIFI_HOME}/flowfile_repository", \
        "${NIFI_HOME}/content_repository", \
        "${NIFI_HOME}/provenance_repository"]
