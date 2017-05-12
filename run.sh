#!/bin/sh -e
[ -n "$DEBUG" ] && set -x

pid=0

# SIGTERM-handler
term_handler() {
  if [ $pid -ne 0 ]; then
    kill -SIGTERM "$pid"
    wait "$pid"
  fi
  exit 143; # 128 + 15 -- SIGTERM
}

# First-time config
if [ ! -f /var/www/piler/config-site.php ]; then
  apk add --no-cache mysql-client
  sed -e'/load_default_values$/q' /usr/src/piler/util/postinstall.sh > /tmp/postinstall.sh
  cd /usr/src/piler
  (set +e
    source /tmp/postinstall.sh
    gather_webserver_data
    gather_mysql_account
    gather_smtp_relay_data
    show_summary
    if [ -d webui ]; then
      echo -n "Copying www files to $DOCROOT... "
      mkdir -p $DOCROOT || exit 1
      cp -R webui/* $DOCROOT
      cp -R webui/.htaccess $DOCROOT
    fi
    webui_install
    clean_up_temp_stuff
  )
  exit
fi

# setup handlers
# on callback, kill the last background process, which is `php-fpm` and execute the specified handler
trap 'kill ${!}; term_handler' SIGTERM

# Start crond for piler tasks
if [ -f /usr/local/etc/piler/crontab.piler ]; then
  crontab -u piler /usr/local/etc/piler/crontab.piler
fi
crond
pid="$!"

# Start php-fpm
php-fpm
