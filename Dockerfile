FROM node:0.12

# Surpress Upstart errors/warning
RUN dpkg-divert --local --rename --add /sbin/initctl
RUN ln -sf /bin/true /sbin/initctl

# Let the conatiner know that there is no tty
ENV DEBIAN_FRONTEND noninteractive

# Install software requirements
RUN apt-get update && \
apt-get install -y git

# Add git commands to allow container updating
ADD scripts/pull /usr/bin/pull
ADD scripts/push /usr/bin/push
ADD scripts/docker-hook /usr/bin/docker-hook
ADD scripts/hook-listener /usr/bin/hook-listener
RUN chmod 755 /usr/bin/pull && chmod 755 /usr/bin/push

# copy start script
ADD scripts/start.sh /start.sh
RUN chmod 755 /start.sh

# Expose Ports (example: 80)
EXPOSE 80
EXPOSE 8555

# run start script (defined in package.json)
CMD ["/bin/bash", "/start.sh"]