FROM ich777/mono-baseimage

LABEL org.opencontainers.image.authors="admin@minenet.at"
LABEL org.opencontainers.image.source="https://github.com/ich777/docker-vintage-story"

RUN apt-get install -y gpg wget && \
    wget https://packages.microsoft.com/keys/microsoft.asc && \
    cat microsoft.asc | gpg --dearmor -o microsoft.asc.gpg && \
    wget https://packages.microsoft.com/config/debian/12/prod.list && \
    mv prod.list /etc/apt/sources.list.d/microsoft-prod.list && \
    mv microsoft.asc.gpg $(cat /etc/apt/sources.list.d/microsoft-prod.list | grep -oP "(?<=signed-by=).*(?=\])") && \
    apt-get update && \
    apt-get -y install --no-install-recommends dotnet-runtime-8.0

ENV DATA_DIR="/vintagestory"
ENV VS_CHANNEL="stable"
ENV STATIC_V=""
ENV GAME_PARAMS=""
ENV UMASK=000
ENV UID=99
ENV GID=100
ENV DATA_PERM=770
ENV USER="vintagestory"

RUN mkdir $DATA_DIR && \
	useradd -d $DATA_DIR -s /bin/bash $USER && \
	chown -R $USER $DATA_DIR && \
	ulimit -n 2048

ADD /scripts/ /opt/scripts/
RUN chmod -R 770 /opt/scripts/

#Server Start
ENTRYPOINT ["/opt/scripts/start.sh"]