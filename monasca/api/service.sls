{%- from "monasca/map.jinja" import api with context %}

include:
- monasca.api.config

monasca_api_service:
  service.running:
  - name: {{ api.service_name }}
  - enable: True
  - watch:
    - file: monasca_api_config
    - file: monasca_api_upstart
