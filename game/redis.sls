---
# INSTALL REDIS
# Redis is used by some plugins to communicate between servers.  This could be run via Pterodactyl in a Docker container
# but it's easiest to simply install it on the host.
install_redis:
  pkg.installed:
    - pkgs:
      - redis
