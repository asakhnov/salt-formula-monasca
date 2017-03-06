{%- from "monasca/map.jinja" import common with context %}

group_monasca:
  group.present:
  - name: monasca
  - system: True
