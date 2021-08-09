FROM jpetazzo/dind

RUN apt-get update

RUN apt-get install nano
RUN apt-get install git -y

RUN apt-get install bash-completion

# Source for Installing SSH Server: https://github.com/rastasheep/ubuntu-sshd/blob/master/14.04/Dockerfile
RUN apt-get install -y openssh-server
RUN mkdir /var/run/sshd

RUN echo 'root:root' |chpasswd

RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config

RUN mkdir /root/.ssh

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 22

# CMD    ["/usr/sbin/sshd", "-D"]
ENTRYPOINT service ssh restart && service docker start && bash
