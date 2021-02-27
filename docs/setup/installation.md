# Installation

!!! Warning "Beta Software Warning"

    This software has not reached version 1.0 and should therefore be considered unstable. While any tagged version should work well on its own, a nice friendly upgrade path from one version to another is not guaranteed.

    If you like getting your hands dirty in early versions of software, this is for you. If you prefer to wait till things are stable and friendly, maybe hold off for a while.

    Also, if you trash your server or wreck your data, that's on you. Test your backups. Trust nothing.

## Requirements

### Server

- Ubuntu Server 20.04 or Debian 10.3
- `sudo` must be available
- [Passwordless SSH via SSH keys](https://linuxconfig.org/passwordless-ssh) working.

!!! Warning
    If you are running on an ARM infrastructure such as Raspberry PI, set `arm` to true. Run: `hlos set arm True`

## Optional Items

### Client Computer

* Docker installed and working.

!!! Note
    Two separate computers are not required, but are highly recommended. The idea is you have a server and then your personal computer, say a laptop or desktop. You deploy from your personal computer to the server. This way your settings are saved on your personal computer, and can be used to re-build the server and restore from backups if anything goes wrong.

!!! Warning
    If you do install HomelabOS directly on the server and deploy from there, make sure to back up your `settings/` folder from the server to somewhere safe, otherwise you could lose your settings.

### Domain Name

A domain configured with a `A` type DNS record of `*.yourdomain.com` pointed at your server's IP address. You can also use a subdomain as well, so `*.homelab.yourdomain.com` would work.

!!! Note
    This is optional because you can use Tor to access your services without registering a domain. For best support from 3rd party clients an actual domain is highly recommended. Also certain services do not work through TOR at the moment.

!!! Note
    It's easiest to have an actual domain to point at your services, but you can `fake` it by adding DNS overrides to your `/etc/hosts` file on *nix and MacOS if needed or for testing.

#### DNS Settings

You need to point your `{{ domain }}`, as well as `*.{{ domain }}` to the IP address your HomelabOS install is accessible at. If you are using a [bastion](/docs/setup/bastion) host, then you would point at that IP. If you are using your home IP address, you would point it at that IP. You need to set up a wildcard DNS entry because all the services are served off of subdomains such as `{% if emby.domain %}{{ emby.domain }}{% else %}{{ emby.subdomain + "." + domain }}{% endif %}`

!!! Warning
    If you are not using a real domain, but using `/etc/hosts` entries to 'fake' it, wildcard entries do not work in `/etc/hosts`. You need to create an entry for each service enabled. You can use the `/var/homelabos/homelab_hosts` file.

#### Changing your domain

If you need to change your domain (or subdomain) simply run `hlos set domain new.domain.com` then run `make deploy` again.

### Port Forwarding

Ports 80 and 443 punched through any firewalls and port forwarded at your server in question.

!!! Note
    This is optional because if you are using the [bastion](bastion.md) server or [TOR access](tor.md), you do not need to deal with port forwarding or firewalls.

### [Cloud Bastion Server](bastion.md)

Rather than pointing the domain at your home IP and having to manage DDNS, you can utilize a cloud server
to act as a bastion host via Tinc vpn and nginx.

### S3 Account

S3 is Amazon's Simple Storage Service which HomelabOS can optionally use to back up to. You can use Amazon's service, or one of many other S3 compatible providers. You can also back up to another HomelabOS instance if that other instance is running Minio, a self-hosted S3 service.

## Installation

[Video Installation Tutorial](https://youtu.be/lbmViEFTj4o)

### Automatic Set-up (One-liner)

* On your server run: `bash <(curl -s https://gitlab.com/NickBusey/HomelabOS/-/raw/master/install_homelabos.sh)`

* Make sure to back up your `{{ volumes_root }}/install` directory nightly.

#### But isn't piping bash to curl insecure?

Not really. If you're using https (we are), then you can be sure you're getting the file you expect.

This is also the recommended installation method of:

* [Rust](https://www.rust-lang.org/tools/install)
* [homebrew](https://brew.sh/)
* [RVM](https://rvm.io/rvm/install).
* [Docker](https://get.docker.com/)
* [DockSTARTer](https://dockstarter.com/)

It's pretty standard practice at this point.

If you still don't trust it, great, you'll fit right in here. Proceed to the Manual Set-up step below.

### Manual Set-up

* Download the [latest version](https://gitlab.com/NickBusey/HomelabOS/-/releases) to your client computer and extract the folder. From inside the folder run `./hlos install_cli` now you can run `hlos` directly. Otherwise just append `./` to the `hlos` commands listed below.

!!! Note
    If you are using HomelabOS to provision a [bastion](bastion.md) server, run: `$ hlos terraform`

* From inside the HomelabOS folder, set up the initial config: `hlos config`

!!! Note
    You will be prompted for the basic information to get started. The passwords entered here will be stored on the client computer and are used by ansible to configure your server. After you enter the information, HomelabOS will configure your local docker images and build your initial `settings/` files.

* Once you have updated your settings simply deploy HomelabOS with `make deploy`. You can run `make deploy` as many times as needed to get your settings correct.

You can check http://{{ homelab_ip }}:8181 in a browser to see the Traefik dashboard.

See a full list of commands in the [Getting Started Section](/docs/setup/gettingstarted)

## Enabling Services

Run `hlos set SERVICENAME.enable true` where SERVICENAME is the name of the service you want to enable.

!!! example
    `hlos set miniflux.enable true`

Then run `make deploy` again. That's it. It will take a few minutes for your server to download and start the relevant images.


!!! warning
    Some services expose set up pages on start up. If you don't complete the set up step, there is a chance someone else could beat you to it. If they do just run `hlos reset_one SERVICENAME` then `make deploy` again and the service will reset to it's freshly installed state.

You can SSH into the server, and run `systemctl status SERVICENAME` where SERVICENAME is the name of the server you want to check  is running. It will show you status and/or errors of the service.

!!! example
    `systemctl status miniflux`

## Syncing Settings via Git

HomelabOS will automatically keep the `settings/` folder in sync with a git repo if it has one.
So you can create a private repo on your Gitea instance for example, then clone that repo over the
settings folder. Now any changes you make to `settings/` files will be commited and pushed to that git
repo whenever you run `make deploy`, `hlos update` or `hlos config`.

## Backing up your Vault Password

!!! danger
    This bit is important.

If you installed with the Automatic/One-Liner install, your vault password exists at `~/.homelabos_vault_pass` for the user you ran the script as. Make sure to back this password up somewhere safe, and ideally _not_ in your `settings/` folder. If someone gains access to your `settings/` folder and the vault password, bad things can happen. Store them separately.

## [Troubleshooting / FAQ](faq.md)

## Network Configuration

It is recommended to register an actual domain to point at your Homelab, but if you can't or would prefer not to, you can use HomelabOS fully inside your network. Simply make up a domain that ends in `.local` and enter that as your domain in `host_vars/myserver`.

When HomelabOS `make deploy` command completes, it creates a file on the server at `{{ volumes_root }}/homelabos_hosts`. You can take the contents of this file and create local DNS overrides using it. All your requests should complete as expected.

## NAS Network Attached Storage Configuration

Different HomelabOS services operate on libraries of media (Airsonic, Plex, and Piwigo as examples). Since these libraries can be large, it makes sense to keep them on another machine with lots of storage.

NAS shares are mounted on the HomelabOS host under `{{ storage_dir }}`, which defaults to `/mnt/nas`. By default, NAS is disabled, and the services that can use it will instead use local folders under `{{ storage_dir }}`.

For example, [Emby](/software/emby) will map `{{ storage_dir }}/Video/TV` and `{{ storage_dir }}/Video/Movies` into its container, and [Paperless](/software/paperless) will mount `{{ storage_dir }}/Documents`. Check the `docker-compose` files for each service to see what directories are used.

To configure your NAS, edit the `# NAS Config` section of `settings/config.yml`.

1. Enable NAS by setting `nas_enable: True`
2. Set `nas_host` to the hostname, FQDN, or IP address of your NAS.
3. Choose your network share type (`nfs` or `smb`) and set `nas_share_type` to that value.
4. Set your `nas_share_path`, if applicable. SMB shares will probably not have a value for this, but NFS will.
5. If authenticating to access SMB shares, set your username and password in `nas_user` and `nas_path`.
6. Set your Windows domain in `nas_workgroup`, if applicable.

Re-run `make deploy` to configure and enable your NAS.

??? example "Example [unRAID](https://unraid.net) configuration"
    ```
    nas_enable: True
    nas_host: unraid.mydomain.com
    nas_mount_type: nfs
    nas_share_path: /mnt/user
    nas_user:
    nas_pass:
    nas_workgroup:
    ```

??? example "Example SMB configuration"
    ```
    nas_enable: True
    nas_host: 192.168.1.12
    nas_mount_type: smb
    nas_share_path: homelab
    nas_user: user
    nas_pass: 12345
    nas_workgroup: WORKGROUP
    ```
