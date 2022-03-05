#!/bin/bash
#actualizando

#instalando
n=100
while [ $n -ne 0 ]; do

 printf '\n***************************************\n'
 echo 'MENU:'
 printf '\t 1.- Instala Vsftpd \n'
 printf '\t 2.- Modificar configuración\n'
 printf '\t 3.- Reiniciar servidor FTP\n'
 printf '\t 4.- Desinstalar servidor FTP\n'
 printf '\t 0.- salir\n'
 printf '\n***************************************\n'
 read -p "Elige una opcion: " n
 echo ""

 if [ -z "$n" ] || [ "$n" -gt 4 ]; then
 echo "Elige un numero entre el 1 y el 4"
 elif [ "$n" = 1 ]; then
    if [ "$(dpkg -l | grep vsftpd | tr -s ' ' ' ' | cut -d' ' -f2)" = "vsftpd" ]; then
         echo 'ya esta instalado en este dispositivo'
 
    else
        sudo apt update
        sudo apt upgrade
        sudo apt install vsftpd
    fi
    


#modificando
#write_enable
 elif [ "$n" = 2 ]; then
    printf '\n***************************************\n'
    echo 'MODIFICANDO:'
    printf '\t 1.- Activar/desactivar permisos de escritura\n' 
    printf '\t 2.- Habilitar/deshabilitar usuarios anónimos\n'
    printf '\t 3.- Permitir/denegar subir archivo a usuario anónimos\n'
    printf '\t 0.- salir\n'
    printf '\n***************************************\n'
    read -p "¿Que quieres modificar?: " m
    echo ""

    if [ "$m" -eq 1 ]; then
    if [ "$(cat /etc/vsftpd.conf | grep -E "#write_enable|^write_enable" | cut -d'=' -f2)" = "YES" ] && [ "$(cat /etc/vsftpd.conf | grep "#write_enable"| cut -c 1)" != '#' ]; then
        echo "actualmente se encuentra activado"
        read -p "¿desea cambiarlo? (s/n)" we
        if [ "$we" = 's' ]; then
            sudo sed -i 's/write_enable=YES/#write_enable=YES/' /etc/vsftpd.conf
            echo 'cambios guardados correctamente'

        fi
    else
        echo "actualmente se encuentra desactivado"
        read -p "¿desea cambiarlo? (s/n)" we
        if [ "$we" = 's' ]; then
            sudo sed -i 's/#write_enable=YES/write_enable=YES/' /etc/vsftpd.conf
            echo 'cambios guardados correctamente'

        fi
    fi
    fi
        if [ "$m" -eq 2 ]; then
    if [ "$(cat /etc/vsftpd.conf | grep anonymous_enable | cut -d'=' -f2)" = "YES" ]; then
        echo "actualmente se encuentra activado"
        read -p "¿desea cambiarlo? (s/n)" we
        if [ "$we" = 's' ]; then
            sudo sed -i 's/anonymous_enable=YES/anonymous_enable=NO/' /etc/vsftpd.conf   
           echo 'cambios guardados correctamente'
           sudo sed -i 's/#anon_upload_enable=YES/anon_upload_enable=NO/' /etc/vsftpd.conf
            if [ ! -d /FTPanon/ ]; then
                sudo mkdir /FTPanon
                sudo touch /FTPanon/hola_anonymous.txt
            fi
            echo "anon_root=/FTPanon" | sudo tee -a /etc/vsftpd.conf
             
        fi
    else
        echo "actualmente se encuentra desactivado"
        read -p "¿desea cambiarlo? (s/n)" we
        if [ "$we" = 's' ]; then
            sudo sed -i 's/anonymous_enable=NO/anonymous_enable=YES/' /etc/vsftpd.conf   
            echo 'cambios guardados correctamente'
  
        fi
    fi
    fi

elif [ "$n" = 3 ]; then
    sudo /etc/init.d/vsftpd restart

elif [ "$n" = 4 ]; then
    read -p "¿Seguro que lo quieres desinstalar? (s/n)" un
    if [ "$un" = 's' ]; then
        sudo apt-get --purge remove vsftpd
        echo 'vsftpd desinstalado correctamente'
       
    fi
fi




done

