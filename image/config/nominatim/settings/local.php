<?php

@define('CONST_Debug', (bool) getenv('NOMINATIM_DEBUG'));
@define('CONST_Database_DSN', 'pgsql://'.getenv('PGUSER').'@'.getenv('PGHOST').'/nominatim');
@define('CONST_Postgresql_Version', getenv('PG_MAJOR'));
@define('CONST_Postgis_Version', getenv('POSTGIS_VERSION'));
@define('CONST_Website_BaseURL', 'http://'.getenv('NOMINATIM_WEBSITE_DOMAIN'));