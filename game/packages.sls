---
# INSTALL PREREQUISITE PACKAGES
# Install packages required to install Multicraft and run Minecraft servers.  This includes Java to run the Minecraft
# server software, Redis to allow for communication between servers and (un)zip to compress backups.
prereq_packages:
  pkg.installed:
    - pkgs:
      - default-jdk
      - redis
      - unzip
      - zip
