---
layout: archive
permalink: /categories/
title: Categories
author_profile: true
---

{% include base_path %}
{% include group-by-array collection=site.posts field="categories" %}

<div>
{% for category in group_names %} 
  {% assign posts = group_items[forloop.index0] %}
  <h2 id="{{ category | slugify }}" class="archive__subtitle">{{ category }}</h2>
    {% for post in posts %}
        <a href='{{ site.baseurl }}{{ post.url }}'>{{ post.title }}</a><br>
    {% endfor %}
{% endfor %}
</div>
