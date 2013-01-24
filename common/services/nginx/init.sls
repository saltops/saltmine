nginx:
  pkg:
  	- installed
  service:
  	- dead

# delete the nginx default.conf file if it exists
/etc/nginx/conf.d/default.conf:
	file.absent:
	  - require:
      - pkg: nginx