# freedom_server
Конфигурация внешнего сервера с различными средствами обхода блокировок и репозиториями

## Запуск сервисов

```
set -a
source config.env
docker-compose up -d
```

Предварительно необходимо настроить config.env с паролями и портами

## Список сервисов

* Dante - прокси-сервер (SOCKS5, аутентификация по пользователю и паролю)
* Mtproto Proxy - прокси-сервер для работы telegram
* OpenVPN - сервис виртуальных частных сетей
* Nextcloud - хранилище данных
* Gitea - интерфейс для работы с репозиториями исходного кода


## Настройка

Все необходимые настройки нужно выставить в config.env.
В traefik/traefik.toml указать домен.


### Настройка OpenVPN

* Initialize the configuration files and certificates

```
docker-compose run --rm openvpn ovpn_genconfig -u udp://VPN.SERVERNAME.COM
docker-compose run --rm openvpn ovpn_initpki
```

* Fix ownership (depending on how to handle your backups, this may not be needed)

```
sudo chown -R $(whoami): ./openvpn-data
```
* Generate a client certificate

```
export CLIENTNAME="your_client_name"
# with a passphrase (recommended)
docker-compose run --rm openvpn easyrsa build-client-full $CLIENTNAME
# without a passphrase (not recommended)
docker-compose run --rm openvpn easyrsa build-client-full $CLIENTNAME nopass
```
* Retrieve the client configuration with embedded certificates

```
docker-compose run --rm openvpn ovpn_getclient $CLIENTNAME > $CLIENTNAME.ovpn
```

* Revoke a client certificate

```
# Keep the corresponding crt, key and req files.
docker-compose run --rm openvpn ovpn_revokeclient $CLIENTNAME
# Remove the corresponding crt, key and req files.
docker-compose run --rm openvpn ovpn_revokeclient $CLIENTNAME remove
```

### Настройка Nextcloud

После установки необходимо прописать в конфиге домен и rewrite пути:

```
 'trusted_domains' => 
  array (
    0 => 'localhost',
    1 => '80.240.31.39',
    2 => 'racoondev.tk',
  ),
  'overwritewebroot' => '/nextcloud',

```

### Настройка Gitea

При первом подключении нужно подцепиться на порт 3000 вручную и запустить установку. При установке прописать альтернативный путь.

## Пути веб-сервера

* /nextcloud/ - облачное хранилище Nextcloud
* /gitea/ - работа с репозиториями Gitea



