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
RUN chmod 755 /usr/bin/pull && chmod 755 /usr/bin/push

# copy start script
ADD scripts/start.sh /start.sh
RUN chmod 755 /start.sh

# run start script
ONBUILD RUN bash /start.sh
# npm install
ONBUILD RUN npm install

# Expose Ports
EXPOSE 443
EXPOSE 80

# tell npm to run start script (defined in package.json)
# CMD ["npm", "start"]
ONBUILD RUN npm start