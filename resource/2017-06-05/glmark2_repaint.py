#! /usr/bin/env python 
# https://chrisalbon.com/python/matplotlib_stacked_bar_plot.html

import sys
import matplotlib.pyplot as plt
import pandas as pd


if len(sys.argv) < 2:
    print("No input file")
    sys.exit()

dt_canvas_clear = []
dt_time = []
dt_scene_draw = []
dt_scene_update = []
dt_canvas_update = []
dt_total_draw = []

count = 0

with open(sys.argv[1]) as f:
    for line in f:
        items = line.split()
        tl = items[0].split(':')
        timestamp = ":".join(tl[2:])
        total = int(items[14])
        # if drawing time > 16ms, it will not show.
        # if total > 16000:
            # continue

        # show 100 rows only.  
        if count >= 100:
            break
        count = count+1

        dt_time.append(timestamp)
        dt_canvas_clear.append(int(items[2]))
        dt_scene_draw.append(int(items[5]))
        dt_scene_update.append(int(items[8]))
        dt_canvas_update.append(int(items[11]))
        dt_total_draw.append(total)

raw_data = {'timestamp': dt_time, 
	'canvas_clear': dt_canvas_clear, 
	'scene_draw': dt_scene_draw, 
	'scene_update': dt_scene_update, 
	'canvas_update': dt_canvas_update,
	'total_draw': dt_total_draw}
df = pd.DataFrame(raw_data, columns = ['timestamp', 'canvas_clear', 'scene_draw', 'scene_update', 'canvas_update', 'total_draw'])
print(df)

# Create the general blog and the "subplots" i.e. the bars
f, ax1 = plt.subplots(1, figsize=(10,5))

# Set the bar width
bar_width = 0.75

# positions of the left bar-boundaries
bar_l = [i+1 for i in range(len(df['timestamp']))]

# positions of the x-axis ticks (center of the bars as bar labels)
tick_pos = [i+(bar_width/2) for i in bar_l]

# Create a bar plot, in position bar_1
ax1.bar(bar_l,
        # using the pre_score data
        df['canvas_clear'],
        # set the width
        width=bar_width,
        # with the label pre score
        label='canvas_clear',
        # with alpha 0.5
        alpha=0.5,
        # with color
        color='#3355FF')

# Create a bar plot, in position bar_1
ax1.bar(bar_l,
        # using the mid_score data
        df['scene_draw'],
        # set the width
        width=bar_width,
        # with pre_score on the bottom
        bottom=df['canvas_clear'],
        label='scene_draw', alpha=0.5, color='#FFDD33')

# Create a bar plot, in position bar_1
ax1.bar(bar_l,
        # using the post_score data
        df['scene_update'],
        # set the width
        width=bar_width,
        # with pre_score and mid_score on the bottom
        bottom=[i+j for i,j in zip(df['canvas_clear'],df['scene_draw'])],
        label='scene_update', alpha=0.5, color='#FF335E')

# Create a bar plot, in position bar_1
ax1.bar(bar_l,
        # using the post_score data
        df['canvas_update'],
        # set the width
        width=bar_width,
        # with pre_score and mid_score on the bottom
        bottom=[i+j+k for i,j,k in zip(df['canvas_clear'],df['scene_draw'], df['scene_update'])],
        label='canvas_update', alpha=0.5, color='#33FFD4')

# Create a bar plot, in position bar_1
total_base = [ a+b+c+d for a,b,c,d in zip(df['canvas_clear'],df['scene_draw'], df['scene_update'], df['canvas_update']) ]

ax1.bar(bar_l,
        # using the post_score data
        [k-i for i,k in zip(total_base, df['total_draw'])],
        # set the width
        width=bar_width,
        # with pre_score and mid_score on the bottom
        bottom=total_base,
        label='total_draw', alpha=0.5, color='#035723')
# set the x ticks with names
plt.xticks(tick_pos, df['timestamp'], rotation=90)

# Set the label and legends
ax1.set_ylabel("time (us)")
ax1.set_xlabel("timestamp (ms)")
# plt.legend(loc='upper right')
plt.legend(bbox_to_anchor=(1, 1), loc=2, borderaxespad=0.)

# Set a buffer around the edge
plt.xlim([min(tick_pos)-bar_width, max(tick_pos)+bar_width])
plt.show()
