#!/bin/bash

# ==========================================================
# PROVA PRÁTICA - MANUTENÇÃO DE COMPUTADORES
# Preparação automática da máquina
# NÃO É EXIBIDO AO ALUNO
# ==========================================================

# ----------------------------------------------------------
# 1. PROCESSO COM CONSUMO EXCESSIVO DE MEMÓRIA
# ----------------------------------------------------------

cat > /usr/local/bin/monitor_memoria.py <<'EOF'
#!/usr/bin/env python3

import time

# Aloca aproximadamente 700 MB de RAM.
# A memória é tocada para garantir alocação física.
blocos = []

for i in range(7):
    bloco = bytearray(100 * 1024 * 1024)

    for j in range(0, len(bloco), 4096):
        bloco[j] = 1

    blocos.append(bloco)
    time.sleep(0.3)

# Mantém a memória ocupada
while True:
    time.sleep(10)
EOF

chmod +x /usr/local/bin/monitor_memoria.py


# ----------------------------------------------------------
# 2. PROCESSO COM CONSUMO MODERADO DE CPU
# ----------------------------------------------------------

cat > /usr/local/bin/monitor_cpu.py <<'EOF'
#!/usr/bin/env python3

import time

# Gera aproximadamente 25% de utilização de um núcleo.
# Trabalha durante 0,25 s e descansa 0,75 s.

while True:

    inicio = time.time()

    while time.time() - inicio < 0.25:
        x = 0

        for i in range(10000):
            x += i * i

    time.sleep(0.75)
EOF

chmod +x /usr/local/bin/monitor_cpu.py


# ----------------------------------------------------------
# 3. SERVIÇO QUE MANTÉM OS PROCESSOS ATIVOS
# ----------------------------------------------------------

cat > /usr/local/bin/monitor_sistema.sh <<'EOF'
#!/bin/bash

python3 /usr/local/bin/monitor_memoria.py &
PID_MEM=$!

python3 /usr/local/bin/monitor_cpu.py &
PID_CPU=$!

# Mantém o processo principal vivo
wait
EOF

chmod +x /usr/local/bin/monitor_sistema.sh


cat > /etc/systemd/system/monitoramento-lab.service <<'EOF'
[Unit]
Description=Sistema de Monitoramento do Laboratorio
After=network.target

[Service]

Type=simple

ExecStart=/usr/local/bin/monitor_sistema.sh

# O serviço tenta retornar caso seja encerrado
Restart=always
RestartSec=2

[Install]
WantedBy=multi-user.target
EOF


systemctl daemon-reload

systemctl enable monitoramento-lab.service

systemctl start monitoramento-lab.service


# ----------------------------------------------------------
# 4. ARQUIVOS DE LOG EXCESSIVOS
# ----------------------------------------------------------

mkdir -p /var/log/laboratorio

# Cria arquivos grandes simulando logs antigos
# Total aproximado: 300 MB

dd if=/dev/zero \
   of=/var/log/laboratorio/sistema-antigo.log \
   bs=1M count=150 2>/dev/null

dd if=/dev/zero \
   of=/var/log/laboratorio/debug-antigo.log \
   bs=1M count=100 2>/dev/null

dd if=/dev/zero \
   of=/var/log/laboratorio/teste-antigo.log \
   bs=1M count=50 2>/dev/null


# ----------------------------------------------------------
# 5. INDÍCIO PARA INVESTIGAÇÃO
# ----------------------------------------------------------

cat > /var/log/laboratorio/README.txt <<'EOF'
Diretorio utilizado pelo sistema de monitoramento do laboratorio.

Os arquivos presentes neste diretorio sao gerados durante
a operacao da estacao.
EOF


# ==========================================================
# FIM DA PREPARAÇÃO
# ==========================================================

exit 0
