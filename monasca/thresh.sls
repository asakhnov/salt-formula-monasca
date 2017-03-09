{%- from "monasca/map.jinja" import monasca with context %}

monasca_thresh_package:
  pkg.installed:
    - name: {{ monasca.thresh.pkg_name }}
    - refresh: True

monasca_thresh_config:
  file.managed:
  - name: {{ monasca.thresh.conf }}
  - source: salt://monasca/files/{{ monasca.version }}/thresh-config.yml
  - user: mon-thresh
  - group: monasca
  - mode: 640
  - template: jinja
  - require:
    - pkg: monasca_thresh_package

monasca_thresh_service:
  service.running:
  - name: {{ monasca.thresh.svc_name }}
  - enable: True
  - watch:
    - file: monasca_thresh_config
