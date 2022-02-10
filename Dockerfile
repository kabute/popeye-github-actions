FROM dtzar/helm-kubectl:3.8.0

ENV POPEYE_URL https://github.com/derailed/popeye/releases/download/v0.9.8/popeye_Linux_x86_64.tar.gz
ENV POPEYE_FLAGS -A
ENV POPEYE_MIN_SCORE 50

ENV POPEYE_HOME /popeye

# Install needed dependencies
RUN apk add -U openssl curl tar bash ca-certificates jq

# Install Popeye
RUN mkdir -p ${POPEYE_HOME} && curl -L -o ${POPEYE_HOME}/popeye.tar.gz ${POPEYE_URL}
RUN cd ${POPEYE_HOME} && tar -zxf ${POPEYE_HOME}/popeye.tar.gz

# Add entrypoint
COPY src/run.sh /run.sh

ENTRYPOINT ["/run.sh"]
