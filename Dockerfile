FROM golang:1.23rc1-bullseye AS build

WORKDIR /src

RUN apt-get update && apt-get install -y build-essential git
RUN git clone --depth 1 https://github.com/nkanaev/yarr .

RUN GOARCH="amd64" GOOS="linux" make build_default

FROM gcr.io/distroless/base-debian12
COPY --from=build /src/_output/yarr /yarr
VOLUME /data
ENTRYPOINT ["/yarr"]
CMD ["-addr", "0.0.0.0:7070", "-db", "/data/yarr.db"]
