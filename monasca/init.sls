include:
{%- if pillar.monasca.api.enabled %}
- monasca.api
{%- endif %}
{%- if pillar.monasca.persister.enabled %}
- monasca.persister
{%- endif %}
{%- if pillar.monasca.notification.enabled %}
- monasca.notification
{%- endif %}
{%- if pillar.monasca.thresh.enabled %}
- monasca.thresh
{%- endif %}
{%- if pillar.monasca.agent.enabled %}
- monasca.agent
{%- endif %}
