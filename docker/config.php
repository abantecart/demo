<?php
/**
	AbanteCart, Ideal OpenSource Ecommerce Solution
	http://www.AbanteCart.com
	Copyright © 2011-2019 Belavier Commerce LLC

	Released under the Open Software License (OSL 3.0)
*/

define('SERVER_NAME', 'demo.abantecart.com');
// Admin Section Configuration. You can change this value to any name. Will use ?s=name to access the admin
define('ADMIN_PATH', 'demo_admin');

// Database Configuration
define('DB_DRIVER', 'amysqli');
define('DB_HOSTNAME', '127.0.0.1');
define('DB_USERNAME', 'admin');
define('DB_PASSWORD', 'pass');
define('DB_DATABASE', 'abantecart');
define('DB_PREFIX', 'abc_');

define('CACHE_DRIVER', 'file');
// Unique AbanteCart store ID
define('UNIQUE_ID', '9fda35cef313ed8c4f6f9bb408e03c4e');
// Encryption key for protecting sensitive information. NOTE: Change of this key will cause a loss of all existing encrypted information!
define('ENCRYPTION_KEY', '0QwLi3');

define('IS_DEMO', 'true');