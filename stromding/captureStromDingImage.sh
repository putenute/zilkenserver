#!/bin/bash
vlc -I dummy v4l2:///dev/video0 --video-filter scene --no-audio --scene-path /var/stromding/img --scene-prefix image_prefix --scene-format png vlc://quit --run-time=1
