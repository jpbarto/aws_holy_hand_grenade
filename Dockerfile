FROM alpine:latest
COPY aws-nuke-v2.7.0-linux-amd64 /aws-nuke
COPY run_aws_nuke.sh /run_aws_nuke.sh
COPY aws-nuke.conf /aws-nuke.conf
CMD ["/run_aws_nuke.sh"]