-- Additive migration: abc.sql -> 1.4.4_snapshot.sql
-- Safe mode: no DROP, no MODIFY, only additive DDL
SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS=0;

-- Create new tables
CREATE TABLE IF NOT EXISTS `abc_paypal_customers` (
  `customer_id` int(11) NOT NULL,
  `customer_paypal_id` varchar(50) NOT NULL,
  `paypal_test_mode` tinyint(1) NOT NULL DEFAULT 0,
  `date_added` timestamp NOT NULL DEFAULT current_timestamp(),
  `date_modified` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`customer_id`,`paypal_test_mode`),
  UNIQUE KEY `customer_id` (`customer_id`,`paypal_test_mode`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

CREATE TABLE IF NOT EXISTS `abc_paypal_orders` (
  `paypal_order_id` int(11) NOT NULL AUTO_INCREMENT,
  `paypal_test_mode` tinyint(1) DEFAULT 0,
  `order_id` int(11) NOT NULL,
  `charge_id` char(50) NOT NULL,
  `charge_id_previous` char(50) DEFAULT '',
  `transaction_id` char(100) DEFAULT '',
  `settings` text DEFAULT NULL,
  `date_added` timestamp NOT NULL DEFAULT current_timestamp(),
  `date_modified` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`paypal_order_id`),
  KEY `ac_paypal_order_idx` (`paypal_order_id`,`order_id`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

CREATE TABLE IF NOT EXISTS `abc_shopping_sessions` (
  `customer_id` int(11) DEFAULT NULL,
  `order_id` int(11) DEFAULT NULL,
  `type` varchar(255) NOT NULL,
  `key` varchar(255) NOT NULL,
  `data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`data`)),
  `date_added` timestamp NOT NULL DEFAULT current_timestamp(),
  `date_modified` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  UNIQUE KEY `abc_shopping_sessions_text_idx` (`type`,`key`),
  KEY `abc_shopping_sessions_int_idx` (`customer_id` DESC,`order_id` DESC),
  CONSTRAINT `abc_shopping_sessions_customer_fk` FOREIGN KEY (`customer_id`) REFERENCES `abc_customers` (`customer_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `abc_stripe_customers` (
  `customer_id` int(11) NOT NULL,
  `customer_stripe_id` varchar(50) NOT NULL,
  `stripe_test_mode` tinyint(1) NOT NULL DEFAULT 0,
  `date_added` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `date_modified` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`customer_id`,`stripe_test_mode`),
  UNIQUE KEY `customer_id` (`customer_id`,`stripe_test_mode`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

CREATE TABLE IF NOT EXISTS `abc_stripe_orders` (
  `stripe_order_id` int(11) NOT NULL AUTO_INCREMENT,
  `stripe_test_mode` tinyint(1) DEFAULT 0,
  `order_id` int(11) NOT NULL,
  `charge_id` char(50) NOT NULL,
  `charge_id_previous` char(50) NOT NULL DEFAULT '',
  `date_added` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `date_modified` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`stripe_order_id`),
  KEY `abc_stripe_order_idx` (`stripe_order_id`,`order_id`)
) ENGINE=MyISAM AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- abc_addresses
SET @idx_exists := (SELECT COUNT(1) FROM INFORMATION_SCHEMA.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'abc_addresses' AND INDEX_NAME = 'abc_addresses_idx');
SET @sql := IF(@idx_exists = 0, 'ALTER TABLE `abc_addresses` ADD KEY `abc_addresses_idx` (`customer_id`,`country_id`,`zone_id`)', 'SELECT ''skip existing KEY abc_addresses_idx on abc_addresses''');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- abc_banner_stat
SET @idx_exists := (SELECT COUNT(1) FROM INFORMATION_SCHEMA.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'abc_banner_stat' AND INDEX_NAME = 'abc_banner_stat_idx');
SET @sql := IF(@idx_exists = 0, 'ALTER TABLE `abc_banner_stat` ADD KEY `abc_banner_stat_idx` (`banner_id`,`type`,`time`,`store_id`)', 'SELECT ''skip existing KEY abc_banner_stat_idx on abc_banner_stat''');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- abc_block_layouts
SET @idx_exists := (SELECT COUNT(1) FROM INFORMATION_SCHEMA.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'abc_block_layouts' AND INDEX_NAME = 'abc_block_layouts_idx');
SET @sql := IF(@idx_exists = 0, 'ALTER TABLE `abc_block_layouts` ADD UNIQUE KEY `abc_block_layouts_idx` (`instance_id`,`layout_id`,`block_id`,`parent_instance_id`,`custom_block_id`)', 'SELECT ''skip existing UNIQUE KEY abc_block_layouts_idx on abc_block_layouts''');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- abc_categories
SET @idx_exists := (SELECT COUNT(1) FROM INFORMATION_SCHEMA.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'abc_categories' AND INDEX_NAME = 'abc_categories_idx');
SET @sql := IF(@idx_exists = 0, 'ALTER TABLE `abc_categories` ADD KEY `abc_categories_idx` (`category_id`,`parent_id`,`status`)', 'SELECT ''skip existing KEY abc_categories_idx on abc_categories''');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- abc_contents
ALTER TABLE `abc_contents` ADD COLUMN IF NOT EXISTS `show_title` tinyint(1) NOT NULL DEFAULT 1;

-- abc_countries
SET @idx_exists := (SELECT COUNT(1) FROM INFORMATION_SCHEMA.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'abc_countries' AND INDEX_NAME = 'abc_countries_idx');
SET @sql := IF(@idx_exists = 0, 'ALTER TABLE `abc_countries` ADD KEY `abc_countries_idx` (`iso_code_2`,`iso_code_3`,`status`)', 'SELECT ''skip existing KEY abc_countries_idx on abc_countries''');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- abc_coupons_categories
SET @idx_exists := (SELECT COUNT(1) FROM INFORMATION_SCHEMA.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'abc_coupons_categories' AND INDEX_NAME = 'abc_coupons_categories_idx');
SET @sql := IF(@idx_exists = 0, 'ALTER TABLE `abc_coupons_categories` ADD KEY `abc_coupons_categories_idx` (`coupon_id`,`category_id`)', 'SELECT ''skip existing KEY abc_coupons_categories_idx on abc_coupons_categories''');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- abc_coupons_products
SET @idx_exists := (SELECT COUNT(1) FROM INFORMATION_SCHEMA.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'abc_coupons_products' AND INDEX_NAME = 'abc_coupons_products_idx');
SET @sql := IF(@idx_exists = 0, 'ALTER TABLE `abc_coupons_products` ADD KEY `abc_coupons_products_idx` (`coupon_id`,`product_id`)', 'SELECT ''skip existing KEY abc_coupons_products_idx on abc_coupons_products''');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- abc_custom_lists
SET @idx_exists := (SELECT COUNT(1) FROM INFORMATION_SCHEMA.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'abc_custom_lists' AND INDEX_NAME = 'abc_custom_block_id_list_idx');
SET @sql := IF(@idx_exists = 0, 'ALTER TABLE `abc_custom_lists` ADD KEY `abc_custom_block_id_list_idx` (`custom_block_id`,`store_id`)', 'SELECT ''skip existing KEY abc_custom_block_id_list_idx on abc_custom_lists''');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- abc_customer_transactions
SET @idx_exists := (SELECT COUNT(1) FROM INFORMATION_SCHEMA.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'abc_customer_transactions' AND INDEX_NAME = 'abc_customer_transactions_idx');
SET @sql := IF(@idx_exists = 0, 'ALTER TABLE `abc_customer_transactions` ADD KEY `abc_customer_transactions_idx` (`customer_id`,`order_id`)', 'SELECT ''skip existing KEY abc_customer_transactions_idx on abc_customer_transactions''');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- abc_customers
SET @idx_exists := (SELECT COUNT(1) FROM INFORMATION_SCHEMA.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'abc_customers' AND INDEX_NAME = 'abc_customers_idx');
SET @sql := IF(@idx_exists = 0, 'ALTER TABLE `abc_customers` ADD KEY `abc_customers_idx` (`store_id`,`address_id`,`customer_group_id`)', 'SELECT ''skip existing KEY abc_customers_idx on abc_customers''');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- abc_download_attribute_values
SET @idx_exists := (SELECT COUNT(1) FROM INFORMATION_SCHEMA.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'abc_download_attribute_values' AND INDEX_NAME = 'abc_download_attribute_values_idx');
SET @sql := IF(@idx_exists = 0, 'ALTER TABLE `abc_download_attribute_values` ADD KEY `abc_download_attribute_values_idx` (`attribute_id`,`download_id`)', 'SELECT ''skip existing KEY abc_download_attribute_values_idx on abc_download_attribute_values''');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- abc_downloads
SET @idx_exists := (SELECT COUNT(1) FROM INFORMATION_SCHEMA.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'abc_downloads' AND INDEX_NAME = 'abc_downloads_idx');
SET @sql := IF(@idx_exists = 0, 'ALTER TABLE `abc_downloads` ADD KEY `abc_downloads_idx` (`activate_order_status_id`,`shared`)', 'SELECT ''skip existing KEY abc_downloads_idx on abc_downloads''');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- abc_global_attributes
SET @idx_exists := (SELECT COUNT(1) FROM INFORMATION_SCHEMA.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'abc_global_attributes' AND INDEX_NAME = 'abc_global_attributes_idx');
SET @sql := IF(@idx_exists = 0, 'ALTER TABLE `abc_global_attributes` ADD KEY `abc_global_attributes_idx` (`attribute_parent_id`,`attribute_group_id`,`attribute_type_id`)', 'SELECT ''skip existing KEY abc_global_attributes_idx on abc_global_attributes''');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- abc_global_attributes_values
SET @idx_exists := (SELECT COUNT(1) FROM INFORMATION_SCHEMA.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'abc_global_attributes_values' AND INDEX_NAME = 'abc_global_attributes_values_idx');
SET @sql := IF(@idx_exists = 0, 'ALTER TABLE `abc_global_attributes_values` ADD KEY `abc_global_attributes_values_idx` (`attribute_id`)', 'SELECT ''skip existing KEY abc_global_attributes_values_idx on abc_global_attributes_values''');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- abc_languages
SET @idx_exists := (SELECT COUNT(1) FROM INFORMATION_SCHEMA.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'abc_languages' AND INDEX_NAME = 'abc_languages_idx');
SET @sql := IF(@idx_exists = 0, 'ALTER TABLE `abc_languages` ADD UNIQUE KEY `abc_languages_idx` (`language_id`,`code`)', 'SELECT ''skip existing UNIQUE KEY abc_languages_idx on abc_languages''');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- abc_online_customers
SET @idx_exists := (SELECT COUNT(1) FROM INFORMATION_SCHEMA.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'abc_online_customers' AND INDEX_NAME = 'abc_online_customers_idx');
SET @sql := IF(@idx_exists = 0, 'ALTER TABLE `abc_online_customers` ADD KEY `abc_online_customers_idx` (`date_added`)', 'SELECT ''skip existing KEY abc_online_customers_idx on abc_online_customers''');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- abc_order_downloads
SET @idx_exists := (SELECT COUNT(1) FROM INFORMATION_SCHEMA.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'abc_order_downloads' AND INDEX_NAME = 'abc_order_downloads_idx');
SET @sql := IF(@idx_exists = 0, 'ALTER TABLE `abc_order_downloads` ADD KEY `abc_order_downloads_idx` (`order_id`,`order_product_id`,`download_id`,`status`,`activate_order_status_id`)', 'SELECT ''skip existing KEY abc_order_downloads_idx on abc_order_downloads''');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- abc_order_downloads_history
SET @idx_exists := (SELECT COUNT(1) FROM INFORMATION_SCHEMA.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'abc_order_downloads_history' AND INDEX_NAME = 'abc_order_downloads_history_idx');
SET @sql := IF(@idx_exists = 0, 'ALTER TABLE `abc_order_downloads_history` ADD KEY `abc_order_downloads_history_idx` (`download_id`)', 'SELECT ''skip existing KEY abc_order_downloads_history_idx on abc_order_downloads_history''');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- abc_order_history
SET @idx_exists := (SELECT COUNT(1) FROM INFORMATION_SCHEMA.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'abc_order_history' AND INDEX_NAME = 'abc_order_history_idx');
SET @sql := IF(@idx_exists = 0, 'ALTER TABLE `abc_order_history` ADD KEY `abc_order_history_idx` (`order_id`,`order_status_id`,`notify`)', 'SELECT ''skip existing KEY abc_order_history_idx on abc_order_history''');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- abc_order_options
SET @idx_exists := (SELECT COUNT(1) FROM INFORMATION_SCHEMA.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'abc_order_options' AND INDEX_NAME = 'abc_order_options_idx');
SET @sql := IF(@idx_exists = 0, 'ALTER TABLE `abc_order_options` ADD KEY `abc_order_options_idx` (`order_id`,`order_product_id`,`product_option_value_id`)', 'SELECT ''skip existing KEY abc_order_options_idx on abc_order_options''');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- abc_order_product_stock_locations
SET @idx_exists := (SELECT COUNT(1) FROM INFORMATION_SCHEMA.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'abc_order_product_stock_locations' AND INDEX_NAME = 'abc_product_options_value_idx');
SET @sql := IF(@idx_exists = 0, 'ALTER TABLE `abc_order_product_stock_locations` ADD KEY `abc_product_options_value_idx` (`product_option_value_id`)', 'SELECT ''skip existing KEY abc_product_options_value_idx on abc_order_product_stock_locations''');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
SET @idx_exists := (SELECT COUNT(1) FROM INFORMATION_SCHEMA.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'abc_order_product_stock_locations' AND INDEX_NAME = 'abc_product_options_value_idx2');
SET @sql := IF(@idx_exists = 0, 'ALTER TABLE `abc_order_product_stock_locations` ADD KEY `abc_product_options_value_idx2` (`order_product_id`,`product_id`,`product_option_value_id`,`location_id`)', 'SELECT ''skip existing KEY abc_product_options_value_idx2 on abc_order_product_stock_locations''');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- abc_order_products
SET @idx_exists := (SELECT COUNT(1) FROM INFORMATION_SCHEMA.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'abc_order_products' AND INDEX_NAME = 'abc_order_products_idx');
SET @sql := IF(@idx_exists = 0, 'ALTER TABLE `abc_order_products` ADD KEY `abc_order_products_idx` (`order_id`,`product_id`)', 'SELECT ''skip existing KEY abc_order_products_idx on abc_order_products''');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- abc_order_status_ids
SET @idx_exists := (SELECT COUNT(1) FROM INFORMATION_SCHEMA.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'abc_order_status_ids' AND INDEX_NAME = 'abc_order_status_ids_idx');
SET @sql := IF(@idx_exists = 0, 'ALTER TABLE `abc_order_status_ids` ADD UNIQUE KEY `abc_order_status_ids_idx` (`status_text_id`)', 'SELECT ''skip existing UNIQUE KEY abc_order_status_ids_idx on abc_order_status_ids''');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- abc_orders
SET @idx_exists := (SELECT COUNT(1) FROM INFORMATION_SCHEMA.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'abc_orders' AND INDEX_NAME = 'abc_orders_idx');
SET @sql := IF(@idx_exists = 0, 'ALTER TABLE `abc_orders` ADD KEY `abc_orders_idx` (`invoice_id`,`store_id`,`customer_group_id`,`shipping_zone_id`,`shipping_country_id`,`payment_zone_id`,`payment_country_id`,`language_id`,`currency_id`,`coupon_id`)', 'SELECT ''skip existing KEY abc_orders_idx on abc_orders''');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- abc_pages
SET @idx_exists := (SELECT COUNT(1) FROM INFORMATION_SCHEMA.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'abc_pages' AND INDEX_NAME = 'abc_pages_idx');
SET @sql := IF(@idx_exists = 0, 'ALTER TABLE `abc_pages` ADD UNIQUE KEY `abc_pages_idx` (`page_id`,`controller`,`key_param`,`key_value`)', 'SELECT ''skip existing UNIQUE KEY abc_pages_idx on abc_pages''');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- abc_product_descriptions
SET @idx_exists := (SELECT COUNT(1) FROM INFORMATION_SCHEMA.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'abc_product_descriptions' AND INDEX_NAME = 'abc_product_descriptions_name_idx');
SET @sql := IF(@idx_exists = 0, 'ALTER TABLE `abc_product_descriptions` ADD KEY `abc_product_descriptions_name_idx` (`product_id`,`name`)', 'SELECT ''skip existing KEY abc_product_descriptions_name_idx on abc_product_descriptions''');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- abc_product_discounts
SET @idx_exists := (SELECT COUNT(1) FROM INFORMATION_SCHEMA.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'abc_product_discounts' AND INDEX_NAME = 'abc_product_discounts_idx');
SET @sql := IF(@idx_exists = 0, 'ALTER TABLE `abc_product_discounts` ADD KEY `abc_product_discounts_idx` (`product_id`,`customer_group_id`)', 'SELECT ''skip existing KEY abc_product_discounts_idx on abc_product_discounts''');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- abc_product_option_descriptions
SET @idx_exists := (SELECT COUNT(1) FROM INFORMATION_SCHEMA.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'abc_product_option_descriptions' AND INDEX_NAME = 'abc_product_option_descriptions_idx');
SET @sql := IF(@idx_exists = 0, 'ALTER TABLE `abc_product_option_descriptions` ADD KEY `abc_product_option_descriptions_idx` (`product_id`)', 'SELECT ''skip existing KEY abc_product_option_descriptions_idx on abc_product_option_descriptions''');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- abc_product_option_value_descriptions
SET @idx_exists := (SELECT COUNT(1) FROM INFORMATION_SCHEMA.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'abc_product_option_value_descriptions' AND INDEX_NAME = 'abc_product_option_value_descriptions_idx');
SET @sql := IF(@idx_exists = 0, 'ALTER TABLE `abc_product_option_value_descriptions` ADD KEY `abc_product_option_value_descriptions_idx` (`product_id`)', 'SELECT ''skip existing KEY abc_product_option_value_descriptions_idx on abc_product_option_value_descriptions''');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- abc_product_option_values
SET @idx_exists := (SELECT COUNT(1) FROM INFORMATION_SCHEMA.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'abc_product_option_values' AND INDEX_NAME = 'abc_product_option_values_idx');
SET @sql := IF(@idx_exists = 0, 'ALTER TABLE `abc_product_option_values` ADD KEY `abc_product_option_values_idx` (`product_option_id`,`product_id`,`group_id`,`attribute_value_id`)', 'SELECT ''skip existing KEY abc_product_option_values_idx on abc_product_option_values''');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- abc_product_options
SET @idx_exists := (SELECT COUNT(1) FROM INFORMATION_SCHEMA.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'abc_product_options' AND INDEX_NAME = 'abc_product_options_idx');
SET @sql := IF(@idx_exists = 0, 'ALTER TABLE `abc_product_options` ADD KEY `abc_product_options_idx` (`attribute_id`,`product_id`,`group_id`)', 'SELECT ''skip existing KEY abc_product_options_idx on abc_product_options''');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- abc_product_specials
SET @idx_exists := (SELECT COUNT(1) FROM INFORMATION_SCHEMA.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'abc_product_specials' AND INDEX_NAME = 'abc_product_specials_idx');
SET @sql := IF(@idx_exists = 0, 'ALTER TABLE `abc_product_specials` ADD KEY `abc_product_specials_idx` (`product_id`,`customer_group_id`)', 'SELECT ''skip existing KEY abc_product_specials_idx on abc_product_specials''');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- abc_product_stock_locations
SET @idx_exists := (SELECT COUNT(1) FROM INFORMATION_SCHEMA.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'abc_product_stock_locations' AND INDEX_NAME = 'abc_product_stock_locations_idx');
SET @sql := IF(@idx_exists = 0, 'ALTER TABLE `abc_product_stock_locations` ADD UNIQUE KEY `abc_product_stock_locations_idx` (`product_id`,`product_option_value_id`,`location_id`)', 'SELECT ''skip existing UNIQUE KEY abc_product_stock_locations_idx on abc_product_stock_locations''');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
SET @idx_exists := (SELECT COUNT(1) FROM INFORMATION_SCHEMA.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'abc_product_stock_locations' AND INDEX_NAME = 'abc_product_stock_locations_idx2');
SET @sql := IF(@idx_exists = 0, 'ALTER TABLE `abc_product_stock_locations` ADD KEY `abc_product_stock_locations_idx2` (`product_option_value_id`)', 'SELECT ''skip existing KEY abc_product_stock_locations_idx2 on abc_product_stock_locations''');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- abc_products
ALTER TABLE `abc_products` ADD COLUMN IF NOT EXISTS `subscription_plan_id` varchar(32) DEFAULT '';
SET @idx_exists := (SELECT COUNT(1) FROM INFORMATION_SCHEMA.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'abc_products' AND INDEX_NAME = 'abc_products_idx');
SET @sql := IF(@idx_exists = 0, 'ALTER TABLE `abc_products` ADD KEY `abc_products_idx` (`stock_status_id`,`manufacturer_id`,`weight_class_id`,`length_class_id`)', 'SELECT ''skip existing KEY abc_products_idx on abc_products''');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
SET @idx_exists := (SELECT COUNT(1) FROM INFORMATION_SCHEMA.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'abc_products' AND INDEX_NAME = 'abc_products_status_idx');
SET @sql := IF(@idx_exists = 0, 'ALTER TABLE `abc_products` ADD KEY `abc_products_status_idx` (`product_id`,`status`,`date_available`)', 'SELECT ''skip existing KEY abc_products_status_idx on abc_products''');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- abc_resource_descriptions
SET @idx_exists := (SELECT COUNT(1) FROM INFORMATION_SCHEMA.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'abc_resource_descriptions' AND INDEX_NAME = 'abc_resource_descriptions_name_idx');
SET @sql := IF(@idx_exists = 0, 'ALTER TABLE `abc_resource_descriptions` ADD KEY `abc_resource_descriptions_name_idx` (`resource_id`,`name`)', 'SELECT ''skip existing KEY abc_resource_descriptions_name_idx on abc_resource_descriptions''');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
SET @idx_exists := (SELECT COUNT(1) FROM INFORMATION_SCHEMA.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'abc_resource_descriptions' AND INDEX_NAME = 'abc_resource_descriptions_title_idx');
SET @sql := IF(@idx_exists = 0, 'ALTER TABLE `abc_resource_descriptions` ADD KEY `abc_resource_descriptions_title_idx` (`resource_id`,`title`)', 'SELECT ''skip existing KEY abc_resource_descriptions_title_idx on abc_resource_descriptions''');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- abc_resource_library
SET @idx_exists := (SELECT COUNT(1) FROM INFORMATION_SCHEMA.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'abc_resource_library' AND INDEX_NAME = 'abc_resource_library_idx');
SET @sql := IF(@idx_exists = 0, 'ALTER TABLE `abc_resource_library` ADD KEY `abc_resource_library_idx` (`resource_id`,`type_id`)', 'SELECT ''skip existing KEY abc_resource_library_idx on abc_resource_library''');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- abc_resource_map
SET @idx_exists := (SELECT COUNT(1) FROM INFORMATION_SCHEMA.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'abc_resource_map' AND INDEX_NAME = 'abc_resource_map_sorting_idx');
SET @sql := IF(@idx_exists = 0, 'ALTER TABLE `abc_resource_map` ADD KEY `abc_resource_map_sorting_idx` (`resource_id`,`sort_order`)', 'SELECT ''skip existing KEY abc_resource_map_sorting_idx on abc_resource_map''');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- abc_reviews
SET @idx_exists := (SELECT COUNT(1) FROM INFORMATION_SCHEMA.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'abc_reviews' AND INDEX_NAME = 'abc_reviews_idx');
SET @sql := IF(@idx_exists = 0, 'ALTER TABLE `abc_reviews` ADD KEY `abc_reviews_idx` (`product_id`,`customer_id`)', 'SELECT ''skip existing KEY abc_reviews_idx on abc_reviews''');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- abc_tax_rates
SET @idx_exists := (SELECT COUNT(1) FROM INFORMATION_SCHEMA.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'abc_tax_rates' AND INDEX_NAME = 'abc_tax_rates_idx');
SET @sql := IF(@idx_exists = 0, 'ALTER TABLE `abc_tax_rates` ADD KEY `abc_tax_rates_idx` (`location_id`,`zone_id`,`tax_class_id`)', 'SELECT ''skip existing KEY abc_tax_rates_idx on abc_tax_rates''');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- abc_url_aliases
SET @idx_exists := (SELECT COUNT(1) FROM INFORMATION_SCHEMA.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'abc_url_aliases' AND INDEX_NAME = 'abc_url_aliases_idx');
SET @sql := IF(@idx_exists = 0, 'ALTER TABLE `abc_url_aliases` ADD UNIQUE KEY `abc_url_aliases_idx` (`keyword`,`language_id`)', 'SELECT ''skip existing UNIQUE KEY abc_url_aliases_idx on abc_url_aliases''');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
SET @idx_exists := (SELECT COUNT(1) FROM INFORMATION_SCHEMA.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'abc_url_aliases' AND INDEX_NAME = 'abc_url_aliases_idx2');
SET @sql := IF(@idx_exists = 0, 'ALTER TABLE `abc_url_aliases` ADD UNIQUE KEY `abc_url_aliases_idx2` (`query`,`language_id`)', 'SELECT ''skip existing UNIQUE KEY abc_url_aliases_idx2 on abc_url_aliases''');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- abc_zones_to_locations
SET @idx_exists := (SELECT COUNT(1) FROM INFORMATION_SCHEMA.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'abc_zones_to_locations' AND INDEX_NAME = 'abc_zones_to_locations_idx');
SET @sql := IF(@idx_exists = 0, 'ALTER TABLE `abc_zones_to_locations` ADD KEY `abc_zones_to_locations_idx` (`country_id`,`zone_id`,`location_id`)', 'SELECT ''skip existing KEY abc_zones_to_locations_idx on abc_zones_to_locations''');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET FOREIGN_KEY_CHECKS=1;

-- Compatibility fix for admin menu icon (FA4 in admin theme)
UPDATE `abc_resource_descriptions`
SET `resource_code` = '<i class="fa fa-money"></i>&nbsp;'
WHERE `resource_id` = 260;

-- Storefront menu compatibility fix for Checkout icon
UPDATE `abc_dataset_values` v
JOIN (
  SELECT v1.`row_id`
  FROM `abc_dataset_values` v1
  JOIN `abc_dataset_values` v3
    ON v3.`row_id` = v1.`row_id`
   AND v3.`dataset_column_id` = 3
   AND v3.`value_varchar` = 'checkout/fast_checkout'
  WHERE v1.`dataset_column_id` = 1
    AND v1.`value_varchar` = 'checkout'
) x ON x.`row_id` = v.`row_id`
SET v.`value_varchar` = '<i class="fa fa-money"></i>&nbsp;'
WHERE v.`dataset_column_id` = 2;

-- Ensure Checkout icon uses resource library id expected by storefront renderer
UPDATE `abc_dataset_values` v
JOIN (
  SELECT v1.`row_id`
  FROM `abc_dataset_values` v1
  JOIN `abc_dataset_values` v3
    ON v3.`row_id` = v1.`row_id`
   AND v3.`dataset_column_id` = 3
   AND v3.`value_varchar` = 'checkout/fast_checkout'
  WHERE v1.`dataset_column_id` = 1
    AND v1.`value_varchar` = 'checkout'
) x ON x.`row_id` = v.`row_id`
SET v.`value_integer` = 260
WHERE v.`dataset_column_id` = 7;

INSERT INTO `abc_dataset_values` (`dataset_column_id`, `value_integer`, `value_float`, `value_varchar`, `value_text`, `value_timestamp`, `value_boolean`, `row_id`)
SELECT 7, 260, NULL, NULL, NULL, CURRENT_TIMESTAMP, NULL, x.`row_id`
FROM (
  SELECT v1.`row_id`
  FROM `abc_dataset_values` v1
  JOIN `abc_dataset_values` v3
    ON v3.`row_id` = v1.`row_id`
   AND v3.`dataset_column_id` = 3
   AND v3.`value_varchar` = 'checkout/fast_checkout'
  WHERE v1.`dataset_column_id` = 1
    AND v1.`value_varchar` = 'checkout'
) x
LEFT JOIN `abc_dataset_values` existing
  ON existing.`row_id` = x.`row_id`
 AND existing.`dataset_column_id` = 7
WHERE existing.`value_sort_order` IS NULL;

-- Explicit group order for RegisterCustomerFrm (form_id=6)
DELETE FROM `abc_field_group_to_form` WHERE `form_id` = 6;
INSERT INTO `abc_field_group_to_form` (`group_id`, `form_id`, `sort_order`) VALUES
  (1, 6, 1), -- Your Personal Details
  (2, 6, 2), -- Your Address
  (3, 6, 3), -- Login Details
  (4, 6, 4); -- Newsletter
