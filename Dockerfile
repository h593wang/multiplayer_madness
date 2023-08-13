FROM centos:centos8

RUN cd /etc/yum.repos.d/
RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
RUN sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*

RUN yum install -y wget unzip libXcursor openssl openssl-libs libXinerama libXrandr-devel libXi alsa-lib pulseaudio-libs mesa-libGL

# TODO: replace with your Godot version
ENV GODOT_VERSION "4.1.1"

# Install Godot Server
RUN wget -q https://downloads.tuxfamily.org/godotengine/${GODOT_VERSION}/Godot_v${GODOT_VERSION}-stable_linux.x86_64.zip \
&& unzip Godot_v${GODOT_VERSION}-stable_linux.x86_64.zip \
&& mv Godot_v${GODOT_VERSION}-stable_linux.x86_64 /usr/local/bin/godot \
&& chmod +x /usr/local/bin/godot

COPY server.pck .

CMD /usr/local/bin/godot --headless --main-pack ./server.pck -- --server