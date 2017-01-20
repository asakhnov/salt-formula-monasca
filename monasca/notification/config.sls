{%- from "monasca/map.jinja" import notification with context %}

/etc/monasca/notification:
  file.directory:
  - user: mon-notification
  - group: monasca
  - mode: 755
  - makedirs: True
  - require:
    - user: user_monasca_notification

monasca_notification_config:
  file.managed:
  - name: /etc/monasca/notification/notification.yml
  - source: salt://monasca/files/{{ notification.version }}/notification.yml
  - user: mon-notification
  - group: monasca
  - mode: 640
  - template: jinja
  - require:
    - file: /etc/monasca/notification
