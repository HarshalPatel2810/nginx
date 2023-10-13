FROM golang:1.20 as builder

# Create source and release directory 
RUN mkdir -p /usr/src/app &&  mkdir -p /usr/local/bin/app/cert

# Set working directory to ./app
WORKDIR /usr/src/app

# Copy source code to source directory
COPY . .

# Copy certificate to release directory  [ temporary purpose]
#COPY ./cert /usr/local/bin/app/cert

# Install git package for downloading go modules
# RUN apk add git 


# To Download our go programs dependencies 
RUN go mod download 

# Build go application (this command will generate executable file)
# RUN go build -tags musl -o 
RUN CGO_ENABLED=0 GOOS=linux go build -o goservertest 

# Remove git package used for downloading go modules
# RUN apk del git 

# Move executable file to release directory 
RUN  mv ./goservertest /usr/local/bin/app

# Move Config Folder to release directory 
RUN  mv ./config /usr/local/bin/app

# Remove config.go file from config folder to /usr/local/bin/app path
RUN rm -rf /usr/local/bin/app/config/config.go

# Remove source directory 
RUN rm -fr /usr/src/app

FROM alpine:3.17.3

WORKDIR /app

COPY --from=builder /usr/local/bin/app .

# This Command will execute the executable file
CMD ["./goservertest"]
