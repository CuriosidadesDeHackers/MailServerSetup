<?php
// ============================================================
// /etc/roundcube/config.inc.php — Configuración de Roundcube
// ============================================================

// Base de datos SQLite
$config['db_dsnw'] = 'sqlite:////var/lib/roundcube/roundcube.db?mode=0640';

// Servidor IMAP (Dovecot local)
$config['imap_host'] = ['tls://localhost:143' => 'Mi Servidor de Correo'];
$config['imap_conn_options'] = [
    'ssl' => [
        'verify_peer'      => false,
        'verify_peer_name' => false,
    ]
];

// Servidor SMTP (Postfix local, puerto 587)
$config['smtp_host'] = 'tls://localhost:587';
$config['smtp_conn_options'] = [
    'ssl' => [
        'verify_peer'      => false,
        'verify_peer_name' => false,
    ]
];
$config['smtp_user'] = '%u';
$config['smtp_pass'] = '%p';

// Identidad
$config['product_name'] = 'Mi Servidor de Correo';

// Seguridad — CAMBIAR por una cadena aleatoria de 24 caracteres
$config['des_key'] = 'CAMBIA_ESTO_24_CHARS_RANDOM';

// Plugins activos
$config['plugins'] = ['archive', 'zipdownload'];

// Interfaz
$config['skin']     = 'elastic';
$config['language'] = 'es_ES';
$config['timezone'] = 'Europe/Madrid';

// Carpetas por defecto
$config['create_default_folders'] = true;
$config['sent_mbox']   = 'Sent';
$config['drafts_mbox'] = 'Drafts';
$config['trash_mbox']  = 'Trash';
$config['junk_mbox']   = 'Junk';
