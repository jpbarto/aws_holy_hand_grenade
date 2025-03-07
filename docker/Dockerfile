FROM alpine:latest

ENV NUKE_VER='v3.48.2'
ENV NUKE_TAR="aws-nuke-${NUKE_VER}-linux-amd64.tar.gz"
ENV NUKE_URL="https://github.com/ekristen/aws-nuke/releases/download/${NUKE_VER}/${NUKE_TAR}"

RUN apk --no-cache update && \
    apk --no-cache add jq python3 py-pip py-setuptools ca-certificates curl wget groff less aws-cli && \
    pip --no-cache-dir install awscli && \
    rm -rf /var/cache/apk/*

RUN wget $NUKE_URL && tar xzf $NUKE_TAR && mv aws-nuke /aws-nuke

COPY ./docker/run_aws_nuke.sh /run_aws_nuke.sh
COPY ./docker/aws-nuke.conf /aws-nuke.conf

CMD ["/run_aws_nuke.sh"]
