FROM dtzar/helm-kubectl:3.1.2

ENV POPEYE_URL https://github.com/derailed/popeye/releases/download/v0.8.1/popeye_Linux_x86_64.tar.gz
ENV POPEYE_FLAGS -A
ENV POPEYE_MIN_SCORE 50

ENV POPEYE_HOME /github/home/popeye/

# Install needed dependencies
RUN apk add -U openssl curl tar bash ca-certificates jq

# Install Popeye
RUN mkdir -p ${POPEYE_HOME} && curl -L -o ${POPEYE_HOME}/popeye.tar.gz ${POPEYE_URL}
RUN cd ${POPEYE_HOME} && tar -zxvf ${POPEYE_HOME}/popeye.tar.gz

# Add entrypoint
COPY src/run.sh /run.sh

ENTRYPOINT ["/run.sh"]
