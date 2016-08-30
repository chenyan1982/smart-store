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

ENV HOME=/home/app

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
RUN useradd --user-group --create-home --shell /bin/false app

COPY package.json npm-shrinkwrap.json $HOME/
RUN chown -R app:app $HOME/*

# Set the user id
USER app

WORKDIR $HOME/
RUN npm install

EXPOSE ${APP_PORT}


###############################################################################
#                                    End                                      #
###############################################################################
