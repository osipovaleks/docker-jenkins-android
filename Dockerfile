#FROM alpine:3.8
FROM ubuntu:18.04
MAINTAINER osipovaleks

ARG android_home_dir=/var/lib/android-sdk/
ARG sdk_tools_zip_file=sdk-tools-linux-4333796.zip
ARG jenkins_home_dir=/var/lib/jenkins/


#RUN apk update
#RUN apk upgrade
#RUN apk --no-cache add openjdk8
#RUN apk --no-cache add ttf-dejavu
#RUN apk --no-cache add git
#RUN apk --no-cache add unzip
#RUN apk --no-cache add openssh

RUN apt-get update
RUN apt-get full-upgrade -y
RUN apt-get install openjdk-8-jdk-headless -y
#RUN apt-get install ttf-dejavu
RUN apt-get install git -y
RUN apt-get install unzip -y
RUN apt-get install wget -y
#RUN apt-get install openssh


#this is debug, remove later
#RUN apk --no-cache add mc htop
RUN apt-get install mc htop -y


RUN mkdir $android_home_dir
RUN wget https://dl.google.com/android/repository/$sdk_tools_zip_file -P $android_home_dir
RUN unzip $android_home_dir$sdk_tools_zip_file -d $android_home_dir
RUN rm $android_home_dir$sdk_tools_zip_file
RUN chmod 777 -R $android_home_dir


ENV ANDROID_HOME=$android_home_dir
ENV PATH="${PATH}:$android_home_dir/tools/bin:$android_home_dir/platform-tools"
#ENV JAVA_HOME=/usr/lib/jvm/java-1.8-openjdk/
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/



RUN yes | sdkmanager --licenses


RUN mkdir $jenkins_home_dir
RUN chmod 777 $jenkins_home_dir
ENV JENKINS_HOME=$jenkins_home_dir


RUN adduser --disabled-password jenkins
USER jenkins
WORKDIR /home/jenkins


RUN wget http://mirrors.jenkins.io/war-stable/latest/jenkins.war
CMD java -jar jenkins.war

EXPOSE 8080
