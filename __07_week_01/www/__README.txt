
If running on LAMP or MAMP, 
www will be your root directory
you can access your site via, e.g.,
http://localhost:8001/ozone_01.php

HOWEVER, if using the php CLI
point Terminal to www
php -S localhost:8001
and your site is accessed via, e.g.,
http://localhost:8001/html/ozone_01.php


For your own data . . .

edit 

_conn_class_mysqli.php

and

_site_parameters.php

with your DB credentials



