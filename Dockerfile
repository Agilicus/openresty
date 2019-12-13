FROM ubuntu:18.04
LABEL maintainer="don@agilicus.com"

# This scary-looking variable only causes apt-key to not warn on the
# output not being stdout (output should not be parsed).
ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn

FROM ubuntu:18.04
RUN \
    apt-get update && \
    apt-get install -y wget gnupg2 && \
    wget -qO - https://openresty.org/package/pubkey.gpg | apt-key add - && \
    echo deb http://openresty.org/package/ubuntu bionic main | tee -a /etc/apt/sources.list && \
    apt-get update && \
    apt-get -y install openresty && \
    opm install p0pr0ck5/lua-resty-waf

