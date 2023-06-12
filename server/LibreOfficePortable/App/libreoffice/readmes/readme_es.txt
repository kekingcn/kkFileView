
======================================================================
Léame de LibreOffice 7.5
======================================================================


Para consultar la versión más reciente de este «léame», visite https://git.libreoffice.org/core/tree/master/README.md

Este archivo contiene información importante sobre el programa LibreOffice. Se recomienda leer atentamente esta información antes de comenzar con la instalación.

La comunidad de LibreOffice es responsable por el desarrollo de este producto, e invita a todos a que consideren participar como miembros de la comunidad. Los usuarios nuevos pueden visitar el sitio de LibreOffice, donde encontrarán información ampliada sobre el proyecto LibreOffice y las comunidades que existen a su alrededor. Visite https://www.libreoffice.org/.

¿Realmente LibreOffice es gratuito para cualquier usuario?
----------------------------------------------------------------------

LibreOffice es gratuito para todos. Puede tomar esta copia de LibreOffice e instalarla en cuantos equipos desee, y usarla para cualquier propósito (incluidos los usos comercial, gubernamental, en administraciones públicas y educativo). Para más detalles consulte la licencia incluida en esta descarga de LibreOffice.

¿Por qué LibreOffice es gratuito para cualquier usuario?
----------------------------------------------------------------------

Puede usar esta copia de LibreOffice en forma gratuita debido a que los individuos que contribuyen y las empresas patrocinadoras han diseñado, desarrollado, verificado, traducido, documentado, brindado asistencia, publicitado y ayudado de muchas otras formas para que LibreOffice sea lo que es actualmente: el líder mundial en software de productividad de código abierto para el hogar y la oficina.

Si aprecia esos esfuerzos, y le gustaría asegurar el futuro de LibreOffice, considere contribuir al proyecto. Consulte https://es.libreoffice.org/comunidad/involucrate para más detalles. Cualquiera puede realizar contribuciones de alguna manera.

----------------------------------------------------------------------
Notas sobre la instalación
----------------------------------------------------------------------

LibreOffice requiere una versión reciente del Entorno de ejecución de Java (JRE) para una funcionalidad completa. JRE no es parte del paquete de instalación de LibreOffice, y debería instalarlo de forma separada.

Requisitos del sistema
----------------------------------------------------------------------

* Microsoft Windows 7 SP1, 8, 8.1 Update (S14) o 10

Observe que se necesitan privilegios administrativos para el proceso de instalación.

Se puede forzar o evitar que LibreOffice se registre como aplicación predeterminada para los formatos de Microsoft Office usando las opciones siguientes del instalador en la línea de órdenes:

* REGISTER_ALL_MSO_TYPES=1 forzará el registro del LibreOffice como la aplicación predeterminada para los formatos de Microsoft Office.
* REGISTER_NO_MSO_TYPES=1 eliminará el registro del LibreOffice como la aplicación predeterminada para los formatos de Microsoft Office.

Asegúrese de que tenga memoria disponible suficiente en el directorio temporal del sistema y compruebe que cuente con los privilegios de acceso de lectura, escritura y ejecución. Cierre todos los demás programas antes de comenzar el proceso de instalación.

Instalación de LibreOffice en sistemas Linux basados en Debian/Ubuntu
----------------------------------------------------------------------

Para saber cómo instalar un paquete de idioma (luego de haber instalado la versión en inglés de EE. UU. de LibreOffice) lea la sección titulada «Instalar un paquete de idioma» más abajo.

Cuando desempaquete el archivador descargado, verá que su contenido se ha descomprimido en un subdirectorio. Abra una ventana del gestor de archivos, y muévase al directorio que comienza con «LibreOffice_», seguido del número de versión e información de la plataforma.

Este directorio contiene un subdirectorio llamado «DEBS». Cambie el directorio actual por «DEBS».

Pulse con el botón derecho del ratón sobre el directorio y elija «Abrir en un terminal». Se abrirá una ventana de terminal. Desde la línea de órdenes de la ventana, escriba la orden siguiente (se le solicitará su contraseña de administración antes de que se ejecute la orden):

Las órdenes siguientes instalarán LibreOffice y los paquetes de integración con el escritorio (puede copiarlos y pegarlos en la pantalla del terminal):

sudo dpkg -i *.deb

El proceso de instalación se ha completado, y se deben tener iconos para todas las aplicaciones de LibreOffice en el menú Aplicaciones/Oficina de su escritorio.

Instalación de LibreOffice en Fedora, openSUSE, Mandriva y otros sistemas Linux que utilizan paquetes RPM
----------------------------------------------------------------------

Para saber cómo instalar un paquete de idioma (luego de haber instalado la versión en inglés de EE. UU. de LibreOffice) lea la sección titulada «Instalar un paquete de idioma» más abajo.

Cuando desempaquete el archivador descargado, verá que su contenido se ha descomprimido en un subdirectorio. Abra una ventana del gestor de archivos, y muévase al directorio que comienza con «LibreOffice_», seguido del número de versión e información de la plataforma.

Este directorio contiene un subdirectorio llamado «RPMS». Cambie el directorio actual por «RPMS».

Pulse con el botón derecho del ratón sobre el directorio y elija «Abrir en un terminal». Se abrirá una ventana de terminal. Desde la línea de órdenes de la ventana, escriba la orden siguiente (se le solicitará su contraseña de administración antes de que se ejecute la orden):

Para los sistemas basados en Fedora: sudo dnf install *.rpm

Para los sistemas basados en Mandriva: sudo urpmi *.rpm

Para otros sistemas basados en RPM (openSUSE, etc.): rpm -Uvh *.rpm

El proceso de instalación se ha completado, y se deben tener iconos para todas las aplicaciones de LibreOffice en el menú Aplicaciones/Oficina de su escritorio.

También puede emplear la secuencia de órdenes «install», ubicada en la carpeta superior de este archivador, para instalar la aplicación a nivel de usuario. La secuencia de órdenes configurará LibreOffice para que tenga su propio perfil, en vez de usar el de su instalación normal de LibreOffice. Cabe resaltar que esto no instalará elementos de integración con el escritorio, como las entradas en el menú o los registros de tipo MIME.

Observaciones acerca de la integración con el escritorio para distribuciones de Linux que no se encuentran detalladas en las instrucciones de instalación precedentes
----------------------------------------------------------------------

No debería resultar complicada la instalación de LibreOffice en otras distribuciones Linux no incluidas en estas instrucciones. Las diferencias principales que podría encontrar están en la integración con el escritorio.

La carpeta RPMS (o DEBS, según el caso) contiene también un paquete llamado «libreoffice7.5-freedesktop-menus-7.5.0.1-1.noarch.rpm» (o libreoffice7.5-debian-menus_7.5.0.1-1_all.deb»). Este paquete es para todas las distribuciones Linux compatibles con las especificaciones de Freedesktop.org (https://en.wikipedia.org/wiki/Freedesktop.org) y se proporciona para su instalación en distribuciones Linux no mencionadas en las instrucciones anteriores.

Instalación de un paquete de idioma
----------------------------------------------------------------------

Descargar el paquete de idioma correspondiente al idioma y plataforma deseados. Están disponibles en la misma ubicación que el archivo de instalación principal. Desde el gestor de archivos Nautilus, extraiga el archivo descargado en algún directorio (por ejemplo, en el escritorio). Hay que asegurarse de haber cerrado todas las aplicaciones de LibreOffice (incluido el inicio rápido, si estuviera ejecutándose).

Cambiarse al directorio donde se extrajo el paquete de idioma descargado.

Ahora cambie el directorio actual por el que se creó durante el proceso de extracción. Por ejemplo, para el paquete de idioma español y un sistema de 32 bits basado en Debian/Ubuntu, el directorio se llama LibreOffice_, más información sobre la versión, más Linux_x86_langpack-deb_es.

Ahora cambie el directorio actual por el que contiene los paquetes para instalar. En sistemas basados en Debian/Ubuntu, el directorio será DEBS. En Fedora, openSUSE o Mandriva, el directorio será RPMS.

Desde el gestor de archivos Nautilus, pulse con el botón derecho del ratón en la carpeta y elija la orden «Abrir en un terminal». En la ventana de terminal que se acaba de abrir, ejecute la orden para instalar el paquete de idiomas (con todas las órdenes siguientes, puede que se le solicite escribir la contraseña de administrador):

Para los sistemas basados en Debian o Ubuntu: sudo dpkg -i *.deb

Para los sistemas basados en Fedora: su -c 'dnf install *.rpm'

Para los sistemas basados en Mandriva: sudo urpmi *.rpm

Para otros sistemas que usan RPM (openSUSE, etc.): rpm -Uvh *.rpm

Ahora, ejecute una de las aplicaciones de LibreOffice, por ejemplo, Writer. Vaya al menú Herramientas y elija Opciones. En el cuadro de diálogo Opciones, pulse «Configuración de idiomas» y luego «Idiomas». En la lista «Interfaz de usuario» seleccione el idioma que acaba de instalar. Si así lo desea, puede hacer lo mismo para «Configuración regional», «Moneda predeterminada» e «Idiomas predeterminados para documentos».

Después de ajustar esas configuraciones, pulse Aceptar. El cuadro de diálogo se cerrará y podrá observar un mensaje informativo que indica que los cambios se activarán después de que cierre LibreOffice y lo abra de nuevo (recuerde cerrar también el inicio rápido, si se estuviera ejecutando).

La próxima vez que se ejecute LibreOffice, se iniciará con el idioma que acaba de instalarse.

----------------------------------------------------------------------
Problemas durante el inicio del programa
----------------------------------------------------------------------

A menudo, las dificultades de inicio de LibreOffice (p. ej., los bloqueos de la aplicación), así como los problemas relacionados con la representación en pantalla, tienen origen en el controlador de la tarjeta gráfica. Si ocurren estos problemas, actualice el controlador de su tarjeta gráfica o intente utilizar el controlador gráfico que se incluye en el sistema operativo.

----------------------------------------------------------------------
Paneles táctiles de portátiles ALPS/Synaptics en Windows
----------------------------------------------------------------------

Debido a un problema con el controlador de Windows, no puede desplazarse por los documentos de LibreOffice al deslizar su dedo en un panel táctil ALPS/Synaptics.

Para activar el desplazamiento con el panel táctil, añada los renglones siguientes al archivo de configuración C:\Program Files\Synaptics\SynTP\SynTPEnh.ini y reinicie el equipo:

[LibreOffice]

FC = "SALFRAME"

SF = 0x10000000

SF |= 0x00004000

La ubicación del archivo de configuración puede variar en diferentes versiones de Windows.

----------------------------------------------------------------------
Atajos de teclado
----------------------------------------------------------------------

Solo puede utilizar en LibreOffice los atajos (combinaciones de teclas) que el sistema operativo no utilice. Si una combinación en LibreOffice no funciona como se describe en la ayuda de LibreOffice, compruebe si el sistema operativo ya está utilizando esa combinación. Para resolver estos conflictos, puede cambiar las teclas asignadas por el sistema. O bien, puede modificar casi cualquier asignación de teclas en LibreOffice. Para más información sobre este tema, refiérase a la ayuda de LibreOffice o a la documentación de su sistema operativo.

----------------------------------------------------------------------
Problemas al enviar documentos por correo electrónico desde LibreOffice
----------------------------------------------------------------------

Al enviar un documento mediante «Archivo ▸ Enviar ▸ Documento como correo electrónico» o «Documento como adjunto PDF», es posible que ocurran problemas (el programa puede colgarse o cerrarse inesperadamente). Esto se debe al archivo de sistema de Windows «Mapi» (‘Messaging Application Programming Interface’, por sus siglas en inglés) que provoca problemas en algunas versiones del archivo. Desafortunadamente, el problema no está limitado a un número de versión específico. Para más información, visite www.microsoft.com  y busque «mapi dll» en la Microsoft Knowledge Base.

----------------------------------------------------------------------
Notas importantes acerca de la accesibilidad
----------------------------------------------------------------------

Para obtener más información sobre las funcionalidades de accesibilidad en LibreOffice véase https://es.libreoffice.org/recibe-ayuda/accesibilidad/

----------------------------------------------------------------------
Asistencia a usuarixs
----------------------------------------------------------------------

La página de asistencia principal le ofrece varios métodos para obtener ayuda con LibreOffice. Quizá su pregunta ya haya sido respondida; visite el foro comunitario en https://www.documentfoundation.org/nabble/ o busque en el archivo de la lista de correo «users@es.libreoffice.org» en https://listarchives.libreoffice.org/es/users/. También puede enviar sus preguntas a users@es.libreoffice.org. Si quiere suscribirse a la lista (para obtener las respuestas en su correo), envíe un mensaje vacío a: users+subscribe@es.libreoffice.org.

Consulte también la sección de preguntas frecuentes en el sitio web de LibreOffice.

----------------------------------------------------------------------
Informar de defectos y problemas
----------------------------------------------------------------------

Nuestro sistema de seguimiento de errores es Bugzilla, hospedado en bugs.documentfoundation.org. Animamos a todos los usuarios a que informen de cualesquier defectos que pudieran producirse en sus plataformas. Informar activamente de defectos es una de las contribuciones más importantes que la comunidad puede realizar para ayudar al desarrollo y mejora continua de LibreOffice.

----------------------------------------------------------------------
Involucrarse
----------------------------------------------------------------------

La comunidad de LibreOffice se beneficiaría mucho con su participación activa en el desarrollo de este importante proyecto de código abierto.

Como usuario, usted ya es una parte valiosa del proceso de desarrollo de la suite, y nos gustaría animarle a asumir un papel más activo con miras a ser un colaborador de la comunidad a largo plazo. Únase a nosotros y visite la página de contribuciones en el sitio web de LibreOffice.

Cómo comenzar
----------------------------------------------------------------------

La mejor manera de comenzar a contribuir es suscribirse a una o más de las listas de distribución y, gradualmente, leer los mensajes de los archivos para familiarizarse con los diversos temas tratados en ellas desde que se liberara el código fuente de LibreOffice en octubre de 2000. Solo es necesario enviar, cuando esté preparado/a, un mensaje de presentación para empezar a colaborar. Si tiene experiencia con otros proyectos de código abierto, visite las listas de tareas por hacer en el sitio web de LibreOffice y vea si hay algo en lo que pueda ayudar.

Suscribirse
----------------------------------------------------------------------

Encuentre las listas de correo a las que es posible suscribirse en es.libreoffice.org

* Noticias: announce@documentfoundation.org *se recomienda para todos los usuarios* (poco tráfico)
* Lista de usuarios principal: users@global.libreoffice.org *manera fácil de acechar las discusiones* (tráfico alto)
* Proyecto de mercadotecnia: marketing@global.libreoffice.org *más allá del desarrollo* (tráfico medio)
* Lista general para desarrollo: libreoffice@lists.freedesktop.org (tráfico alto)

Unirse a uno o más proyectos
----------------------------------------------------------------------

Puede hacer contribuciones importantes a este gran proyecto de código abierto, aun si su experiencia en programación o diseño de software es limitada. ¡No lo dude!

Esperamos que disfrute trabajar con el nuevo LibreOffice 7.5 y que participe con nuestra comunidad en línea.

La comunidad de LibreOffice

----------------------------------------------------------------------
Código fuente utilizado/modificado
----------------------------------------------------------------------

Partes con derechos de autor 1998-1999 de James Clark. Partes con derechos de autor 1996-1998 Netscape Communications Corporation.
