#!/bin/bash
set -e

echo "Initializing the docker entry point"

if [[ "${1#-}" != "$1" ]]; then
  set -- php-fpm "$@"
fi

if [ "$1" = 'php-fpm' ] || [ "$1" = 'bin/console' ]; then
    if [ "$APP_ENV" != 'prod' ]; then
        if [ ! -d "./vendor" ]; then
            composer install --prefer-dist --no-progress --no-suggest --no-interaction --optimize-autoloader
        fi

#        bin/console doctrine:database:create --env=dev --if-not-exists
#        bin/console doctrine:migrations:migrate --env=dev --quiet --no-interaction --allow-no-migration
    else
        bin/console cache:clear --env=prod --no-debug
#        bin/console doctrine:database:create --env=prod --if-not-exists
#        bin/console doctrine:migrations:migrate --env=prod --quiet --no-interaction --allow-no-migration
    fi
fi

# Creates the queues strategies
# bin/console cct:initialize-queue-strategy

exec "$@"