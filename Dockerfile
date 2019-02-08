FROM alpine:latest
COPY aws-nuke-v2.7.0-linux-amd64 /aws-nuke
CMD ["/run_aws_nuke.sh"]