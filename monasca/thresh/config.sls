{%- from "monasca/map.jinja" import thresh with context %}

/etc/monasca/thresh:
  file.directory:
  - user: mon-thresh
  - group: monasca
  - mode: 755
  - makedirs: True
  - require:
    - user: user_monasca_thresh

monasca_thresh_config:
  file.managed:
  - name: /etc/monasca/thresh/thresh-config.yml
  - source: salt://monasca/files/{{ thresh.version }}/thresh-config.yml
  - user: mon-thresh
  - group: monasca
  - mode: 640
  - template: jinja
  - require:
    - file: /etc/monasca/thresh
