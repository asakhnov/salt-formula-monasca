{%- from "monasca/map.jinja" import monasca with context %}

monasca_api_package:
  pkg.installed:
    - name: {{ monasca.api.pkg_name }}
    - refresh: True

monasca_api_config:
  file.managed:
  - name: {{ monasca.api.conf }}
  - source: salt://monasca/files/{{ monasca.version }}/api-config.yml
  - user: mon-api
  - group: monasca
  - mode: 640
  - template: jinja
  - require:
    - pkg: monasca_api_package

monasca_api_service:
  service.running:
  - name: {{ monasca.api.svc_name }}
  - enable: True
  - watch:
    - file: monasca_api_config
