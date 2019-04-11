# ![HomelabOS](https://gitlab.com/NickBusey/HomelabOS/raw/master/logo.png)

Your very own offline-first open-source data-center!

## Beta Software Warning

This software has not reached version 1.0 and should therefore be considered unstable. While any tagged version should work well on its own, a nice friendly upgrade path from one version to another is not guaranteed.

If you like getting your hands dirty in early versions of software, this is for you. If you prefer to wait till things are stable and friendly, maybe hold off for a while.

Also, if you trash your server or wreck your data, that's on you. Test your backups. Trust nothing.

## [Documentation](https://nickbusey.gitlab.io/HomelabOS/)

## Summary

A set of Ansible scripts to configure a Docker based Homelab server with all sorts of goodies. Following the unix philosophy we gather together many specific tools to build the exact end result desired.

## Goals

To make it easy for anyone to own all their data in an easy and secure way, without the need of cloud providers.

## Features

* One command deployment
* Automated Backups
* Easy Restore
* Automated Apple Health Data import
* Automated Tor Onion Service access
* Automated HTTPS via LetsEncrypt
* OpenVPN
* OpenLDAP
* Cloud Bastion Server with Tinc VPN

### [Planned Features](https://gitlab.com/NickBusey/HomelabOS/issues?label_name%5B%5D=enhancement)

## Demo

![demo.gif](demo.gif)

### Local Demo

If you have the latest version of Vagrant and Virtual Box setup you can demo things locally by running `make develop`. This will spin up a temporary developer copy on your local computer without needing an actual server to point things at. Note no data will actually be saved from inside the VM, so this is for testing only.

## Available Software

* [Airsonic](https://airsonic.github.io/) - Airsonic is a free, web-based media streamer, providing ubiquitous access to your music.
* [Bitwarden](https://bitwarden.com/) - Password and secrets manager via [bitwarden-rs](https://github.com/dani-garcia/bitwarden_rs)
* [BookStack](https://www.bookstackapp.com/) - Simple & Free Wiki Software
* [BulletNotes](https://gitlab.com/NickBusey/BulletNotes.git) - Note taking application
* [Code-Server](https://github.com/codercom/code-server) - Run VS Code on a remote server.
* [Darksky](http://darksky.net/) - Local weather reported via [darksky-influxdb](https://github.com/ErwinSteffens/darksky-influxdb)
* [Dasher](https://github.com/maddox/dasher) - Amazon Dash button support
* [Documentation](https://nickbusey.gitlab.io/HomelabOS/) - Offline, searchable documentation via [MkDocs](https://www.mkdocs.org/)
* [Emby](https://emby.media/) - Personal Media Server
* [Firefly III](https://firefly-iii.org/) - Money management budgeting app
* [Gitea](https://gitea.io/en-US/) - Git hosting
* [Grafana](https://grafana.com/) - Pretty graphs
* [Home Assistant](https://www.home-assistant.io/) - Home Automation
* [Homedash](https://lamarios.github.io/Homedash2/) - Dashboard
* [InfluxDB](https://www.influxdata.com/time-series-platform/influxdb/) - Time series data storage
* [Inventario](https://gitlab.com/NickBusey/inventario) - Home inventory management
* [Jackett](https://github.com/Jackett/Jackett) - API Support for your favorite torrent trackers (helps Sonarr and Radarr)
* [Jellyfin](https://github.com/jellyfin/jellyfin) - The Free Software Media System
* [Kibitzr](https://kibitzr.github.io/) - IFTTT replacement
* [Mailserver](https://github.com/hardware/mailserver/) - Fully featured mail server
* [Mashio](https://gitlab.com/NickBusey/mashio) - Home brewery management software
* [Matomo](https://matomo.org/) - Web analytics
* [Minio](https://minio.io/) - S3 hosting
* [Miniflux](https://miniflux.app/) - Miniflux is a minimalist and opinionated feed reader.
* [Monica](https://www.monicahq.com/) - Contact / relationship manager
* [NextCloud](https://nextcloud.com/) - Private Cloud Storage, Calendar, Contacts, etc.
* [Organizr](https://github.com/causefx/Organizr) - Access all your HomelabOS services in one easy place.
* [Paperless](https://github.com/danielquinn/paperless) - Document management
* [phpLDAPadmin](https://github.com/osixia/docker-phpLDAPadmin) - LDAP management interface
* [Pi-hole](https://pi-hole.net/) - Ad blocking
* [Plex](https://www.plex.tv/) - Personal Media Server
* [Portainer](https://www.portainer.io/) - Easy Docker management
* [Radarr](https://radarr.video/) - Automated movie downloading
* [Sonarr](https://sonarr.tv/) - Automated TV downloading
* [Syncthing](https://syncthing.net/) - File syncing software
* [Telegraf](https://www.influxdata.com/time-series-platform/telegraf/) - Server statistics reporting
* [The Lounge](https://thelounge.chat/) - Always-on IRC client (IRC bouncer)
* [Transmission](https://transmissionbt.com/) - BitTorrent client

## Requirements

A server with:

* Ubuntu 18.04
* Passwordless SSH (with ssh keys) to a user that has passwordless sudo.

Ansible version 2.5+ installed on your computer (not the server).

## Optional Items

### Domain Name

A domain configured with a `A` type DNS record of `*.yourdomain.com` pointed at your server's IP address. (This is optional because you can use Tor to access your services without registering a domain. For best support from 3rd party clients an actual domain is highly recommended. Also certain services do not work through TOR at the moment.) Note you can hang this off a subdomain as well, so `*.homelab.yourdomain.com` will work as well.

### Port Forwarding

Ports 80 and 443 punched through any firewalls and port forwarded at your server in question. (This is also optional due to Tor access, but again highly recommended.)

### [Cloud Bastion Server](https://nickbusey.gitlab.io/HomelabOS/setup/tinc/)

Rather than pointing the domain at your home IP and having to manage DDNS, you can utilize a cloud server
to act as a bastion host via Tinc vpn and nginx.

## [Installation](https://nickbusey.gitlab.io/HomelabOS/setup/installation/)

## Get Support

* [File an issue](https://gitlab.com/NickBusey/HomelabOS/issues/new?issue%5Bassignee_id%5D=&issue%5Bmilestone_id%5D=)
* [Ask a question on Reddit](https://www.reddit.com/r/HomelabOS/)
* Chat on irc.freenode.net in #homelabos
* Threaded support and development discussion on [Zulip](https://homelabos.zulipchat.com/)

## Give Support

[Become a Supporter on Patreon](https://www.patreon.com/nickbusey)

## Contributing

Please do!

### Developing Locally

You can play around with the stack locally without needing an actual server to spin it up against.
First run `make config` as normal. The local IP and SSH username are not used for Vagrant, so they can be
for your real server, or fake. For `What is the domain you have pointed at your Homelab server with ports 80 and 443?:`
enter `localhost`.

Now run `make develop` to spin up a local instance inside a Vagrant machine.
For easy access to the services run `vagrant ssh -c "cat /var/homelabos/homelab_hosts"`. Append the output of this to your
machine's host file (usually `/etc/hosts`). Now you should be able to access http://servicename.localhost:2280/
where `servicename` is the name of any services you have enabled in `config.yml`.
If you make changes to the Ansible scripts you can run `make provision` to run them again.

To run just one set of tags you can do something like
`ansible-playbook --extra-vars="@config.yml" -i inventory -t tinc-nginx playbook.homelabos.yml`

### Working locally on the documentation

Follow the [MkDocs Material Theme setup directions](https://squidfunk.github.io/mkdocs-material/getting-started/).

Then run `mkdocs serve`.

To build changes to the docs run `make docs`.
