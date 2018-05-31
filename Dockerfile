# First stage - burrow
FROM embeddedenterprises/burrow as builder
RUN go get github.com/EmbeddedEnterprises/ipinfo
WORKDIR ${GOPATH}/src/github.com/EmbeddedEnterprises/ipinfo
RUN burrow build
WORKDIR /data
RUN mv ${GOPATH}/bin/ipinfo /data/ipinfo

# Second stage - create statically linked binary
FROM scratch
LABEL service "ipinfo"
LABEL vendor "EmbeddedEnterprises"
LABEL maintainers "Martin Koppehel <mkoppehel@embedded.enterprises>"
WORKDIR /bin
COPY --from=builder /data/ipinfo /bin/ipinfo
ENTRYPOINT ["/bin/ipinfo"]
CMD []
