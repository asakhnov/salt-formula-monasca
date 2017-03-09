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

# Plugins
{%- for plugin, args in monasca.agent.get('plugins', {}).items() %}
monasca_agent_plugin_{{ plugin }}:
  file.managed:
  - name: /etc/monasca/agent/conf.d/{{ plugin }}.yaml
  - source: salt://monasca/files/{{ monasca.version }}/agent-plugins/{{ plugin }}.yaml
  - user: mon-agent
  - group: monasca
  - mode: 640
  - template: jinja
  - watch_in:
    - service: monasca_agent_service
{%- endfor %}
