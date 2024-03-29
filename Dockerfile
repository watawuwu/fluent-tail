FROM watawuwu/rust:1.36 AS builder

ADD Makefile .
ADD Cargo.toml .
ADD Cargo.lock .

RUN mkdir src && \
echo 'fn main(){}' >  src/main.rs && \
cargo fetch

COPY . .

RUN make deps release-build TARGET="x86_64-unknown-linux-musl"

FROM alpine:3.10

RUN apk upgrade --update-cache --available && \
  apk add openssl && \
  rm -rf /var/cache/apk/*

COPY --from=builder /home/rust/work/target/x86_64-unknown-linux-musl/release/fluent-tail /bin/fluent-tail

CMD ["/bin/fluent-tail"]
