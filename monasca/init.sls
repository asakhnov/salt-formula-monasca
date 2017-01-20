include:
{%- if pillar.monasca.api.enabled %}
- monasca.api
{%- endif %}
{%- if pillar.monasca.persister.enabled %}
- monasca.persister
{%- endif %}
