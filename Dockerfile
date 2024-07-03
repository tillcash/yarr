# Stage 1: Build
FROM golang:1.23rc1-bullseye AS build

# Set the working directory
WORKDIR /src

# Install build dependencies
RUN apt-get update && apt-get install -y build-essential git

# Clone the repository
RUN git clone --depth 1 https://github.com/nkanaev/yarr .

# Build the application
RUN GOARCH="amd64" GOOS="linux" make build_default

# Stage 2: Create the final image
FROM gcr.io/distroless/base-debian12

# Copy the built application from the build stage
COPY --from=build /src/_output/yarr /yarr

# Set the volume
VOLUME /data

# Set the entry point and default command
ENTRYPOINT ["/yarr"]
CMD ["-addr", "0.0.0.0:7070", "-db", "/data/yarr.db"]
