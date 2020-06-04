# Developing with Vagrant

If you don't have a server to test against, you can use Vagrant to test HomelabOS.

First you must [install Vagrant](https://www.vagrantup.com/downloads.html).

## Deploying to Vagrant

Simply run `make develop`. This will spin up a Vagrant machine, and provision it
with Ansible automatically.

Once the machine is provisioned, you can run `vagrant ssh` then from inside the VM run `ifconfig | grep inet`. This will list all IPs for the VM, and one of them will work to access the VM. You can try opening the IPs in a browser until one of them says `404 page not found`. This means you are hitting Traefik correctly.

The next step is to set up a host mapping. Edit your `/etc/hosts` file to contain an entry pointing `servicename.yourdomain` to the IP found above.

Now you should be able to hit `servicename.yourdomain` in a browser and have the service page served successfully by Traefik.

## Resetting Vagrant

Running `vagrant destroy` will erase your vagrant machine image, and let you start fresh.
