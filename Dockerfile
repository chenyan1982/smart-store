###############################################################################
#                           Header Documentation                              #
###############################################################################


###############################################################################
#                                   Header                                    #
###############################################################################
FROM ubuntu-upstart
MAINTAINER Calvin.Chen

###############################################################################
#                            Environment Variables                            #
###############################################################################
# app directory
ENV APP_DIR /app

# Docker user to be created to intereact with container. This user is
# different than root
ENV DOCKER_USER=inlay

# Password for the user defined by DOCKER_USER environment
# variable
ENV DOCKER_USER_PASSWORD=inlay

# Password for the root
ENV ROOT_USER_PASSWORD=root

# service port
ENV APP_PORT 3000

###############################################################################
#                                Instructions                                 #
###############################################################################
# Install dependencies
RUN apt-get update -yq \
	&& apt-get upgrade -yq

RUN apt-get install -yq --no-install-recommends \
        gcc \
        g++ \
        make \
        python \
        adduser \
	git

# Download node source package and install
RUN git clone --recursive git://github.com/nodejs/node.git
WORKDIR /node
RUN ./configure
RUN make
RUN make install

# Set the root password
RUN echo "root:${ROOT_USER_PASSWORD}" | chpasswd

# Create new user called define by DOCKER_USER environment variable
RUN adduser --disabled-password --shell /bin/bash --gecos '' ${DOCKER_USER}

# Add user defined by DOCKER_USER environment variable to the sudoers list
RUN adduser ${DOCKER_USER} sudo

VOLUME /home/${DOCKER_USER}

EXPOSE ${APP_PORT}

# Set the work directory to home dir of the root
WORKDIR /home/${DOCKER_USER}/${APP_DIR}

COPY . /home/${DOCKER_USER}/${APP_DIR}

RUN sudo chmod g+rwx /home/${DOCKER_USER}/${APP_DIR}

RUN npm install

# Set the user id
USER ${DOCKER_USER}

ENTRYPOINT ["/bin/bash"]

###############################################################################
#                                    End                                      #
###############################################################################
