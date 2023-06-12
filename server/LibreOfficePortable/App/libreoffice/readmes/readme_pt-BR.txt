
======================================================================
Arquivo LEIAME do LibreOffice 7.5
======================================================================


Para consultar as alterações mais recentes deste aquivo, consulte https://git.libreoffice.org/core/tree/master/README.md

Este arquivo contém informações importantes sobre o software LibreOffice. Recomendamos a leitura cuidadosa antes de iniciar a instalação.

A comunidade LibreOffice é responsável pelo desenvolvimento deste produto, e o convida a participar como membro da comunidade. Se você é um novo membro, você pode visitar o sítio do LibreOffice, onde haverá muita informação sobre o projeto LibreOffice e sobre as comunidades que existem ao seu redor. Acesse https://www.libreoffice.org/.

O LibreOffice é realmente livre para todo e qualquer usuário?
----------------------------------------------------------------------

O LibreOffice é livre de encargos e obrigações para todos. Você pode levar essa cópia do LibreOffice e instalá-la em todos os computadores que desejar, e utilizá-la para qualquer propósito (incluindo a utilização comercial, governamental, na administração pública e na educação). Para mais detalhes, consulte o texto da licença incluída no download deste LibreOffice.

Por que o LibreOffice é livre para todos os usuários?
----------------------------------------------------------------------

Você pode utilizar esta cópia do LibreOffice sem encargos por que pessoas contribuíram individualmente e empresas patrocinaram desenvolvedores. Estes são os que projetaram, desenvolveram, testaram, traduziram, documentaram, suportaram, divulgaram e ajudaram de muitas formas a criar o que o LibreOffice é hoje - a melhor suíte de programas de produtividade de escritório de código aberto para sua casa e seu trabalho.

Se você gostou dos esforços feitos por estas pessoas e desejar garantir que o LibreOffice continue a ser disponível por muitos anos, considere contribuir para o projeto - visite https://www.documentfoundation.org/contribution/ para conhecer os detalhes. Todos podem fazer sua contribuição de alguma maneira.

----------------------------------------------------------------------
Notas sobre a instalação
----------------------------------------------------------------------

O LibreOffice requer uma versão recente do Java Runtime Environment (JRE) para desempenhar com toda sua funcionalidade. O JRE não faz parte do pacote de instalação do LibreOffice. Ele deve ser instalado em separado.

Requisitos do sistema
----------------------------------------------------------------------

* Microsoft Windows 7 SP1, 8, 8.1 Update (S14) or 10

Observe que o processo de instalação requer direitos de administrador.

O registro do LibreOffice como aplicação padrão para os formatos Microsoft Office pode ser forçado ou eliminado ao utilizar as seguintes chaves na linha de comando do instalador:

* REGISTER_ALL_MSO_TYPES=1 forçará o registro do LibreOffice como aplicação padrão para os formatos do Microsoft Office.
* REGISTER_NO_MSO_TYPES=1 eliminará o registro do LibreOffice como aplicação padrão para formatos do Microsoft Office.

Garanta que haja memória suficiente no diretório temporário de seu sistema, e assegure-se que os direitos de leitura, gravação e execução foram outorgados. Feche todos os demais programas antes de iniciar o processo de instalação.

Instalação do LibreOffice em sistemas Linux Debian/Ubuntu
----------------------------------------------------------------------

Para mais informações sobre a instalação dos pacotes de idiomas (após instalar o LibreOffice na versão em inglês dos EUA), leia a seção abaixo intitulada Instalar um pacote de idioma.

Ao extrair o arquivo transferido, seu conteúdo será descompactado para um subdiretório. Abra uma janela do gestor de arquivos e altere o diretório para aquele que começa com "LibreOffice_", seguido pelo número da versão e algumas informações da plataforma.

Este diretório contém o subdiretório chamado de "DEBS". Navegue até o diretório "DEBS".

Clique no botão direito do mouse e escolha "Abrir um terminal". Uma janela do terminal abrirá. Na linha de comando do terminal, entre o seguinte comando (você deverá inserir antes a senha do usuário root antes do comando ser executado):

Os comandos a seguir instalarão os pacotes do LibreOffice e da integração com o ambiente de trabalho (copie e cole-os num terminal ao invés de tentar digitá-los):

sudo dpkg -i *.deb

O processo de instalação está agora terminado e você deverá ter os ícones para todas as aplicações do LibreOffice no seu menu Aplicações/Escritório.

Instalação do LibreOffice nos sistemas Fedora, openSUSE, Mandriva e outros que utilizem pacotes RPM
----------------------------------------------------------------------

Para mais informações sobre a instalação dos pacotes de idiomas (após instalar o LibreOffice na versão em inglês dos EUA), leia a seção abaixo intitulada Instalar um pacote de idioma.

Ao desempacotar o arquivo, o conteúdo será colocado em um subdiretório. Abra uma janela do gerenciador de arquivos e mude para o diretório que começa com "LibreOffice_", seguido do número da versão e uma informação da plataforma.

Este diretório contém um subdiretório chamado de "RPMS". Mude para o diretório "RPMS".

Clique no botão direito do mouse e escolha "Abrir um terminal". Uma janela do terminal abrirá. Na linha de comando do terminal, entre o seguinte comando (você deverá inserir antes a senha do usuário root antes do comando ser executado):

Para sistemas derivados do Fedora: sudo dnf  install *.rpm

Para sistemas Mandriva: sudo urpmi *.rpm

Para os demais sistemas RPM (openSUSE, etc.): rpm -Uvh *.rpm

O processo de instalação está agora terminado e você deverá ter os ícones para todas as aplicações do LibreOffice no seu menu Aplicações/Escritório.

Alternativamente, pode utilizar o script de instalação 'install' existente no diretório superior deste arquivo para instalar a aplicação como usuário. O script configura o LibreOffice com o seu perfil, não interferindo com o perfil normal do LibreOffice. Note que isso não instalará as partes da integração de sistemas tais como menus da área de trabalho e registros dos tipos MIME da área de trabalho.

Notas sobre a integração do ambiente de trabalho para distribuições Linux não mencionadas pelas instruções de instalação acima
----------------------------------------------------------------------

É possível instalar facilmente o LibreOffice em outras distribuições Linux não especificadas nestas instruções de instalação. O principal aspecto das diferenças poderá estar na integração com o ambiente de trabalho.

O diretório RPMS (ou DEBS, respectivamente) também contém um pacote com o nome libreoffice7.5-freedesktop-menus-7.5.0.1-1.noarch.rpm (ou libreoffice7.5-debian-menus_7.5.0.1-1_all.deb, respectivamente, ou similar). Este é o pacote para distribuições Linux que tenham suporte às especificações/recomendações do Freedesktop.org (https://en.wikipedia.org/wiki/Freedesktop.org), servindo também para a instalação em distribuições Linux não abrangidas pelas instruções apresentadas.

Instalar um pacote de idioma
----------------------------------------------------------------------

Faça o download do pacote de idioma do seu idioma ou país e da sua plataforma. Eles estão disponíveis no mesmo local de seu arquivo de instalação principal. De dentro do gerenciador de arquivos Nautilus, extraia o arquivo baixado em um diretório (seu ambiente de trabalho, por exemplo). Garanta que tenha saído de todas as aplicações do LibreOffice (incluindo o Iniciador Rápido, se estiver executando).

Mude para o diretório onde os arquivos do pacote de idioma foram extraídos.

Mude para o diretório criado pelo processo de extração. Por exemplo, o pacote de idiomas francês para o sistema Debian/Ubuntu de 32 bits, o diretório se chama LibreOffice_, com alguma informação de versão e com Linux_x86_langpack-deb_fr.

Mude agora para o diretório que contém os pacotes a instalar. Nos sistemas Debian/Ubuntu, o diretório será DEBS. No Fedora, openSUSE ou Mandriva, o diretório será RPMS.

Pelo gerenciador de arquivos Nautilus, clique com o botão da direita do mouse no diretório e escolha o comando "Abrir em um terminal". Na janela do terminal, execute o comando para instalar o pacote de idioma (em todos os comandos abaixo, insira a senha de seu usuário root):

Para sistemas Debian/Ubuntu: sudo dpkg -i *.deb

Para sistemas derivados do Fedora: su -c 'dnf install *.rpm'

Para sistemas Mandriva: sudo urpmi *.rpm

Para outros sistemas RPM (openSUSE, etc.): rpm -Uvh *.rpm

Inicie agora uma das aplicações do LibreOffice - por exemplo o Writer. Vá para o menu Ferramentas - Opções. Na caixa de diálogo das Opções, clique em "Configurações de idioma" e clique em "Idiomas". Na lista "Interface do usuário" selecione o idioma recém-instalado. Se desejar, faça o mesmo para as "Configurações da localidade", a "Moeda padrão", e o "Idioma padrão para documentos".

Após ajustar as configurações, clique em OK. A caixa de diálogo será fechada e aparecerá uma mensagem indicando que as modificações só terão efeito após fechar o LibreOffice e reiniciá-lo (lembre-se de sair do Início rápido se estiver executando).

Na próxima vez que iniciar o LibreOffice, ele estará no idioma recém-instalado.

----------------------------------------------------------------------
Problemas durante a inicialização do programa
----------------------------------------------------------------------

Dificuldades ao iniciar o LibreOffice (por exemplo, a aplicação trava), bem como problemas com a exibição da tela, geralmente são causados pelo driver da placa gráfica. Se esses problemas ocorrerem, atualize o driver da placa gráfica ou tente usar o driver gráfico fornecido com o sistema operacional.

----------------------------------------------------------------------
Touchpads de notebooks ALPS/Synaptics no Windows
----------------------------------------------------------------------

Por conta de um problema de driver no Windows, você não pode rolar documentos no LibreOffice ao deslizar seu dedo em um touchpad ALPS/Synaptics.

Para ativar a rolagem pelo touchpad, adicione as seguintes linhas ao arquivo de configuração do touchpad em "C:\Program Files\Synaptics\SynTP\SynTPEnh.ini" e reinicie seu computador:

[LibreOffice]

FC = "SALFRAME"

SF = 0x10000000

SF |= 0x00004000

O local do arquivo de configuração pode variar dependendo da versão do Windows.

----------------------------------------------------------------------
Teclas de atalho
----------------------------------------------------------------------

Somente os atalhos (combinações de teclas) que não são utilizados pelo sistema operacional podem ser utilizados no LibreOffice. Se uma combinação de teclas no LibreOffice não funcionar como descrito na Ajuda do LibreOffice, verifique se o atalho já é utilizado pelo sistema operacional. Para retificar esses conflitos, você pode trocar quase todas as atribuições de teclas do LibreOffice. Para mais informações sobre este tópico, consulte a Ajuda do LibreOffice ou a documentação de ajuda do seu sistema operacional.

----------------------------------------------------------------------
Problemas ao enviar documentos como e-mails a partir do LibreOffice
----------------------------------------------------------------------

Ao enviar um documento via 'Arquivo - Enviar - Documento como e-mail' ou 'Documento como PDF anexado' poderão ocorrer problemas (o programa falha ou congela). Isto é devido ao arquivo do sistema Windows "Mapi" (Messaging Application Programming Interface) que causa problemas em algumas versões do arquivo. Infelizmente o problema não pode ser cercado em uma versão determinada. Para maiores informações visite https://www.microsoft.com para pesquisar o Microsoft Knowledge Base sobre "mapi dll".

----------------------------------------------------------------------
Notas importantes sobre acessibilidade
----------------------------------------------------------------------

Para mais informações sobre os recursos de acessibilidade do LibreOffice, visite https://www.libreoffice.org/accessibility/

----------------------------------------------------------------------
Suporte ao usuário
----------------------------------------------------------------------

A página principal de suporte oferece várias possibilidades de ajuda para o LibreOffice. Sua dúvida pode já estar respondida - verifique o fórum da Comunidade em https://www.documentfoundation.org/nabble/ ou pesquise nos arquivos da lista de discussão 'users@libreoffice.org' em https://www.libreoffice.org/lists/users/. Alterativamente, coloque suas perguntas na lista users@libreoffice.org. Se desejar assinar a lista (para obter uma resposta por e-mail), envie um e-mail vazio para: users+subscribe@libreoffice.org.

Verifique também a seção das perguntas frequentes no website do LibreOffice.

----------------------------------------------------------------------
Reportar bugs & problemas
----------------------------------------------------------------------

Nosso sistema de reporte, acompanhamento e resolução de bugs é o Bugzilla, hospedado em https://bugs.documentfoundation.org/. Convidamos todos os usuários a reportarem bugs que podem ter aparecido em uma plataforma particular. O reporte enérgico de bugs é uma das mais importantes contribuições da comunidade de usuários para o desenvolvimento continuado e melhoria do LibreOffice.

----------------------------------------------------------------------
Como envolver-se
----------------------------------------------------------------------

A comunidade do LibreOffice beneficiará bastante com a sua participação ativa no desenvolvimento deste importante projeto de código aberto.

Como usuário, você já é parte valiosa do processo de desenvolvimento da suíte e gostaríamos de convidá-lo a participar mais ativamente de forma a se tornar um contribuinte de longo prazo da comunidade. Junte-se a nós e verifique a página de contribuições no website do LibreOffice.

Como começar
----------------------------------------------------------------------

A melhor maneira de contribuir é assinar uma ou mais de nossas listas de discussão, espiar por um tempo e gradualmente utilizar os arquivos de e-mails para se familiarizar com os vários tópicos abordados desde que o código-fonte do LibreOffice foi liberado em Outubro de 2000. Se estiver familiarizado com projetos de código-fonte aberto, verifique nossa lista de tarefas no website do LibreOffice.

Assinar
----------------------------------------------------------------------

Segue algumas listas de discussão que podem ser assinadas em https://www.libreoffice.org/get-help/mailing-lists/

* Notícias: announce@documentfoundation.org *recomendado a todos os usuários* (tráfego leve)
* Lista de usuários principal: users@global.libreoffice.org *um jeito fácil de espiar as discussões* (tráfego intenso)
* Projeto de marketing: marketing@global.libreoffice.org *além do desenvolvimento* (tráfego aumentando)
* Lista geral de desenvolvedores: libreoffice@lists.freedesktop.org (tráfego pesado)

Participar de um ou mais projetos
----------------------------------------------------------------------

Você pode dar importantes contribuições a esse projeto de código aberto mesmo se você tiver pouca experiência em projetos e programação de software. Isso mesmo, você!

Esperamos que você aprecie em trabalhar com o novo LibreOffice 7.5 e que participará de nossa comunidade on-line.

A comunidade LibreOffice

----------------------------------------------------------------------
Códigos-fonte utilizados ou modificados
----------------------------------------------------------------------

Partes com Copyright 1998, 1999 James Clark. Partes com Copyright 1996, 1998 Netscape Communications Corporation.
