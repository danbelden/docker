#!/bin/bash
set -euo pipefail

# Append ENV vars to the FPM config if not in ignore set and value is not empty
# https://github.com/docker-library/php/issues/74
# https://ypereirareis.github.io/blog/2015/12/13/symfony-nginx-environment-variables-php-fpm/
ENV_VARS=`printenv`
IGNORE_ENV_VARS=( "_" "DEBIAN_FRONTEND" "HOME" "HOSTNAME" "LS_COLORS" "no_proxy" "PATH" "PWD" "SHLVL" "TERM" )
for ENV_VAR in $ENV_VARS
do
  IFS== read ENV_VAR_NAME ENV_VAR_VALUE <<< "$ENV_VAR"
  if [[ ! ${IGNORE_ENV_VARS[*]} =~ "$ENV_VAR_NAME" ]] && [[ !  -z  $ENV_VAR_VALUE ]]; then
    echo "env[$ENV_VAR_NAME] = $ENV_VAR_VALUE" >> /etc/php/7.0/fpm/pool.d/www.conf
  fi
done

# Run the web services
service php7.0-fpm start
nginx
