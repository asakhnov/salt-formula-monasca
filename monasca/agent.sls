{%- from "monasca/map.jinja" import monasca with context %}

monasca_agent_package:
  pkg.installed:
    - name: {{ monasca.agent.pkg_name }}
    - refresh: True

monasca_agent_config:
  file.managed:
  - name: {{ monasca.agent.conf }}
  - source: salt://monasca/files/{{ monasca.version }}/agent.yaml
  - user: mon-agent
  - group: monasca
  - mode: 640
  - template: jinja
  - require:
    - pkg: monasca_agent_package

monasca_agent_service:
  service.running:
  - name: {{ monasca.agent.svc_name }}
  - enable: True
  - watch:
    - file: monasca_agent_config
