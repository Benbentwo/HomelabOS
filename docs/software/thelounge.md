# TheLounge

[TheLounge](https://thelounge.chat/) is a web based IRC client that syncs nicely across devices, and stays online
when you aren't.

## Configuration

To turn TheLounge from a public instance to a private (highly recommended) run the following commands
on your server. Run `sed -i 's/public: true/public: false/' {{ volumes_root }}/thelounge/config.js`, then
restart the container with `docker restart homelabos_thelounge_1`, then create a user with
`docker exec -it homelabos_thelounge_1 thelounge add <username>` and follow the prompts.

Now you should be able to login with the username and password you created at the URLs below,
and have your session automatically sync between multiple devices.

## Access

The dashboard is available at [https://{% if thelounge.domain %}{{ thelounge.domain }}{% else %}{{ thelounge.subdomain + "." + domain }}{% endif %}/](https://{% if thelounge.domain %}{{ thelounge.domain }}{% else %}{{ thelounge.subdomain + "." + domain }}{% endif %}/) or [http://{% if thelounge.domain %}{{ thelounge.domain }}{% else %}{{ thelounge.subdomain + "." + domain }}{% endif %}/](http://{% if thelounge.domain %}{{ thelounge.domain }}{% else %}{{ thelounge.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ thelounge.subdomain + "." + tor_domain }}/](http://{{ thelounge.subdomain + "." + tor_domain }}/)
{% endif %}
