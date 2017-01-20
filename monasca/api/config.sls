{%- from "monasca/map.jinja" import api with context %}

/etc/monasca/api:
  file.directory:
  - user: mon-api
  - group: monasca
  - mode: 755
  - makedirs: True
  - require:
    - user: user_monasca_api

monasca_api_config:
  file.managed:
  - name: /etc/monasca/api/api-config.yml
  - source: salt://monasca/files/{{ api.version }}/api-config.yml
  - user: mon-api
  - group: monasca
  - mode: 640
  - template: jinja
  - require:
    - file: /etc/monasca/api

{%- if pillar.monasca.api.keystore.enabled and not salt['file.file_exists' ]('/etc/monasca.keystore') %}

# This needs to be changed to whatever reasonable way.
# Currently just copy cert from one place to another.
create_cert:
  file.copy:
  - name: {{ monasca.api.keystore.cert_path }}
  - source: {{ monasca.api.keystore.cert_source }}
  - owner: root
  - group: root

create_keystore:
  cmd.run:
  - name: keytool -import -file {{ monasca.api.keystore.cert }} -alias ksCA -keystore /etc/monasca.keystore -storepass {{ monasca.api.keystore.password }} -trustcacerts -noprompt
  - require:
    - file: create_cert

keystore_permissions:
  file.managed:
  - name: /etc/monasca.keystore
  - owner: mon-api
  - group: monasca
  - mode: 660  
  - require:
    - cmd: create_keystore

{%- endif %}
