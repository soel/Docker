FROM centos

RUN yum install -y passwd
RUN yum install -y openssh
RUN yum install -y openssh-server
RUN yum install -y openssh-clients
RUN yum install -y sudo
RUN yum install -y wget

## create user

#ADD ./authorized_keys
RUN mkdir -p /root/.ssh; chown root /root/.ssh; chmod 700 /root/.ssh
RUN wget http://172.16.62.126/kickstart/cfgs/root.authorized_keys -O /root/authorized_keys
RUN mv -f /root/authorized_keys /root/.ssh/authorized_keys
RUN chown root.root /root/.ssh/authorized_keys; chmod 600 /root/.ssh/authorized_keys
RUN echo 'password' | passwd --stdin root

## setup sudoers

## setup sshd and generate ssh-keys by init script
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
RUN sed -ri 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config
RUN /etc/init.d/sshd start
RUN /etc/init.d/sshd stop

## Seems we cannnot fix public port number
EXPOSE 22
# EXPOSE 49222:22

CMD ["/usr/sbin/sshd", "-D"]
