FROM ubuntu:17.10

COPY cs50.sh /tmp/
RUN bash /tmp/cs50.sh && rm -f /tmp/cs50.sh
