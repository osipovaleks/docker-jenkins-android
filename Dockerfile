FROM ubuntu:18.04

LABEL author="osipovaleks"
LABEL maintainer="osipov.aleks.kr@gmail.com"
LABEL version="1.0"
LABEL description="Docker image for Jenkins with Android SDK"

ARG android_home_dir=/var/lib/android-sdk/
ARG sdk_tools_zip_file=sdk-tools-linux-4333796.zip
ARG jenkins_home_dir=/var/lib/jenkins/


RUN apt-get update && apt-get install -y git wget unzip openjdk-8-jdk-headless


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
USER jenkins
WORKDIR /home/jenkins


RUN wget http://mirrors.jenkins.io/war-stable/latest/jenkins.war -nv
CMD java -jar jenkins.war

EXPOSE 8080/tcp
