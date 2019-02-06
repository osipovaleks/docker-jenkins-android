FROM ubuntu:18.04


LABEL author="osipovaleks"
LABEL maintainer="osipov.aleks.kr@gmail.com"
LABEL version="1.0"
LABEL description="Docker image for Jenkins with Android SDK"



ARG android_home_dir=/var/lib/android-sdk/
ARG sdk_tools_zip_file=sdk-tools-linux-4333796.zip
ARG jenkins_home_dir=/var/lib/jenkins/

RUN dpkg --add-architecture i386
#RUN apt-get update && apt-get install -y git wget unzip sudo openjdk-8-jdk locales
RUN apt-get update && apt-get install -y git wget unzip sudo openjdk-8-jdk-headless
RUN apt-get install -y file git curl zip libncurses5:i386 libstdc++6:i386 zlib1g:i386
#RUN apt-get install -y libncurses5:i386 libc6:i386 libstdc++6:i386 lib32gcc1 lib32ncurses5 lib32z1 zlib1g:i386

RUN apt-get install -y locales


RUN apt-get clean && rm -rf /var/lib/apt/lists /var/cache/apt


RUN locale-gen en_US.UTF-8  



# Set the locale
#RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
#    locale-gen
#ENV LANG en_US.UTF-8  
#ENV LANGUAGE en_US:en  
#ENV LC_ALL en_US.UTF-8 


RUN mkdir $android_home_dir
RUN wget https://dl.google.com/android/repository/$sdk_tools_zip_file -P $android_home_dir -nv
RUN unzip $android_home_dir$sdk_tools_zip_file -d $android_home_dir
RUN rm $android_home_dir$sdk_tools_zip_file
RUN chmod 777 -R $android_home_dir


ENV ANDROID_HOME=$android_home_dir
ENV PATH="${PATH}:$android_home_dir/tools/bin:$android_home_dir/platform-tools"
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/



RUN yes | sdkmanager --licenses


RUN mkdir $jenkins_home_dir
RUN chmod 777 $jenkins_home_dir
ENV JENKINS_HOME=$jenkins_home_dir


RUN adduser --disabled-password --gecos "" jenkins
RUN adduser jenkins sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER jenkins
WORKDIR /home/jenkins


RUN wget http://mirrors.jenkins.io/war-stable/latest/jenkins.war -nv
CMD java -jar jenkins.war

EXPOSE 8080/tcp
