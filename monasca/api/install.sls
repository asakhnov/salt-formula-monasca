{%- from "monasca/map.jinja" import api with context %}

include:
- monasca.common

monasca_api_jar:
  file.managed:
  - name: /opt/monasca/monasca-api.jar
  - source: {{ api.source }}
  - source_hash: {{ api.source_hash }}
  - user: root
  - group: root
  - mode: 644

user_monasca_api:
  user.present:
  - name: mon-api
  - shell: /bin/false
  - home: /var/lib/monasca
  - system: True
  - groups:
    - monasca

/var/log/monasca/api:
  file.directory:
  - user: mon-api
  - group: monasca
  - mode: 755
  - makedirs: True
  - require:
    - user: user_monasca_api

monasca_api_upstart:
  file.managed:
  - name: /etc/init/monasca-api.conf
  - source: salt://monasca/files/upstart/monasca-api.conf
  - template: jinja
  - user: root
  - group: root
  - mode: 644
