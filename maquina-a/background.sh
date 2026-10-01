#!/bin/bash

# =====================================================
# PREPARAÇÃO DA MÁQUINA A
# Prova de Manutenção de Computadores
# NÃO É EXIBIDO AO ALUNO
# =====================================================

# Cria a aplicação utilizada pelo laboratório
cat > /usr/local/bin/laboratorio.sh <<'EOF'
#!/bin/bash

while true
do
    echo "$(date) - Sistema do laboratório funcionando" >> /var/log/laboratorio.log
    sleep 10
done
EOF

# Inicialmente deixa o programa executável
chmod +x /usr/local/bin/laboratorio.sh


# Cria o serviço do systemd
cat > /etc/systemd/system/laboratorio.service <<'EOF'
[Unit]
Description=Sistema de Monitoramento do Laboratorio
After=network.target

[Service]
Type=simple
ExecStart=/usr/local/bin/laboratorio.sh
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF


# Atualiza o systemd
systemctl daemon-reload

# Habilita o serviço
systemctl enable laboratorio.service


# =====================================================
# DEFEITO PROPOSITAL
# =====================================================

# Remove a permissão de execução do programa
chmod -x /usr/local/bin/laboratorio.sh


# Tenta iniciar o serviço
# A inicialização deverá falhar
systemctl start laboratorio.service || true
