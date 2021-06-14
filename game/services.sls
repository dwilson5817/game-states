---
# CREATE MULTICRAFT SERVICE FILE
# Create service file to manage the Multicraft daemon software.  This isn't included by default when installing
# Multicraft so we need to create and start it using Salt.
multicraft_service_file:
  file.managed:
    - name: /etc/systemd/system/multicraft.service
    - user: root
    - group: root
    - mode: 0644
    - contents: |
        [Unit]
        Description=Multicraft Daemon
        After=network.target remote-fs.target nss-lookup.target

        [Service]
        Type=forking
        PIDFile=/opt/multicraft/multicraft.pid
        ExecStart=/opt/multicraft/bin/multicraft -v start
        ExecReload=/opt/multicraft/bin/multicraft -v restart
        ExecStop=/opt/multicraft/bin/multicraft -v stop

        [Install]
        WantedBy=multi-user.target

# START MULTICRAFT SERVICE
# After creating the Multicraft daemon service it won't be started automatically.  If the deployment of the service file
# completed successfully, we should ensure it is started.
multicraft_service:
  service.running:
    - name: multicraft
    - enable: True
    - requires:
      - file: multicraft_service_file
