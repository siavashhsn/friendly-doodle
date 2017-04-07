#!/bin/bash

if [[ -f tmp/env && -f tmp/env.bash ]]; then
	echo "ENV files exists and decrypted"
else
	cp -v data/env.dat tmp/env.gpg
	cd tmp
	if [ ! -f env.gpg ]; then
		echo 'tmp/env.dat does not exists!'
		echo '[ABORT]'
		exit 1
	fi 
	gpg env.gpg && unzip -o env && sudo service nginx reload
	cd ..
fi

source tmp/env.bash

export RAILS_ENV=production

[[ $* == *--db-setup* ]] && rails db:drop && rails db:create && rails db:migrate && rails db:seed

[[ $* == *--assets-clobber* ]] && rails assets:clobber && rails assets:clean

rails assets:precompile

bin/deploy.d/manual-assets.py