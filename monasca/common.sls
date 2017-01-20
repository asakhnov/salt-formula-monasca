{%- from "monasca/map.jinja" import common with context %}

java:
  pkg.installed:
  - name: {{ common.java }}
  - refresh: True

jar_path:
  file.directory:
  - name: /opt/monasca
  - user: root
  - group: root
  - mode: 755
  - makedirs: True

group_monasca:
  group.present:
  - name: monasca
  - system: True
