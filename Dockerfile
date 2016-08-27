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

WORKDIR /${APP_DIR}

EXPOSE ${APP_PORT}


ENTRYPOINT ["/bin/bash"]
