# danbelden/alpine-logstash79

A docker image to run logtash 7.9 on an alpine base image with the logtash GCP pubsub plugin.

- Alpine
- Logstash 7.9.2
- Logstash GCP Pubsub plugin

## Examples

### Docker

```
$ docker run -it danbelden/alpine-logstash79-pubsub --version
logstash 7.9.2
```
```
$ docker run -it danbelden/alpine-logstash79-pubsub logstash-plugin list
...
logstash-input-google_pubsub
...
```

