# LAB 50 - servidor de http (apache)


- objectiu: accedir des de les màquines 4 (text) o, 3 i 5 (gràfic) al servidor http (apache) de la màquina 2

- partim de la infraestructura del lab44 (eliminant la instal·lació dels servidors de correu)

- engega les màquines 1,2 i 5
- accedeix al servidor web de la vm2 des de la vm5 mitjançant el navegador firefox: www.left.jda.lab50
- canvia la pàgina d'inici per una que mostre el teu nom i 1er cognom
- analitza el codi que ens ha permet fer aquest lab: fitxers de boot i de conf

# LAB 51

- objectiu: accés a dues webs separades amb amb mateix servidor: virtual hosts

- accedeix a www.left.jda.lab50 i blog.left.jda.lab50 i mostra que són webs separades i diferents

- https://goo.gl/RXj124

# LAB 52

- objectiu: limitar l'accés a un subdirectori a través de htaccess

- Fer que per accedir al directori de www.left.jda.lab50/admin calga identificar-se amb usuari i contrassenya

# LAB 53

- objectiu: access segur a la web

- fer que a la web wiki.left.jda.lab50 se puga accedir pel port 443: https

# LAB 53B

- objectiu: generar-se de manera correcta el certificat "auto-signat"

- autogenerar-se el certificat d'encriptació ssl, emplaçar-lo al lloc correcte i fer-lo servir al servidor apache quan s'accedeix a wiki.left.jda.lab50

# LAB 54

- objectiu: permetre l'ús de directoris personals a la web www.left.jda.lab50

- crea dos comptes al sistema operatiu, amb carpeta privada al /home i fes que els directoris public_html dels comptes sigues accessibles mitjançant www.left.jda.lab50\~compte_nou_{01,02}

