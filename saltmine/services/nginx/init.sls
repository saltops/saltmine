#!yaml

nginx-pkg:
  pkg:
  	- installed
    - name: nginx

nginx-service:
  service:
    - dead
    - name: nginx
    - enable: False
    - watch:
      - file: /etc/nginx/nginx.conf
    - require:
      - file: nginx-default-conf
      - pkg: nginx-pkg

# delete the nginx default.conf file if it exists
nginx-default-conf:
	file.absent:
    - name:
      - /etc/nginx/conf.d/default.conf
	  - require:
      - pkg: nginx-pkg