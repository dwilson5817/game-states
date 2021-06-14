---
{%- for i in range(salt['pillar.get']('multicraft:total_servers', 1)) %}
{%- set n = i + 1 %}

# SET SERVER DIRECTORY PERMISSIONS
# For each server directory, all files should be owned by the mcx user where x is the server number.  These directories
# including the parent should be created already by Multicraft but if they are not, these states won't be run (i.e.
# Multicraft hasn't yet been installed).
server{{ n }}_dir:
  file.directory:
    - name: /opt/multicraft/servers/server{{ n }}
    - user: mc{{ n }}
    - group: mc{{ n }}
    - recurse:
      - user
      - group
    - onlyif:
      - fun: file.directory_exists
        args:
          - /opt/multicraft/servers

{% endfor %}
