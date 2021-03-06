#!/usr/bin/env python

import os, shutil

MANUAL_ASSETS = [
	['app/assets/stylesheets/photoswipe/default-skin/default-skin.png', 'public/assets/photoswipe/default-skin/'],
	['app/assets/stylesheets/photoswipe/default-skin/default-skin.svg', 'public/assets/photoswipe/default-skin/'],
	['app/assets/javascripts/image_upload/tmpl.min.js.map', 'public/assets/'],
  ['app/assets/javascripts/image_upload/load-image.all.min.js.map', 'public/assets/']
]

for asset in MANUAL_ASSETS:
	os.system('mkdir -p "%s"' %asset[1])
	shutil.copy2(asset[0], asset[1])
	print "%s -> %s" %(asset[0], asset[1])