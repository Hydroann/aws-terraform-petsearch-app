#!/bin/bash
set -euxo pipefail
exec > /var/log/petsearch-install.log 2>&1

echo "=== PetSearch WordPress Install Starting ==="

DB_USER="${db_username}"
DB_PASS="${db_password}"
#S3_BUCKET="${s3_bucket_name}"


echo "=== Installing packages ==="
dnf update -y
dnf install -y \
    httpd \
    php8.2 \
    php8.2-mysqlnd \
    php8.2-xml \
    php8.2-gd \
    php8.2-mbstring \
    php8.2-curl \
    php8.2-zip \
    mysql8.0 \
    wget \
    unzip
systemctl enable httpd
systemctl start  httpd

echo "=== Downloading WordPress ==="
cd /tmp
wget -q https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
rsync -a wordpress/ /var/www/html/
rm -rf /tmp/wordpress /tmp/latest.tar.gz

echo "=== Configuring WordPress ==="
cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php

sed -i "s/database_name_here/$DB_NAME/"  /var/www/html/wp-config.php
sed -i "s/username_here/$DB_USER/"       /var/www/html/wp-config.php
sed -i "s/password_here/$DB_PASS/"       /var/www/html/wp-config.php


cat >> /var/www/html/wp-config.php << EOF



echo "=== Setting file permissions ==="
chown -R apache:apache /var/www/html
chmod -R 755 /var/www/html
mkdir -p /var/www/html/wp-content/uploads
chown -R apache:apache /var/www/html/wp-content/uploads


sed -i 's/AllowOverride None/AllowOverride All/g' /etc/httpd/conf/httpd.conf


echo "=== Installing WP-CLI ==="
curl -sO https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp


echo "=== Waiting for database ==="
for i in {1..20}; do
  if mysql -u "$DB_USER" -p"$DB_PASS" -e "SELECT 1;" &>/dev/null; then
    echo "Database is ready!"
    break
  fi
  echo "Waiting for database... attempt $i/20"
  sleep 15
done

systemctl restart httpd

echo "=== PetSearch WordPress Install Complete! ==="
echo "Visit the ALB DNS name in your browser to finish WordPress setup."
