Java binaries go here or in X:\PortableApps\CommonFiles\Java for shared use.

To enable Java, copy the Java files from a local install, usually C:\Program Files\Java\jre1.5.0_11,
to this directory.  Copy the whole structure intact (so you'd have a lib and a bin directory in this
Java directory when complete.

Then, create a text file called javaportable.ini in the same directory as this readme.txt with the
following in it (altering for Java version):

[JavaPortable]
Vendor=Sun Microsystems Inc.
Version=1.5.0_11
URL=http://java.sun.com/





Deutsch:
Java Bin‰rdateien sollten Sie zur gemeinsamen Nutzung auf 
[Laufwerksbuchstabe des Sticks]:\PortableApps\CommonFiles\Java ablegen.

(Diesen Ordner hier sollten Sie lediglich verwenden, wenn nur OpenOffice.org Portable
Java mobil nutzen soll.)

Um die portable Java-Nutzung zu aktivieren, kopieren Sie bitte in dieses Verzeichnis alle Dateien (nicht den Ordner selbst!)
aus Ihrer lokalen Java Runtime Installation.

Diese befinden sich normalerweise (Standardinstallation) in einem Verzeichnis wie z. B.
C:\Programme\Java\1.5.0_11.

In diesem Verzeichnis sollten sich nach der Installation zwei Unterordner (lib, bin) 
sowie ca.7 weitere Dateien befinden. 

Erstellen Sie dann bitte eine Datei mit Namen javaportable.ini im mobilen Java-Verzeichnis, 
(am Besten hier [Laufwerksbuchstabe des Sticks]:\PortableApps\CommonFiles\Java)
mit folgendem Inhalt (angepaﬂt auf Ihre Java Version):

[JavaPortable]
Vendor=Sun Microsystems Inc.
Version=1.5.0_11
URL=http://java.sun.com/