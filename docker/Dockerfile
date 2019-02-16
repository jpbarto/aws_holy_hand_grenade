FROM alpine:latest

RUN apk --no-cache update && \
    apk --no-cache add jq python py-pip py-setuptools ca-certificates curl groff less && \
    pip --no-cache-dir install awscli && \
    rm -rf /var/cache/apk/*

COPY docker/aws-nuke-v2.7.0-linux-amd64 /aws-nuke
COPY docker/run_aws_nuke.sh /run_aws_nuke.sh
COPY docker/aws-nuke.conf /aws-nuke.conf

CMD ["/run_aws_nuke.sh"]
