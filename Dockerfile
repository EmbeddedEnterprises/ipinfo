# First stage - burrow
FROM embeddedenterprises/burrow as builder
RUN apk add build-base
# Workaround for burrow not being able to clone this repo
RUN go get -d github.com/EmbeddedEnterprises/ipinfo
WORKDIR ${GOPATH}/src/github.com/EmbeddedEnterprises/ipinfo
RUN burrow e && burrow b && burrow i
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
