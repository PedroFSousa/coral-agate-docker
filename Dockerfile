FROM obiba/agate:1.4

# testing the build again
LABEL maintainer="The INESC TEC Team <coral@lists.inesctec.pt>"
LABEL system="Coral"

ENV AGATE_DIR=/usr/share/agate

COPY ./scripts/wait-for-it.sh /

COPY bin/ /opt/agate/bin/
RUN [ "/bin/bash", "-c", "mkdir -p $AGATE_DIR/{applications,groups}" ]

COPY ./docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["app"]
