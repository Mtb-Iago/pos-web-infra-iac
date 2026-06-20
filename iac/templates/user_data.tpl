#!/bin/bash
set -e

# Atualização de pacotes
apt-get update -y

# Instalação das dependências necessárias
apt-get install -y \
    net-tools \
    mysql-client \
    python3-pip \
    python3-venv \
    pkg-config \
    default-libmysqlclient-dev \
    nginx

# Criar pasta da aplicação
mkdir -p /home/ubuntu/myapp
chown -R ubuntu:ubuntu /home/ubuntu/myapp
cd /home/ubuntu/myapp

# Configurar Virtualenv e instalar Flask
python3 -m venv venv
./venv/bin/pip install --upgrade pip
./venv/bin/pip install flask flask-mysqldb flask-cors gunicorn

# Criar arquivo de serviço Systemd para a API Flask
cat <<EOF > /etc/systemd/system/myapi.service
[Unit]
Description=Gunicorn instance to serve myapi Flask app
After=network.target

[Service]
User=ubuntu
WorkingDirectory=/home/ubuntu/myapp
ExecStart=/home/ubuntu/myapp/venv/bin/gunicorn --workers 3 --bind 0.0.0.0:5000 myapi:app
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Iniciar e habilitar o serviço da API
systemctl daemon-reload
systemctl start myapi
systemctl enable myapi

# Configurar permissões do diretório web do Nginx para o deploy do FrontEnd
chown -R ubuntu:ubuntu /var/www/html
chmod -R 755 /var/www/html