#!/bin/bash

clear
echo "======================================================="
echo " COMBO CLOUD: UEFI MrChromebox + Logo Customizada"
echo "======================================================="
echo "PASSO 1: Vamos rodar o utilitário do MrChromebox."
echo "-> Escolha a opção 'Install/Update UEFI (Full ROM)'."
echo "-> Siga os passos normalmente."
echo "-> IMPORTANTE: Quando perguntar se deseja reiniciar (Reboot), escolha NÃO (N)."
echo "-> Depois, digite 'Q' para sair do menu dele."
echo "======================================================="
read -p "Pressione [ENTER] para abrir o menu e começar..."

# 1. Chama o script oficial do MrChromebox
cd ~; curl -LO mrchromebox.tech/firmware-util.sh
sudo bash firmware-util.sh

# O script continua aqui após você sair do MrChromebox
clear
echo "======================================================="
echo "PASSO 2: Iniciando a troca da logo..."
echo "======================================================="

# 2. Baixa a SUA logo direto do GitHub (COLE O SEU LINK RAW ABAIXO)
LINK_LOGO="https://raw.githubusercontent.com/gabrielsweitzmann/chromeosflex/main/meulogo.bmp"

echo "[1/5] Baixando a sua imagem do GitHub..."
wget -q $LINK_LOGO -O meulogo.bmp

if [ ! -f "meulogo.bmp" ]; then
    echo "ERRO: Não foi possível baixar a imagem. Verifique se o link Raw está correto no script!"
    exit 1
fi

echo "[2/5] Instalando dependências e ferramentas..."
sudo apt-get update > /dev/null 2>&1
sudo apt-get install flashrom -y > /dev/null 2>&1
wget -q https://mrchromebox.tech/files/util/cbfstool.tar.gz
tar -zxf cbfstool.tar.gz
chmod +x cbfstool

echo "[3/5] Lendo a BIOS instalada..."
sudo flashrom -p internal -r uefi_original.rom > /dev/null 2>&1
cp uefi_original.rom uefi_modificada.rom

echo "[4/5] Injetando a arte..."
./cbfstool uefi_modificada.rom remove -n bootsplash.bmp > /dev/null 2>&1
./cbfstool uefi_modificada.rom add -f meulogo.bmp -n bootsplash.bmp -t raw

echo "[5/5] Gravando BIOS final. NÃO DESLIGUE O PC..."
sudo flashrom -p internal -w uefi_modificada.rom

echo "Limpando a bagunça..."
rm cbfstool cbfstool.tar.gz uefi_modificada.rom meulogo.bmp

echo "======================================================="
echo "TUDO PRONTO! PROCESSO FINALIZADO!"
echo "O arquivo 'uefi_original.rom' ficou salvo na sua pasta atual como backup."
echo "Pode fechar tudo e reiniciar o Chromebook!"
echo "======================================================="
