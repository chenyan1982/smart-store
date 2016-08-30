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
				git \
				wget

# Download node source package and install
RUN wget https://nodejs.org/download/release/v5.9.1/node-v5.9.1.tar.gz

RUN tar zxvf node-v5.9.1.tar.gz \
	&& rm -f node-v5.9.1.tar.gz

WORKDIR node-v5.9.1/

RUN ./configure \
	&& make install


# Set the root password
RUN echo "root:${ROOT_USER_PASSWORD}" | chpasswd

# Create new user
RUN useradd app -m

# Set the work directory to home dir of the root
WORKDIR /home/app

VOLUME /home/app

EXPOSE ${APP_PORT}

COPY package.json ./package.json

COPY npm-shrinkwrap.json ./npm-shrinkwrap.json

RUN chown app:app -R /home/app

# Set the user id
USER app

RUN npm app





###############################################################################
#                                    End                                      #
###############################################################################
