FROM hosh/ubuntu-uid:18.04

# ARG DOWNLOAD_URL=https://beta.unity3d.com/download/dad990bf2728/UnitySetup-2018.2.7f1
# ARG SHA1=13c24c5268a1a97e1e212321dc47a8890f0934ca

ARG DOWNLOAD_URL=https://beta.unity3d.com/download/292b93d75a2c/UnitySetup-2019.1.0f2
ARG SHA1=56711ddafdde2554a7782c846785767e07ebdc5d

RUN apt-get update -qq; \
    DEBIAN_FRONTEND=noninteractive apt-get install -qq -y \
    ffmpeg \
    gconf-service \
    lib32gcc1 \
    lib32stdc++6 \
    libasound2 \
    libc6 \
    libc6-i386 \
    libcairo2 \
    libcap2 \
    libcups2 \
    libarchive13 \
    libasound2 \
    libdbus-1-3 \
    libexpat1 \
    libfontconfig1 \
    libfreetype6 \
    libgcc1 \
    libgconf2-4 \
    libgdk-pixbuf2.0-0 \
    libgl1-mesa-glx \
    libglib2.0-0 \
    libglu1-mesa \
    libgtk2.0-0 \
    libgtk-3-0 \
    libnspr4 \
    libnss3 \
    libpango1.0-0 \
    libsoup2.4 \
    libstdc++6 \
    libx11-6 \
    libxcomposite1 \
    libxcursor1 \
    libxdamage1 \
    libxext6 \
    libxfixes3 \
    libxi6 \
    libxrandr2 \
    libxrender1 \
    libxtst6 \
    zlib1g \
    debconf \
    npm \
    xdg-utils \
    lsb-release \
    libpq5 \
    xvfb \
    wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN wget -nv ${DOWNLOAD_URL} -O UnitySetup; \
    # compare sha1 if given
    chmod +x UnitySetup; \
    if [ -n "${SHA1}" -a "${SHA1}" != "" ]; then \
      echo "${SHA1}  UnitySetup" | shasum -a 1 --check -; \
    else \
      echo "no sha1 given, skipping checksum"; \
    fi && \
    # install unity
    yes | ./UnitySetup --verbose --unattended \
        --components=Unity \
        -l /opt/Unity && \
    yes | ./UnitySetup --verbose --unattended \
        --components=Android \
        -l /opt/Unity && \
    yes | ./UnitySetup --verbose --unattended \
        --components=iOS \
        -l /opt/Unity && \
    yes | ./UnitySetup --verbose --unattended \
        --components=Mac-Mono \
        -l /opt/Unity && \
    yes | ./UnitySetup --verbose --unattended \
        --components=WebGL \
        -l /opt/Unity && \
    yes | ./UnitySetup --verbose --unattended \
        --components=Windows-Mono \
        -l /opt/Unity && \
    yes | ./UnitySetup --verbose --unattended \
        --components=Facebook-Games \
        -l /opt/Unity && \
    # remove setup
    rm UnitySetup && \
    rm -rf /tmp/* /var/tmp/* && \
    # make a directory for the certificate Unity needs to run
    mkdir -p $HOME/.local/share/unity3d/Certificates/

ADD CACerts.pem $HOME/.local/share/unity3d/Certificates/
ADD combined_entry.sh write_license_file.sh build_target.sh xvfb_runtests.sh /
ENTRYPOINT ["/combined_entry.sh"]
