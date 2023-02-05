# deper-docker

| env                 | required | description                                                            | default value           |
| ------------------- | -------- | ---------------------------------------------------------------------- | ----------------------- |
| DERP_ADDR           | false    | server HTTPS listen address                                            | :443                    |
| DERP_HTTP_PORT      | false    | The port on which to serve HTTP(Set to -1 to disable)                  | 80                      |
| DERP_STUN_PORT      | false    | The UDP port on which to serve STUN                                    | 3478                    |
| DERP_CONFIG_PATH    | true     | config file path                                                       | /etc/derper/config.json |
| DERP_CERT_MODE      | false    | mode for getting a cert(possible options: manual, letsencrypt)         | letsencrypt             |
| DERP_CERT_DIR       | false    | directory to store certs                                               | /etc/derper/ssl         |
| DERP_HOSTNAME       | true     | host name                                                              | derp.tailscale.com      |
| DERP_RUN_STUN       | false    | whether to run a STUN server                                           | true                    |
| DERP_RUN_DERP       | false    | whether to run a DERP server                                           | true                    |
| DERP_VERIFY_CLIENTS | false    | verify clients to this DERP server through a local tailscaled instance | false                   |
