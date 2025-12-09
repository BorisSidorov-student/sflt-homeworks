#!/bin/bash
check() {
	if  nc -z localhost 80 2>/dev/null && \
		[[ -f "/var/www/html/index.nginx-debian.html" ]]; then
		return 0
	else return 1
	fi
}
check
