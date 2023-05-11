FROM rust:1.69 as BUILDER

WORKDIR /src/mirrorlist-server

COPY . .

RUN cargo build --release

FROM openeuler/openeuler:23.03

COPY --from=BUILDER /src/mirrorlist-server/start.sh /opt/app/start.sh
COPY --from=BUILDER /src/mirrorlist-server/config /opt/app/config
COPY --from=BUILDER /src/mirrorlist-server/target/release/mirrorlist-server /opt/app/mirrorlist-server
COPY --from=BUILDER /src/mirrorlist-server/target/release/generate-mirrorlist-cache /opt/app/generate-mirrorlist-cache
RUN yum install -y libpq-devel

ENTRYPOINT ["/opt/app/start.sh"]
