#!/bin/bash

# Disable Strict Host checking for non interactive git clones

mkdir -p -m 0700 /root/.ssh
echo -e "Host *\n\tStrictHostKeyChecking no\n" >> /root/.ssh/config

# Setup git variables
if [ ! -z "$GIT_EMAIL" ]; then
 git config --global user.email "$GIT_EMAIL"
fi
if [ ! -z "$GIT_NAME" ]; then
 git config --global user.name "$GIT_NAME"
 git config --global push.default simple
fi

# Install Extras
if [ ! -z "$DEBS" ]; then
 apt-get update
 apt-get install -y $DEBS
fi

if [ "$WP_ENV" != "development" ];then
  # Pull down code form git for our site!
  echo "        MMM.           .MMM"
  echo "        MMMMMMMMMMMMMMMMMMM"
  echo "        MMMMMMMMMMMMMMMMMMM      ___________________________________"
  echo "       MMMMMMMMMMMMMMMMMMMMM    |                                   |"
  echo "      MMMMMMMMMMMMMMMMMMMMMMM   | Git REPOS sync timez!!1           |"
  echo "     MMMMMMMMMMMMMMMMMMMMMMMM   |_   _______________________________|"
  echo "     MMMM::- -:::::::- -::MMMM    |/"
  echo "      MM~:~   ~:::::~   ~:~MM"
  echo " .. MMMMM::. .:::+:::. .::MMMMM .."
  echo "       .MM::::: ._. :::::MM."
  echo "          MMMM;:::::;MMMM"
  echo "   -MM        MMMMMMM"
  echo "   ^  M+     MMMMMMMMM"
  echo "       MMMMMMM MM MM MM"
  echo "            MM MM MM MM"
  echo "            MM MM MM MM"
  echo "         .~~MM~MM~MM~MM~~."
  echo "      ~~~~MM:~MM~~~MM~:MM~~~~"
  echo "     ~~~~~~==~==~~~==~==~~~~~~"
  echo "      ~~~~~~==~==~==~==~~~~~~"
  echo "          :~==~==~==~==~~"
  if [ ! -z "$GIT_REPO" ]; then
    rm /usr/src/app/*
    if [ ! -z "$GIT_BRANCH" ]; then
      git clone  --recursive -b $GIT_BRANCH $GIT_REPO /usr/src/app/
    else
      git clone --recursive $GIT_REPO /usr/src/app/
    fi
    chown -Rf www-data:www-data /usr/src/app/*
  else
    # if git repo not defined, pull from default repo:
    git clone  --recursive -b production https://github.com/eduwass/containerstudio-wordpress.git /usr/src/app/
    # remove git files
    rm -rf /usr/src/app/.git
  fi
fi

cd /usr/src/app
# install deps
npm install
# start script
npm start