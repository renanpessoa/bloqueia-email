#!/bin/bash

# Sobre: Bloqueia acesso de uma conta de e-mail até que a senha seja alterada.
# Autor: Renan Pessoa - renanhpessoa@gmail.com
# Data: 16/Junho/2016

acc=$1

usuario=$(echo "$acc" | cut -d@ -f1);
dominio=$(echo "$acc" | cut -d@ -f2);
user=$(grep "$dominio" /etc/userdomains | awk '{print $2}');

[[ -z $acc ]] || [[ -z $usuario ]] && echo -e "Você deve informar a conta de e-mail: usuario@dominio.com" && exit;

[[ -z $user ]] && echo -e "Domínio não encontrado" && exit;

[[ ! -d /home/$user/mail/$dominio/$usuario ]] && echo -e "A conta informada não existe" && exit;

[[ ! -z `grep -iw $usuario /home/$user/etc/$dominio/shadow | grep -i disabled` ]] && echo -e "A conta já está desabilitada" && exit;

chattr -ia /home/$user/etc/$dominio/shadow;

sed -i 's/'$usuario'\:/'$usuario'\:\!\!DISABLED\!\!/' /home/$user/etc/$dominio/shadow
echo -e "\nA conta foi desabilitada com sucesso";
echo -e "--------------------------------------------------------------------"
grep -iw $usuario /home/$user/etc/$dominio/shadow;
echo -e "--------------------------------------------------------------------"
