---
layout: archive
permalink: /tags/
title: Tags
author_profile: true
---

{% include base_path %}
{% include group-by-array collection=site.posts field="tags" %}
<div>
{% for tag in group_names %}
  {% assign posts = group_items[forloop.index0] %}
  <h2 id="{{ tag | slugify }}" class="archive__subtitle">{{ tag }}</h2>
  {% for post in posts %}
    <a href='{{ site.baseurl }}{{ post.url }}'>{{ post.title }}</a><br>
  {% endfor %}
{% endfor %}
</div>
