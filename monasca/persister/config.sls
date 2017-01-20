{%- from "monasca/map.jinja" import persister with context %}

/etc/monasca/persister:
  file.directory:
  - user: mon-persister
  - group: monasca
  - mode: 755
  - makedirs: True
  - require:
    - user: user_monasca_persister

monasca_persister_config:
  file.managed:
  - name: /etc/monasca/persister/persister-config.yml
  - source: salt://monasca/files/{{ persister.version }}/persister-config.yml
  - user: mon-persister
  - group: monasca
  - mode: 640
  - template: jinja
  - require:
    - file: /etc/monasca/persister
