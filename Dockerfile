FROM ubuntu:18.04
LABEL maintainer="arnaud.samson@.usherbrooke.ca"

#Setup env
RUN apt update && apt install -y \
    zsh \
    curl \
    git \
    gcc \
    cmake \
    g++ \
    aria2 \
    python3-pip \
    python3-dev \
    libz-dev \
    && cd /usr/local/bin \
    && ln -s /usr/bin/python3 python \
    && pip3 install --upgrade pip \
    && cd /root

RUN git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh \
      && cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc \
      && chsh -s /bin/zsh

#Install Geant4
RUN apt install -y \
    libexpat1-dev \
    && cd /tmp \
    && aria2c -x 16 http://geant4.web.cern.ch/geant4/support/source/geant4.10.03.p03.tar.gz \
    && tar -xvf geant4.10.03.p03.tar.gz \
    && mkdir geant4-build \
    && cd geant4-build \
    && cmake \
        -DGEANT4_INSTALL_DATA=ON \
        /tmp/geant4.10.03.p03 \
    && make -j8 \
    && make install

#Install Root
RUN cd /tmp \
    && aria2c -x 16 https://root.cern.ch/download/root_v6.10.08.source.tar.gz \
    && tar -xvf root_v6.10.08.source.tar.gz \
    && mkdir root-build \
    && cd root-build \
    && cmake -Dx11=OFF /tmp/root-6.10.08 \
    && cmake --build . -- -j8 \
    && cmake --build . --target install

#Install Gate
RUN cd /tmp \
    && aria2c -x 16 http://www.opengatecollaboration.org/sites/default/files/gate_v8.0.tar.gz \
    && tar -xzf gate_v8.0.tar.gz \
    && mkdir gate_v8.0-build \
    && cd gate_v8.0-build \
    && cmake /tmp/gate_v8.0 \
    && make -j8 \
    && make install

#Cleanup
RUN rm -rf /tmp/*

WORKDIR /root
CMD ["zsh"]
