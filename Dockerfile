# credit goes to miiro@getintodevops.com. The Dockerfile was unmaintained so this has the purpose of updating and pointing to a specific version of jenkins

FROM jenkins/jenkins:2.179
MAINTAINER jdchandler88@gmail.com

# change to root so we can install docker tools
USER root

# Install the latest Docker CE binaries
RUN apt-get update && \
    apt-get -y install apt-transport-https \
      ca-certificates \
      curl \
      gnupg2 \
      software-properties-common && \
    curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg > /tmp/dkey; apt-key add /tmp/dkey && \
    add-apt-repository \
      "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
      $(lsb_release -cs) \
      stable" && \
   apt-get update && \
   apt-get -y install docker-ce

# add jenkins to the docker group
RUN usermod -a -G docker jenkins

# change back to jenkins user
USER jenkins

