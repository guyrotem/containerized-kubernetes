FROM kindest/node:v1.17.0

RUN mkdir -p /kind/templates \
 && mkdir -p /kind/images
COPY templates/ /kind/templates/
COPY podimages/ /kind/images/
COPY manifests/ /etc/kubernetes/manifests/
COPY scripts/ /usr/local/bin/
RUN chmod +x /usr/local/bin/*.sh
ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
#ENV container=docker   # inherited
VOLUME /lib/modules:/lib/modules:ro
VOLUME /var

#   entrypoint inherited from base/node image (left here for documentation)
#ENTRYPOINT [ "/usr/local/bin/entrypoint", "/sbin/init" ]
