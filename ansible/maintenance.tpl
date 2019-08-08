server {
	listen 80;
	root /home/ubuntu/binary_calculator/binary_calculator/templates;

	index maintenance.html;

	location / {
		try_files $uri $uri/ =404;
	}
}