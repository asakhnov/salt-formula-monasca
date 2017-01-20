{%- from "monasca/map.jinja" import common,notification with context %}

include:
- monasca.common

python_deps:
  pkg.installed:
  - names:
    - {{ common.pip }}
    - {{ common.python_dev }}
  - refresh: True

virtualenv:
  pip.installed:
  - name: virtualenv
  - upgrade: True
  - require:
    - pkg: python_deps

monasca_virtualenv:
  virtualenv.managed:
  - name: /opt/monasca/notification
  - require:
    - pip: virtualenv

monasca_notification_pkg:
  pip.installed:
  - name: monasca-notification
  - upgrade: True
  - pre_releases: True
  - bin_env: /opt/monasca/notification
  - require:
    - virtualenv: monasca_virtualenv

user_monasca_notification:
  user.present:
  - name: mon-notification
  - shell: /bin/false
  - home: /var/lib/monasca
  - system: True
  - groups:
    - monasca

/var/log/monasca/notification:
  file.directory:
  - user: mon-notification
  - group: monasca
  - mode: 755
  - makedirs: True
  - require:
    - user: user_monasca_notification

monasca_notification_upstart:
  file.managed:
  - name: /etc/init/monasca-notification.conf
  - source: salt://monasca/files/upstart/monasca-notification.conf
  - template: jinja
  - user: root
  - group: root
  - mode: 644
