FROM ubuntu:18.04

# RStudio
EXPOSE 8787

COPY cs50.sh /tmp/
RUN bash /tmp/cs50.sh && rm -f /tmp/cs50.sh
