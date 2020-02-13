FROM envoyproxy/envoy:v1.13.0
COPY ./envoy.yaml /etc/envoy/envoy.yaml
COPY ./proto.pb /tmp/envoy/proto.pb
CMD /usr/local/bin/envoy -c /etc/envoy/envoy.yaml -l trace --log-path /tmp/envoy_info.log
