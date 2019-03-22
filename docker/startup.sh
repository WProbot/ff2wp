#!/bin/bash

# Download wp-cli on root of current project
if [ ! -f ./wp-cli.phar ]; then
  echo "== Download wp-cli"
  wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
  chmod +x wp-cli.phar
fi

# Download wp-markdown
if [ ! -f ./wp-markdown.1.6.1.zip ]; then
  echo "== Download wp-markdown"
  wget https://downloads.wordpress.org/plugin/wp-markdown.1.6.1.zip
fi

# Then start wordpress (with docker compose) 
echo "== Up docker compose"
docker-compose up -d

# Wait until wordpress started
echo "== Waiting for wordpress started"
sleep 10

# Configure site
echo "== Configure wordpress site"
docker exec -ti --user www-data wordpress bash -c "wp core install --title=ff2wp --admin_user=admin --admin_password=admin --admin_email=user@domain.com --skip-email --url=http://localhost:8080"

# Install and activate wp-markdown plugin
echo "== Copy wp-markdown plugin to wordpress docker"
docker cp wp-markdown.1.6.1.zip wordpress:/var/
echo "== Install and activate wp-markdown plugin"
docker exec -ti --user www-data wordpress bash -c "wp plugin install /var/wp-markdown.1.6.1.zip --activate"

# Finally proceed import posts into wordpress container
echo "====================="
echo "Wordpress is READY"
echo "1. Enable markdown manually in Wordpress settings: https://en.support.wordpress.com/wordpress-editor/blocks/markdown-block/#enabling-markdown"
echo "2. Run following to start import:"
echo ""
echo "  docker exec -ti --user www-data wordpress bash -c /var/ff2wp.sh"
echo ""
echo "====================="