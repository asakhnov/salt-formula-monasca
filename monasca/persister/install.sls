{%- from "monasca/map.jinja" import persister with context %}

include:
- monasca.common

monasca_persister_jar:
  file.managed:
  - name: /opt/monasca/monasca-persister.jar
  - source: {{ persister.source }}
  - source_hash: {{ persister.source_hash }}
  - user: root
  - group: root
  - mode: 644

user_monasca_persister:
  user.present:
  - name: mon-persister
  - shell: /bin/false
  - home: /var/lib/monasca
  - system: True
  - groups:
    - monasca

/var/log/monasca/persister:
  file.directory:
  - user: mon-persister
  - group: monasca
  - mode: 755
  - makedirs: True
  - require:
    - user: user_monasca_persister

monasca_persister_upstart:
  file.managed:
  - name: /etc/init/monasca-persister.conf
  - source: salt://monasca/files/upstart/monasca-persister.conf
  - template: jinja
  - user: root
  - group: root
  - mode: 644
