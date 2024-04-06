FROM tronprotocol/centos7:0.2

ENV JDK_TAR="jdk-8u202-linux-x64.tar.gz"
ENV JDK_DIR="jdk1.8.0_202"
ENV JDK_MD5="0029351f7a946f6c05b582100c7d45b7"
ENV BASE_DIR="/cypher"

RUN set -o errexit -o nounset \
    && yum -y install git wget \
    && wget -P /usr/local https://github.com/frekele/oracle-java/releases/download/8u202-b08/$JDK_TAR \
    && echo "$JDK_MD5 /usr/local/$JDK_TAR" | md5sum -c \
    && tar -zxf /usr/local/$JDK_TAR -C /usr/local\
    && rm /usr/local/$JDK_TAR \
    && export JAVA_HOME=/usr/local/$JDK_DIR \
    && export CLASSPATH=$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar \
    && export PATH=$PATH:$JAVA_HOME/bin \
    && mkdir -p $BASE_DIR \
    && cd $BASE_DIR \
    && git clone https://github.com/aravindhkm/cypher-node.git \
    && chmod +x ./cypher-node \
    && cd cypher-node \
    && ./gradlew build -x test \
    && cd build/libs \
    && chmod +x ./FullNode.jar \
    && cp FullNode.jar $BASE_DIR \
    && mv $JAVA_HOME/jre /usr/local \
    && rm -rf $JAVA_HOME \
    && yum clean all

ENV JAVA_HOME="/usr/local/jre"
ENV PATH=$PATH:$JAVA_HOME/bin

WORKDIR $BASE_DIR

CMD java -Xmx6g -XX:+HeapDumpOnOutOfMemoryError -jar /cypher/FullNode.jar --witness -c /cypher/cypher-node/supernode.conf