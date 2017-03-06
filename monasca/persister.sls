{%- from "monasca/map.jinja" import monasca with context %}

monasca_persister_package:
  pkg.installed:
    - name: {{ monasca.persister.pkg_name }}
    - refresh: True

monasca_persister_config:
  file.managed:
  - name: {{ monasca.persister.conf }}
  - source: salt://monasca/files/{{ monasca.version }}/persister-config.yml
  - user: mon-persister
  - group: monasca
  - mode: 640
  - template: jinja
  - require:
    - pkg: monasca_persister_package

monasca_persister_service:
  service.running:
  - name: {{ monasca.persister.svc_name }}
  - enable: True
  - watch:
    - file: monasca_persister_config
