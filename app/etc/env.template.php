<?php
return [
    'x-frame-options' => 'SAMEORIGIN',
    'MAGE_MODE' => getenv('MAGE_MODE'),
    'install' => [
        'date' => 'Mon, 03 Jan 2022 10:12:35 +0000'
    ],
    'backend' => [
        'frontName' => 'admin'
    ],
    'remote_storage' => [
        'driver' => 'file'
    ],
    'queue' => [
        'consumers_wait_for_messages' => 1,
        'amqp' => [
            'host' => getenv('RABBITMQ_HOST'),
            'port' => getenv('RABBITMQ_PORT'),
            'user' => getenv('RABBITMQ_USER'),
            'password' => getenv('RABBITMQ_PASSWORD'),
            'virtualhost' => '/'
        ],
    ],
    'crypt' => [
        'key' => 'a9a9ef287f4dd1055bd63082384c2446'
    ],
    'db' => [
        'table_prefix' => '',
        'connection' => [
            'default' => [
                'host' => getenv('MYSQL_HOST'),
                'dbname' => getenv('MYSQL_DATABASE'),
                'username' => getenv('MYSQL_USER'),
                'password' => getenv('MYSQL_PASSWORD'),
                'model' => 'mysql4',
                'engine' => 'innodb',
                'initStatements' => 'SET NAMES utf8;',
                'active' => '1',
                'driver_options' => [
                    1014 => false
                ]
            ]
        ]
    ],
    'resource' => [
        'default_setup' => [
            'connection' => 'default'
        ]
    ],
    'session' => [
        'save' => 'redis',
        'redis' => [
            'host' => getenv('REDIS_SESSION_HOST'),
            'port' => getenv('REDIS_SESSION_PORT'),
            'database' => getenv('REDIS_SESSION_DATABASE') ?? '2',
            'password' => '',
            'timeout' => '2.5',
            'persistent_identifier' => '',
            'compression_threshold' => '2048',
            'compression_library' => 'gzip',
            'log_level' => '4',
            'max_concurrency' => '6',
            'break_after_frontend' => '5',
            'break_after_adminhtml' => '30',
            'first_lifetime' => '600',
            'bot_first_lifetime' => '60',
            'bot_lifetime' => '7200',
            'disable_locking' => '0',
            'min_lifetime' => '60',
            'max_lifetime' => '2592000',
            'sentinel_master' => '',
            'sentinel_servers' => '',
            'sentinel_connect_retries' => '5',
            'sentinel_verify_master' => '0'
        ]
    ],
    'cache' => [
        'frontend' => [
            'default' => [
                'id_prefix' => substr(getenv('APP_SECRET') ?? 'a00001', 0, 6) . '_',
                'backend' => 'Magento\\Framework\\Cache\\Backend\\Redis',
                'backend_options' => [
                    'server' => getenv('REDIS_CACHE_HOST'),
                    'port' => getenv('REDIS_CACHE_PORT'),
                    'database' => getenv('REDIS_CACHE_DEFAULT_DATABASE') ?? '0',
                    'password' => '',
                    'compress_data' => '1',
                    'compression_lib' => '',
                    'preload_keys' => [
                        'EAV_ENTITY_TYPES',
                        'GLOBAL_PLUGIN_LIST',
                        'DB_IS_UP_TO_DATE',
                        'SYSTEM_DEFAULT'
                    ]
                ]
            ],
            'page_cache' => [
                'id_prefix' => substr(getenv('APP_SECRET') ?? 'a00001', 0, 6) . '_',
                'backend' => 'Magento\\Framework\\Cache\\Backend\\Redis',
                'backend_options' => [
                    'server' => getenv('REDIS_CACHE_HOST'),
                    'port' => getenv('REDIS_CACHE_PORT'),
                    'database' => getenv('REDIS_CACHE_PAGE_CACHE_DATABASE') ?? '1',
                    'password' => '',
                    'compress_data' => '0',
                    'compression_lib' => ''
                ]
            ]
        ],
        'allow_parallel_generation' => false
    ],
    'lock' => [
        'provider' => 'db',
        'config' => [
            'prefix' => ''
        ]
    ],
    'directories' => [
        'document_root_is_pub' => true
    ],
    'cache_types' => [
        'config' => 1,
        'layout' => 1,
        'block_html' => 1,
        'collections' => 1,
        'reflection' => 1,
        'db_ddl' => 1,
        'compiled_config' => 1,
        'eav' => 1,
        'customer_notification' => 1,
        'config_integration' => 1,
        'config_integration_api' => 1,
        'full_page' => 1,
        'config_webservice' => 1,
        'translate' => 1,
        'vertex' => 1
    ]
];
