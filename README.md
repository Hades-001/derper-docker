# deper-docker

| env                 | required | description                                                            | default value     |
| ------------------- | -------- | ---------------------------------------------------------------------- | ----------------- |
| DERP_DOMAIN         | true     | derper server hostname                                                 | your-hostname.com |
| DERP_CERT_MODE      | false    | mode for getting a cert. possible options: manual, letsencrypt         | letsencrypt       |
| DERP_CERT_DIR       | false    | directory to store LetsEncrypt certs(if addr's port is :443)           | /etc/ssl          |
| DERP_ADDR           | false    | listening server address                                               | :443              |
| DERP_STUN           | false    | also run a STUN server                                                 | true              |
| DERP_STUN_PORT      | false    | The port on which to serve STUN                                        | 3478              |
| DERP_HTTP_PORT      | false    | The port on which to serve HTTP. Set to -1 to disable                  | 80                |
| DERP_VERIFY_CLIENTS | false    | verify clients to this DERP server through a local tailscaled instance | false             |
