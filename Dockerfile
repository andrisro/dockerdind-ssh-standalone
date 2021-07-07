FROM jpetazzo/dind

RUN apt-get update

RUN apt-get install nano
RUN apt-get install git -y

# Source for Installing SSH Server: https://github.com/rastasheep/ubuntu-sshd/blob/master/14.04/Dockerfile
RUN apt-get install -y openssh-server
RUN mkdir /var/run/sshd

RUN echo 'root:root' |chpasswd

RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config

RUN mkdir /root/.ssh

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# K3D
RUN wget -q -O - https://raw.githubusercontent.com/rancher/k3d/main/install.sh | bash

# Kubectl 
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
RUN sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

EXPOSE 22

# CMD    ["/usr/sbin/sshd", "-D"]
ENTRYPOINT service ssh restart && service docker start && bash
