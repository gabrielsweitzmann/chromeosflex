cd /tmp

clear
echo "======================================================="
echo " COMBO CHROMEOS: UEFI MrChromebox + Logo Customizada"
echo "======================================================="
echo "AVISO IMPORTANTE NO MENU DO MRCHROMEBOX:"
echo "-> Escolha 'Install/Update UEFI (Full ROM)'."
echo "-> Quando perguntar se deseja reiniciar (Reboot), digite 'N' (Não)."
echo "-> Depois, digite 'Q' para sair do menu dele."
echo "======================================================="
read -p "Pressione [ENTER] para abrir o menu e começar..."

# 2. Chama o script original do MrChromebox
curl -sLO mrchromebox.tech/firmware-util.sh
sudo bash firmware-util.sh

# O script continua aqui após você sair do menu do MrChromebox
clear
echo "======================================================="
echo "PASSO 2: Iniciando a troca da logo..."
echo "======================================================="

# 3. Baixa a SUA logo direto do GitHub (COLE O SEU LINK RAW ABAIXO)
LINK_DA_SUA_LOGO="https://raw.githubusercontent.com/gabrielsweitzmann/chromeosflex/main/meulogo.bmp"

echo "[1/4] Baixando a sua imagem do GitHub..."
curl -sL "$LINK_DA_SUA_LOGO" -o meulogo.bmp

if [ ! -f "meulogo.bmp" ]; then
    echo "ERRO: Não foi possível baixar a imagem. Verifique o link RAW no script!"
    exit 1
fi

echo "[2/4] Baixando a ferramenta cbfstool..."
# Usando curl ao invés de wget para garantir compatibilidade no ChromeOS
curl -sL https://mrchromebox.tech/files/util/cbfstool.tar.gz -o cbfstool.tar.gz
tar -zxf cbfstool.tar.gz
chmod +x cbfstool

echo "[3/4] Lendo a nova BIOS e injetando a sua arte..."
# O ChromeOS já tem o flashrom embutido, então usamos o nativo
sudo flashrom -p internal -r uefi_modificada.rom > /dev/null 2>&1

./cbfstool uefi_modificada.rom remove -n bootsplash.bmp > /dev/null 2>&1
./cbfstool uefi_modificada.rom add -f meulogo.bmp -n bootsplash.bmp -t raw

echo "[4/4] Gravando a BIOS customizada na placa-mãe. NÃO DESLIGUE O PC..."
sudo flashrom -p internal -w uefi_modificada.rom

echo "Limpando os arquivos temporários..."
rm cbfstool cbfstool.tar.gz uefi_modificada.rom meulogo.bmp firmware-util.sh

echo "======================================================="
echo "TUDO PRONTO! PROCESSO FINALIZADO!"
echo "Sua logo foi gravada com sucesso. Já pode reiniciar o Chromebook!"
echo "======================================================="
