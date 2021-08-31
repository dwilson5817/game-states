---
{%- set testing = salt['pillar.get']('testing') %}
{% if not testing %}

# GET LET'S ENCRYPT CERTIFICATE
# Use the Let's Encrypt CloudFlare plugin to get a TLS certificate.  When in testing, we use the Let's Encrypt staging
# server to confirm everything is correctly configured but prevent generating a real TLS certificate.
letsencrypt_cert:
  acme.cert:
    - name: {{ grains['id'] }}.dylanw.net
    - email: webmaster@dylanw.net
    - dns_plugin: cloudflare
    - dns_plugin_credentials: /root/.secrets/certbot/cloudflare.ini
    - require:
      - file: cloudflare_ini

{% endif %}

# DOWNLOAD WINGS BINARY
# Get the latest Wings binary from GitHub.  The Pterodactyl team helpfully provides us with a checksums.txt file every
# release, which works directly with the source_hash option.
wings_binary:
  file.managed:
    - name: /usr/local/bin/wings
    - source: https://github.com/pterodactyl/wings/releases/latest/download/wings_linux_amd64
    - source_hash: https://github.com/pterodactyl/wings/releases/latest/download/checksums.txt
    - mode: 744

# WINGS CONFIG DIRECTORY
# Create the Wings config directory if it doesn't exist.  The config.yml file will be placed here but requires
# authentication to generate and would require too much work to automate so will be placed here manually.
wings_config_dir:
  file.directory:
    - name: /etc/pterodactyl
    - user: root
    - group: root
    - mode: 755

# CREATE WINGS SERVICE FILE
# Create service file to manage the Pterodactyl Wings daemon software.  This file uses the recommended configuration as
# provided by the Pterodactyl docs.
wings_service_file:
  file.managed:
    - name: /etc/systemd/system/multicraft.service
    - user: root
    - group: root
    - mode: 644
    - contents: |
        [Unit]
        Description=Pterodactyl Wings Daemon
        After=docker.service
        Requires=docker.service
        PartOf=docker.service

        [Service]
        User=root
        WorkingDirectory=/etc/pterodactyl
        LimitNOFILE=4096
        PIDFile=/var/run/wings/daemon.pid
        ExecStart=/usr/local/bin/wings
        Restart=on-failure
        StartLimitInterval=180
        StartLimitBurst=30
        RestartSec=5s

        [Install]
        WantedBy=multi-user.target

# START WINGS SERVICE
# After creating the Pterodactyl Wings service it won't be started automatically.  If the deployment of the service file
# completed successfully, we should ensure it is started.
wings_service:
  service.running:
    - name: multicraft
    - enable: true
    - requires:
      - file: wings_service_file
