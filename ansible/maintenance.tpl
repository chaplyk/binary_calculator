server {
	listen 80;
	root /tmp/binary_calculator/;

	index maintenance.html;

	location / {
		try_files $uri $uri/ =404;
	}
}
