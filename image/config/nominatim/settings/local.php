<?php

$env = json_decode(file_get_contents('/etc/container_environment.json'));

@define('CONST_Debug', (bool) $env->NOMINATIM_DEBUG);
@define('CONST_Database_DSN', 'pgsql://'.$env->PGUSER.'@'.$env->PGHOST.'/nominatim');
@define('CONST_Postgresql_Version', $env->PG_MAJOR);
@define('CONST_Postgis_Version', $env->POSTGIS_VERSION);
@define('CONST_Website_BaseURL', 'http://'.$env->NOMINATIM_WEBSITE_DOMAIN);