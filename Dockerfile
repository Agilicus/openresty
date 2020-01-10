FROM ubuntu:18.04 as build
LABEL maintainer="don@agilicus.com"
 
# This scary-looking variable only causes apt-key to not warn on the
# output not being stdout (output should not be parsed).
ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn
 
RUN \
    apt-get update && \
    apt-get install -y wget gnupg2 libpcre3-dev git luarocks python build-essential && \
    wget -qO - https://openresty.org/package/pubkey.gpg | apt-key add - && \
    echo deb http://openresty.org/package/ubuntu bionic main | tee -a /etc/apt/sources.list && \
    apt-get update && \
    apt-get -y install openresty && \
    opm get hamishforbes/lua-resty-iputils p0pr0ck5/lua-resty-cookie p0pr0ck5/lua-ffi-libinjection p0pr0ck5/lua-resty-logger-socket && \
    mkdir -p /src && \
    cd /src && \
    git clone https://github.com/p0pr0ck5/lua-resty-waf && \
    cd lua-resty-waf && \
    sed -i -e 's?-Werror??' src/Makefile && \
    git submodule init && \
    git submodule update && \
    make && \
    make install

FROM ubuntu:18.04
RUN \
    apt-get update && \
    apt-get install -y wget gnupg2 libpcre3 && \
    wget -qO - https://openresty.org/package/pubkey.gpg | apt-key add - && \
    echo deb http://openresty.org/package/ubuntu bionic main | tee -a /etc/apt/sources.list && \
    apt-get update && \
    apt-get -y install openresty && \
    mkdir -p /usr/local/openresty/site/lualib/rules/

COPY --from=build /usr/local/* /usr/local/
COPY --from=build /usr/local/openresty/* /usr/local/openresty/

