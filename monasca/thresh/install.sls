{%- from "monasca/map.jinja" import common,thresh with context %}

include:
- monasca.common

monasca_thresh_jar:
  file.managed:
  - name: /opt/monasca/monasca-thresh.jar
  - source: {{ thresh.source }}
  - source_hash: {{ thresh.source_hash }}
  - user: root
  - group: root
  - mode: 644

user_monasca_thresh:
  user.present:
  - name: mon-thresh
  - shell: /bin/false
  - home: /var/lib/monasca
  - system: True
  - groups:
    - monasca

/var/log/monasca/thresh:
  file.directory:
  - user: mon-thresh
  - group: monasca
  - mode: 755
  - makedirs: True
  - require:
    - user: user_monasca_thresh

monasca_thresh_systemv:
  file.managed:
  - name: /etc/init.d/monasca-thresh
  - source: salt://monasca/files/systemv/monasca-thresh
  - template: jinja
  - user: root
  - group: root
  - mode: 755
