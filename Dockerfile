FROM ubuntu:18.04

RUN apt-get update -qq

ENV ANDROID_HOME /opt/android-sdk-linux

# ------------------------------------------------------
# --- Install required tools

RUN apt-get update -qq

# Base (non android specific) tools
# -> should be added to bitriseio/docker-bitrise-base

# Dependencies to execute Android builds
RUN dpkg --add-architecture i386
RUN apt-get update -qq
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y openjdk-8-jdk libc6:i386 libstdc++6:i386 libgcc1:i386 \
 libncurses5:i386 libz1:i386 net-tools wget unzip gradle qemu qemu-kvm libvirt-bin ubuntu-vm-builder bridge-utils curl python3-pip

# RUN curl -sL https://deb.nodesource.com/setup_12.x |bash -
# RUN apt-get install -y nodejs

# RUN npm install --global pm2


# RUN adduser root kvm
# ------------------------------------------------------
# --- Download Android Command line Tools into $ANDROID_HOME



RUN cd /opt \
    && wget -q https://dl.google.com/android/repository/commandlinetools-linux-6609375_latest.zip -O android-commandline-tools.zip \
    && mkdir -p ${ANDROID_HOME}/cmdline-tools \
    && unzip -q android-commandline-tools.zip -d ${ANDROID_HOME}/cmdline-tools \
    && rm android-commandline-tools.zip

ENV PATH ${PATH}:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/cmdline-tools/tools/bin::${ANDROID_HOME}/emulator


# ------------------------------------------------------
# --- Install Android SDKs and other build packages

# Other tools and resources of Android SDK
#  you should only install the packages you need!
# To get a full list of available options you can use:
#  RUN sdkmanager --list
RUN yes | sdkmanager  --licenses

RUN touch /root/.android/repositories.cfg

# Emulator and Platform tools
RUN yes | sdkmanager "emulator" "platform-tools"

RUN yes | sdkmanager --update --channel=3
# Please keep all sections in descending order!
RUN yes | sdkmanager \
    "system-images;android-30;google_apis_playstore;x86"\
    "platforms;android-30" \
    # "platforms;android-29" \
    # "platforms;android-28" \
    # "platforms;android-27" \
    # "platforms;android-26" \
    # "platforms;android-25" \
    # "platforms;android-24" \
    # "platforms;android-23" \
    # "platforms;android-22" \
    # "platforms;android-21" \
    # "platforms;android-19" \
    # "platforms;android-17" \
    # "platforms;android-15" \
    "build-tools;30.0.0" \
    # "build-tools;29.0.3" \
    # "build-tools;29.0.2" \
    # "build-tools;29.0.1" \
    # "build-tools;29.0.0" \
    # "build-tools;28.0.3" \
    # "build-tools;28.0.2" \
    # "build-tools;28.0.1" \
    # "build-tools;28.0.0" \
    # "build-tools;27.0.3" \
    # "build-tools;27.0.2" \
    # "build-tools;27.0.1" \
    # "build-tools;27.0.0" \
    # "build-tools;26.0.2" \
    # "build-tools;26.0.1" \
    # "build-tools;25.0.3" \
    # "build-tools;24.0.3" \
    # "build-tools;23.0.3" \
    # "build-tools;22.0.1" \
    # "build-tools;21.1.2" \
    # "build-tools;19.1.0" \
    # "build-tools;17.0.0" \
    # "system-images;android-29;google_apis;x86" \
    # "system-images;android-28;google_apis;x86_64" \
    # "system-images;android-26;google_apis;x86" \
    # "system-images;android-25;google_apis;armeabi-v7a" \
    # "system-images;android-25;google_apis;x86" \
    # "system-images;android-24;default;armeabi-v7a" \
    # "system-images;android-22;default;armeabi-v7a" \
    # "system-images;android-19;default;armeabi-v7a" \
    "extras;android;m2repository" \
    "extras;google;m2repository" \
    "extras;google;google_play_services" \
    "extras;m2repository;com;android;support;constraint;constraint-layout;1.0.2" \
    "extras;m2repository;com;android;support;constraint;constraint-layout;1.0.1" \
    # "add-ons;addon-google_apis-google-30" \
    "add-ons;addon-google_apis-google-23" \
    "add-ons;addon-google_apis-google-22" \
    "add-ons;addon-google_apis-google-21"


RUN avdmanager create avd -n test -d pixel_3 -k "system-images;android-30;google_apis_playstore;x86"

EXPOSE 5000

RUN mkdir /app


WORKDIR /app


COPY app-debug.apk /app/
COPY docker-entrypoint.sh /app/

RUN chmod +x -R /app/docker-entrypoint.sh

CMD /app/docker-entrypoint.sh
