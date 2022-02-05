from docker.io/rust:latest as aquatic-build
run cargo install --version 0.1.0 aquatic_udp

from aquatic-build as aquatic-udp
LABEL org.opencontainers.image.authors="AkhIL <akhilman@gmail.com>"
copy --from=aquatic-build /usr/local/cargo/bin/aquatic_udp /app/
expose 3000/udp
user nobody
entrypoint ["/app/aquatic_udp"]
