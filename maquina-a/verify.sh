#!/bin/bash

# Verifica se o arquivo existe
if [ ! -f /usr/local/bin/laboratorio.sh ]; then
    echo "ERRO: A aplicação do laboratório foi removida."
    exit 1
fi

# Verifica se recuperou a permissão de execução
if [ ! -x /usr/local/bin/laboratorio.sh ]; then
    echo "O problema ainda não foi solucionado."
    exit 1
fi

# Verifica se o serviço está funcionando
if ! systemctl is-active --quiet laboratorio.service; then
    echo "O serviço ainda não está funcionando corretamente."
    exit 1
fi

echo "MANUTENÇÃO CONCLUÍDA COM SUCESSO."
echo "O serviço laboratorio.service está funcionando corretamente."

exit 0
