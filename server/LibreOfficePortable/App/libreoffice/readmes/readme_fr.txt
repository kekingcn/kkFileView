
======================================================================
Lisez-moi LibreOffice 7.5
======================================================================


Pour les dernières mises à jour de ce fichier readme, voir  https://git.libreoffice.org/core/tree/master/README.md

Ce fichier contient des informations importantes à propos du logiciel LibreOffice. Veuillez les lire avec attention avant de commencer l'installation.

La communauté LibreOffice est responsable du développement de ce produit et souhaiterait vous inviter à participer en qualité de membre de celle-ci. Si vous êtes un nouvel utilisateur, vous pouvez consulter le site de LibreOffice qui contient des informations utiles à propos du projet LibreOffice et de la communauté qui existe autour de lui. Rendez-vous sur https://fr.libreoffice.org/.

Est-ce que LibreOffice est vraiment libre pour tous les utilisateurs ?
----------------------------------------------------------------------

LibreOffice est libre d'utilisation pour tous. Vous pouvez prendre cette copie de LibreOffice, l'installer sur autant d'ordinateurs que vous le souhaitez et l'utiliser comme bon vous semble (y compris l'utilisation commerciale, dans les administrations et les organisations, ainsi que dans l'éducation). Pour de plus amples détails, voir le texte de la licence fourni avec ce téléchargement de LibreOffice.

Pourquoi LibreOffice est il gratuit pour tout utilisateur ?
----------------------------------------------------------------------

Vous pouvez utiliser cette copie de LibreOffice gratuitement parce que des contributeurs individuels et des entreprises sponsors ont conçu, développé, testé, traduit, documenté, supporté, promu et aidé de bien d'autres façons encore à faire ce que LibreOffice est aujourd'hui - le logiciel de bureautique Open Source leader mondial.

Si vous appréciez leurs efforts et voulez vous assurer que LibreOffice poursuive son développement dans le futur, envisagez de contribuer au projet - voir https://www.documentfoundation.org/contribution/. Chacun est libre de contribuer de quelque façon que ce soit.

----------------------------------------------------------------------
Remarques sur l'installation
----------------------------------------------------------------------

LibreOffice nécessite une version récente de l'environnement d'exécution java (JRE) pour l'utilisation complète des fonctionnalités. Le JRE ne fait pas partie du package d'installation LibreOffice, il doit être installé séparément.

Besoins système
----------------------------------------------------------------------

* Microsoft Windows 7 SP1, 8, 8.1 Update (S14) ou 10

Remarquez que les droits administrateur sont nécessaires pour le processus d'installation.

L'enregistrement de LibreOffice comme application par défaut pour les formats Microsoft Office peut être forcée ou supprimée en utilisant les commuteurs de ligne de commande suivants avec l'installeur :

* REGISTER_ALL_MSO_TYPES=1 forcera l'enregistrement de LibreOffice comme application par défaut pour les formats Microsoft Office.
* REGISTER_NO_MSO_TYPES=1 supprimera l'enregistrement de LibreOffice comme application par defaut pour les formats Microsoft Office.

Assurez-vous qu'il y ait assez de mémoire libre dans le répertoire temporaire du système et que vous bénéficiez des droits de lecture, d'écriture et d'exécution. Fermez tous les autres programmes avant de commencer l'installation.

Installation de LibreOffice sur les systèmes basés sur Linux Debian/Ubuntu
----------------------------------------------------------------------

Pour les instructions concernant l'installation d'un pack de langue (après avoir installé la version Anglais US de LibreOffice), veuillez lire la section ci-dessous intitulée Installer un pack de langue.

Lorsque vous décompressez l'archive téléchargée, le contenu décompressé s'affiche dans un sous-répertoire. Ouvrez une fenêtre de gestionnaire de fichiers et naviguez jusqu'au répertoire commençant par « LibreOffice_ », suivi du numéro de version et d'informations sur la plateforme.

Ce répertoire contient un sous répertoire appelé « DEBS ». Changez de répertoire pour le répertoire « DEBS ».

Faites un clic avec le bouton droit dans le répertoire et choisissez « Ouvrir un terminal ». Une fenêtre de terminal s'ouvre. À partir de la ligne de commande de la fenêtre de terminal, saisissez la commande suivante (il vous sera demandé de saisir votre mot de passe administrateur avant que la commande ne soit exécutée) :

Les commandes suivantes installent LibreOffice et les packages d'intégration au bureau (vous pouvez les copier et les coller dans une fenêtre de terminal plutôt qu'essayer de les saisir) :

sudo dpkg -i *.deb

Le processus d'installation est maintenant achevé et vous devez avoir les icônes de toutes les applications LibreOffice dans le menu Applications de l'environnement de bureau.

Installation de LibreOffice sur Fedora, openSUSE, Mandriva et autres systèmes Linux utilisant des packages RPM
----------------------------------------------------------------------

Pour les instructions concernant l'installation d'un pack de langue (après avoir installé la version Anglais US de LibreOffice), veuillez lire la section ci-dessous intitulée Installer un pack de langue.

Lorsque vous décompressez l'archive téléchargée, le contenu décompressé apparaît dans un sous-répertoire. Ouvrez une fenêtre de gestionnaire de fichiers et naviguez jusqu'au répertoire commençant par « LibreOffice_ », suivi du numéro de version et d'informations sur la plateforme.

Le répertoire contient un sous-répertoire appelé « RPMS ». Changez de répertoire pour le répertoire « RPMS ».

Faites un clic avec le bouton droit dans le répertoire et choisissez « Ouvrir un terminal ». Une fenêtre de terminal s'ouvre. À partir de la ligne de commande de la fenêtre de terminal, saisissez la commande suivante (il vous sera demandé de saisir votre mot de passe administrateur avant que la commande ne soit exécutée) :

Pour les systèmes basés sur Fedora : sudo dnf install *.rpm

Pour les systèmes basés sur Mandriva : sudo urpmi *.rpm

Pour les autres systèmes basés sur RPM (openSUSE, etc.) : rpm -Uvh *.rpm

Le processus d'installation est maintenant achevé et vous devez avoir les icônes de toutes les applications LibreOffice dans le menu Bureautique des applications de l'environnement de bureau.

Alternativement, vous pouvez utiliser le script « install » situé dans le répertoire supérieur de cette archive pour exécuter une installation en tant qu'utilisateur. Le script va paramétrer LibreOffice avec son propre profil pour cette installation, séparé du profil LibreOffice normal. Remarquez que cela n'installera pas les parties d'intégration système telles que les éléments de menu de l'environnement et les enregistrements de type MIME de l'environnement.

Notes concernant l'intégration à l'environnement de bureau pour les distributions Linux non couvertes par les instructions d'installation ci-dessus
----------------------------------------------------------------------

Il doit être possible d'installer facilement LibreOffice sur d'autres distributions Linux non spécifiquement couvertes par ces instructions d'installation. Le principal aspect dans lequel peut résider une différence est l'intégration à l'environnement de bureau.

Les répertoires RPM (ou DEB respectivement) contiennent également un package nommé libreoffice7.5-freedesktop-menus- 7.5.01-1.noarch.rpm (ou libreoffice7.5-debian-menus_7.5.01-1_all.deb, respectivement, ou similaire). C'est un package pour toutes les distributions Linux qui prend en charge les spécifications/recommandations de Freedesktop.org (https://en.wikipedia.org/wiki/Freedesktop.org) et est fourni pour l'installation sur d'autres distributions Linux non couvertes dans les instructions susmentionnées.

Installation d'un pack de langue
----------------------------------------------------------------------

Téléchargez le pack langue de la langue et de la plateforme souhaitées. Ils sont disponibles au même endroit que l'archive d'installation principale. À partir du gestionnaire de fichiers Nautilus, extrayez l'archive téléchargée dans un répertoire (votre bureau par exemple). Assurez-vous que vous avez quitté toutes les applications LibreOffice (incluant le démarrage rapide, s'il est activé).

Changez de répertoire pour celui dans lequel vous avez extrait le pack de langue téléchargé.

Maintenant, changez de répertoire pour celui qui a été créé pendant le processus d'extraction. Par exemple, pour le pack de langue français pour un système basé sur Debian/Ubuntu 32-bit, le répertoire est nommé LibreOffice, plus certaines informations de version, plus Linux_x86_langpack-deb_fr.

Maintenant, changez de répertoire pour celui qui contient les packages à installer. Sur des systèmes basés sur Debian/Ubuntu, le répertoire est DEBS. Sur des systèmes Fedora, openSUSE ou Mandriva, le répertoire sera RPMS.

À partir du gestionnaire de fichiers Nautilus, faites un clic avec le bouton droit dans le répertoire et choisissez la commande « Ouvrir un terminal ». Dans la fenêtre de terminal qui vient de s'ouvrir, exécutez la commande pour installer le pack langue (à l'aide de toutes les commandes ci-dessous, il vous sera demandé de saisir votre mot de passe administrateur) :

Pour les systèmes basés sur Debian/Ubuntu : sudo dpkg -i *.deb

Pour les systèmes basés sur Fedora : su -c 'dnf install *.rpm'

Pour les systèmes basés sur Mandriva : sudo urpmi *.rpm

Pour les autres systèmes utilisant RPM (openSUSE, etc.) : rpm -Uvh *.rpm

Maintenant, démarrez l'une des applications LibreOffice - Writer, par exemple. Allez dans le menu Outils et choisissez Options. Dans la boîte de dialogue Options, cliquez sur « Paramètres linguistiques », puis cliquez sur « Langues ». Déroulez la liste « Interface utilisateur » et sélectionnez la langue que vous venez d'installer. Si vous le souhaitez, vous pouvez faire la même chose pour la « touche séparateur de décimales », la « monnaie par défaut » et la « langue par défaut des documents ».

Après avoir réglé ces paramètres, cliquez sur OK. La boîte de dialogue se fermera et vous verrez apparaître un message d'informations indiquant que vos modifications ne seront activées qu'après avoir quitté et redémarré LibreOffice (rappelez-vous de quitter également le démarrage rapide s'il était actif).

La prochaine fois que vous lancerez LibreOffice, il démarrera dans la langue que vous venez d'installer.

----------------------------------------------------------------------
Problèmes au démarrage du programme
----------------------------------------------------------------------

Les difficultés de démarrage de LibreOffice (par exemple, les applications se bloquent) ainsi que les problèmes d'affichage à l'écran sont souvent causés par le pilote de la carte graphique. Si ces problèmes surviennent, veuillez mettre à jour le pilote de votre carte graphique ou essayer d'utiliser le pilote graphique fourni avec votre système d'exploitation.

----------------------------------------------------------------------
Pavé tactile notebook ALPS/Synaptics sous Windows
----------------------------------------------------------------------

En raison d'un problème avec le pilote Windows, vous ne pouvez pas faire défiler un document LibreOffice lorsque vous faites glisser votre doigt sur un pavé tactile ALPS/Synaptics.

Pour activer le défilement avec le pavé tactile, ajoutez les lignes suivantes dans le fichier de configuration « C:\Program Files\Synaptics\SynTP\SynTPEnh.ini » et redémarrez votre ordinateur :

[LibreOffice]

FC = "SALFRAME"

SF = 0x10000000

SF |= 0x00004000

L'emplacement du fichier de configuration peut varier en fonction des différentes versions de Windows.

----------------------------------------------------------------------
Raccourcis clavier
----------------------------------------------------------------------

Seuls les raccourcis clavier (combinaison de touches) non utilisés par le système d'exploitation peuvent être utilisés dans LibreOffice. Si une combinaison de touches dans LibreOffice ne fonctionne pas comme décrit dans l'aide LibreOffice, vérifiez que ce raccourci clavier n'est pas déjà utilisé par le système d'exploitation. Pour corriger de tels conflits, vous pouvez modifier l'assignation des raccourcis clavier du système d'exploitation. Vous pouvez également modifier pratiquement toutes les assignations de touches dans LibreOffice. Pour plus d'informations sur ce sujet, référez-vous à l'aide LibreOffice ou à la documentation d'aide de votre système d'exploitation.

----------------------------------------------------------------------
Problèmes lors de l'envoi de documents par courriel à partir de LibreOffice
----------------------------------------------------------------------

Lors de l'envoi d'un document via "Fichier - Envoyer - Envoyer le document par courriel" ou "Envoyer par courriel en PDF", des problèmes peuvent survenir (le programme plante ou se bloque). Cela est dû au fichier système "Mapi" (Messaging Application Programming Interface) de Windows qui cause des problèmes dans certaines versions de fichiers. Malheureusement, le problème ne peut être circonscrit à un certain numéro de version. Pour plus d'informations, visitez le site https://www.microsoft.com pour rechercher "mapi dll" dans la base de connaissances de Microsoft.

----------------------------------------------------------------------
Remarques importantes sur l'accessibilité
----------------------------------------------------------------------

Pour des informations complémentaires sur les fonctions d'accessibilité de LibreOffice, voir https://www.libreoffice.org/accessibility/

----------------------------------------------------------------------
Aide aux utilisateurs
----------------------------------------------------------------------

La page principale d'aide https://fr.libreoffice.org/get-help/community-support/ offre plusieurs possibilités d'aide sur LibreOffice. Il a peut-être déjà été répondu à vos questions - vérifiez le forum communautaire sur https://nabble.documentfoundation.org/French-f1744075.html ou vérifiez les archives sur la liste « users@fr.libreoffice.org » à https://listarchives.libreoffice.org/fr/users/. Vous pouvez aussi envoyer vos questions à users@fr.libreoffice.org. Si vous souhaitez vous inscrire à la liste (pour obtenir une réponse par courriel), envoyez un courriel vide à users+subscribe@fr.libreoffice.org.

Consultez également la FAQ sur le site web LibreOffice.

----------------------------------------------------------------------
Rapporter des dysfonctionnements & problèmes
----------------------------------------------------------------------

Notre système pour rapporter, suivre et résoudre les bogues est actuellement Bugzilla, hébergé à https://bugs.documentfoundation.org/. Nous encourageons tous les utilisateurs à rapporter les bugs qui pourraient survenir sur leur plate-forme particulière. Le rapport continu des problèmes est l'une des contributions les plus importantes que la communauté des utilisateurs peut apporter au développement et à l'amélioration continus de LibreOffice.

----------------------------------------------------------------------
Contribuer
----------------------------------------------------------------------

La Communauté LibreOffice tirera un grand bénéfice de votre participation active dans le développement de cet important projet Open Source.

En tant qu'utilisateur, vous participez déjà à une part importante du processus de développement de la suite et nous voudrions vous encourager à prendre un rôle encore plus actif dans le but de devenir un contributeur à long terme de la communauté. Rejoignez-nous et rendez-vous sur la page utilisateur du site web LibreOffice.

Pour commencer
----------------------------------------------------------------------

La meilleure façon de commencer à contribuer est de vous inscrire à l'une de nos listes de discussion, suivez-la un petit moment, utilisez les archives pour vous familiariser avec les nombreux sujets couverts depuis que le code source de LibreOffice a été livré en Octobre 2000. Lorsque vous vous sentirez à l'aise, la seule chose que vous aurez à faire sera d'envoyer un courriel de présentation et de vous joindre à l'équipe. Si vous êtes habitués aux projets Open Source, vérifiez sur la liste des besoins du projet, s'il n'y en a pas pour lesquels vous souhaiteriez aider sur le site web LibreOffice.

S'inscrire
----------------------------------------------------------------------

Voici quelques listes de forum sur lesquelles vous pouvez vous inscrire https://fr.libreoffice.org/get-help/mailing-lists/

* Nouvelles : announce@fr.libreoffice.org *recommandée à tous les utilisateurs* (peu de trafic)
* Liste principale d'utilisateurs : users@fr.libreoffice.org *une façon aisé de suivre les discussions* (trafic moyen)
* Projet Marketing : marketing@global.libreoffice.org *au-delà du développement* (en anglais, trafic élevé)
* Liste de développement générale : libreoffice@lists.freedsktop.org (trafic important)

Rejoindre un ou plusieurs projets
----------------------------------------------------------------------

Vous pouvez faire des contributions majeures à cet important projet Open Source, même si vous avez une expérience limitée dans le codage ou le design du programme. Oui, vous !

Nous espérons que vous appréciez de travailler avec le nouveau LibreOffice 7.5 et que vous nous rejoindrez bientôt en ligne.

La communauté LibreOffice

----------------------------------------------------------------------
Code source utilisé / modifié
----------------------------------------------------------------------

Portions Copyright 1998, 1999 James Clark. Portions Copyright 1996, 1998 Netscape Communications Corporation.
