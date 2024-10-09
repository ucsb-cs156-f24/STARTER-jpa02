FROM bellsoft/liberica-openjdk-alpine:21

WORKDIR /app

ENV NODE_VERSION=20.17.0
RUN apk add --no-cache curl bash maven libstdc++ \
    && curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash

ENV NVM_DIR=/root/.nvm
ENV PATH="$NVM_DIR/versions/node/v${NODE_VERSION}/bin:$PATH"

RUN bash -c ". $NVM_DIR/nvm.sh && nvm install $NODE_VERSION && nvm alias default $NODE_VERSION && nvm use default"

RUN node --version
RUN npm --version

COPY src /home/app/src
COPY lombok.config /home/app
COPY pom.xml /home/app

RUN mvn -B -DskipTests -f /home/app/pom.xml clean package

ENTRYPOINT ["sh", "-c", "java -jar /home/app/target/*.jar"]