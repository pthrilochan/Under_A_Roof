#Copyright (c) 2019, 2020,  Oracle and/or its affiliates.
#
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.
#
# ORACLE DOCKERFILES PROJECT
# --------------------------
# This is the Dockerfile for Oracle WebLogic 12.2.1.4 domain persisted on a Docker volume
#
# HOW TO BUILD THIS IMAGE
# -----------------------
# This Oracle WebLogic domain image extends the Oracle WebLogic 12.2.1.4 developer image, you must first build the Oracle WebLogic 12.2.1.4 binary image.
# Run:
#      $ docker build -f Dockerfile -t 12214-weblogic-domain-in-volume .
#
# IMPORTANT
# ---------
# The resulting image of this Dockerfile contains a WebLogic Domain.
#
# From
# ----
FROM container-registry.oracle.com/middleware/weblogic:12.2.1.4-dev-ol8

# Labels
# ------
LABEL "provider"="Oracle"                                               \
      "maintainer"="Monica Riccelli <monica.riccelli@oracle.com>"       \
      "issues"="https://github.com/oracle/docker-images/issues"         \
      "port.admin.listen"="7001"                                        \
      "port.administration"="9002"                                      \
      "port.managed.server"="8001"                                      

# WLS Configuration
# -----------------
ENV ORACLE_HOME=/u01/oracle \
    USER_MEM_ARGS="-Djava.security.egd=file:/dev/./urandom" \
    DOMAIN_ROOT="/u01/oracle/user_projects/domains" \
    ADMIN_HOST="${ADMIN_HOST:-AdminContainer}" \
    MANAGED_SERVER_PORT="${MANAGED_SERVER_PORT:-8001}" \
    MANAGED_SERVER_NAME_BASE="${MANAGED_SERVER_NAME_BASE:-MS}" \
    MANAGED_SERVER_CONTAINER="${MANAGED_SERVER_CONTAINER:-false}" \
    CONFIGURED_MANAGED_SERVER_COUNT="${CONFIGURED_MANAGED_SERVER_COUNT:-2}" \
    MANAGED_NAME="${MANAGED_NAME:-MS1}" \
    CLUSTER_NAME="${CLUSTER_NAME:-sample-cluster}" \
    CLUSTER_TYPE="${CLUSTER_TYPE:-DYNAMIC}" \
    PROPERTIES_FILE_DIR="/u01/oracle/properties" \
    #SCRIPT_FILE=/u01/oracle/createAndStartEmptyDomain.sh \
    HEALTH_SCRIPT_FILE=/u01/oracle/get_healthcheck_url.sh \
    JAVA_OPTIONS="-Doracle.jdbc.fanEnabled=false -Dweblogic.StdoutDebugEnabled=false"  \
    PATH="$PATH:${JAVA_HOME}/bin:/u01/oracle/oracle_common/common/bin:/u01/oracle/wlserver/common/bin:/u01/oracle/container-scripts"

# Add files required to build this image
# COPY --chown=oracle:oracle container-scripts/* /u01/oracle/container-scripts/
# COPY --chown=oracle:oracle container-scripts/get_healthcheck_url.sh /u01/oracle/get_healthcheck_url.sh

COPY --chown=oracle:oracle container-scripts/* /u01/oracle
COPY --chown=oracle:oracle container-scripts/get_healthcheck_url.sh /u01/oracle/get_healthcheck_url.sh

#Create directory where domain will be written to
USER root
RUN mkdir -p $DOMAIN_ROOT && \
    chown -R oracle:oracle $DOMAIN_ROOT/.. && \
    chmod -R a+xwr $DOMAIN_ROOT/.. && \
    mkdir -p $ORACLE_HOME/properties && \
    chmod -R a+r $ORACLE_HOME/properties 
#    chmod +x /u01/oracle/container-scripts/*

VOLUME $DOMAIN_ROOT

USER oracle
WORKDIR $ORACLE_HOME
#CMD ["/u01/oracle/container-scripts/createWLSDomain.sh"]