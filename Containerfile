from docker.io/rust:latest as aquatic-build
run cargo install --version 0.1.0 aquatic

from debian as aquatic
LABEL org.opencontainers.image.authors="AkhIL <akhilman@gmail.com>"
copy --from=aquatic-build /usr/local/cargo/bin/aquatic /app/

from aquatic as aquatic-http
expose 3000/tcp
user nobody
entrypoint ["/app/aquatic", "http"]
