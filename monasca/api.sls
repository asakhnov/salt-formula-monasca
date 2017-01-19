{%- from "monasca/map.jinja" import api with context %}

java:
  pkg.installed:
  - name: {{ api.java }}
  - refresh: True

jar_path:
  file.directory:
  - name: /opt/monasca
  - user: root
  - group: root
  - mode: 755
  - makedirs: True

monasca_jar:
  file.managed:
  - name: /opt/monasca/monasca-api.jar
  - source: {{ api.source }}
  - source_hash: {{ api.source_hash }}
  - user: root
  - group: root
  - mode: 644
  - require:
    - pkg: java
    - file: jar_path

user_monasca_api:
  user.present:
  - name: mon-api
  - shell: /bin/false
  - home: /var/lib/monasca
  - system: True
  - groups:
    - monasca

group_monasca:
  group.present:
  - name: monasca
  - system: True
  - require_in:
    - user: user_monasca_api

/var/log/monasca/api:
  file.directory:
  - user: mon-api
  - group: monasca
  - mode: 755
  - makedirs: True
  - require:
    - user: user_monasca_api
    - group: group_monasca

monasca_api_upstart:
  file.managed:
  - name: /etc/init/monasca-api.conf
  - source: salt://monasca/files/upstart/monasca-api.conf
  - template: jinja
  - user: root
  - group: root
  - mode: 644

/etc/monasca/api:
  file.directory:
    - user: root
    - group: monasca
    - mode: 755
    - makedirs: True
    - require:
      - group: group_monasca

monasca_api_config:
  file.managed:
  - name: /etc/monasca/api/api-config.yml
  - source: salt://monasca/files/{{ api.version }}/api-config.yml
  - user: mon-api
  - group: monasca
  - mode: 640
  - template: jinja
  - require:
    - user: user_monasca_api
    - file: /etc/monasca/api

monasca_api_service:
  service.running:
  - name: {{ api.service_name }}
  - enable: True
  - watch:
    - file: monasca_api_config
    - file: monasca_api_upstart
