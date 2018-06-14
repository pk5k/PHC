### English readme in progress...
---
# PHP Hypercell / PHC

# Inhalt

- [Vorwort](#vorwort)
- [Installation](#installation)
- [PHC Komponentenmodell](#phc-komponentenmodell)
	- [Cellspace](#cellspace--cs)
	- [Hypercell](#hypercell--hc)
	- [Assembly](#assembly)
	- [Assembly-Typen](#assembly-typen)
	- [Surfacing](#surfacing)


# Vorwort 
PHP Hypercell (PHC) ist ein System, welches die Entwicklung von PHP basierten serverseitig getriebenen Webanwendungen übersichtlicher, einheitlicher und wiederverwendbarer gestalten soll. Die Entwicklung mit PHC geschieht anhand des PHC Komponentenmodells welches in diesem Dokument erläutert wird.

**PHC beinhaltet**

- Hypercell Framework (hcf)
	- Laufzeitumgebung für PHC-Anwendungen
	- Liefert diverse Komponenten für die Vereinfachung von Routing, usw.
- Hypercell Development Kit (hcdk)
	- Command-Line-Interface (CLI)
	- Hypercell Compiler

**Der Name Hypercell**

Als Hypercell werden innerhalb von PHC die einzelnen Komponenten bezeichnet, die in diesem System eine zentrale Rolle spielen.

- `Hyper-` von Hyperlink da eine Komponente (Hypercell) immer über einen Namen adressiert wird welcher vom Nutzen her an einen Hyperlink erinnert, da sich hinter diesem alles relevante zu der jeweiligen Komponente befindet.
- `-cell` (Daten-)Kapselung spielt in diesem System eine wichtige Rolle. Außerdem ähnelt die Struktur einer Komponente der einer biologischen Zelle.

Um besser zwischen Paketen und Klassen innerhalb und außerhalb des PHC Komponentenmodells differenzieren zu können, wurde für die PHC bezogenen Teile eine eigene Terminologie gewählt.

# Installation

Um eine Webanwendung mit PHC entwickeln zu können, wird das Hypercell Development Kit benötigt. Folgende Basis ist für die Installation des hcdk auf dem Entwicklungssystem erforderlich:

- Terminal
- git
- PHP Version >= 5.4

Per Kommandozeile in ein beliebiges Verzeichnis navigieren und folgenden Befehl ausführen

	git clone https://github.com/pk5k/PHC.git

Anschließend folgenden Befehl ausführen damit der *hcdk* Alias für die Kommandozeile korrekt gesetzt wird

	bash PHC/hcdk.cs/bin/setup.sh

Wenn die verwendete Kommandozeile weder *.bash_profile* noch *.bash_rc* als Konfigurationsdatei nutzt, kann zusätzlich der Name der zu verwendenden Datei übergeben werden.

	bash PHC/hcdk.cs/bin/setup.sh .name_of_my_terminal_config
	
Nachdem das Setup-Skript ausgeführt wurde, muss die Kommandozeilensitzung erneut gestartet werden. Anschließend sollte per Eingabe von `hcdk`
die CLI-Hilfe des hcdks angezeigt werden - die Installation ist somit abgeschlossen.

## Probleme unter Windows

Die obigen Installationsanweisungen beziehen sich auf UNIX-Systeme. Unter Windows muss deshalb bei der Installation folgendes beachtet werden:

1. Als Kommandozeile sollte die git Bash verwendet werden welche mit der Installation von GIT geliefert wird.
2. Wird beim ausführen von `setup.sh` keine Konfiguration gefunden, muss im Home-Verzeichnis des aktuellen Benutzers eine Datei namens `.bash_profile` erstellt werden.
3. Wird der Befehl `php` beim ausführen von einem `hcdk` Befehls nicht gefunden, muss in der vorletzten Zeile der Datei `PHC/hcdk.cs/bin/hcdk.sh` der Befehl `php` durch den expliziten Pfad zu der php.exe angegeben werden (im Falle von PHP via XAMPP wäre das /c/xampp/php/php.exe).

# PHC Komponentenmodell

Das PHC Komponentenmodell arbeitet auf Dateisystem-Ebene. Anwendungen die dieses Modell verwenden werden in Paketen - *Cellspaces* - entwickelt und per *surfacing* zugänglich gemacht. Jeder Cellspace weißt die selbe Grundstruktur auf

 - Cellspace
 	- Hypercell
 		- Assembly

 		
## Cellspace / CS

Als Cellspace wird ein Paket bezeichnet, welches mehrere Hypercells zusammenfasst (ähnlich zu .jar Dateien von JAVA). Dabei ist es unwichtig, ob dieses Paket als Bibliothek oder als tatsächliche Implementierung einer Anwendung fungiert. Ein Cellspace wird durch ein beliebiges Verzeichnis innerhalb eines Dateisystems repräsentiert, auf dessen oberster Ebene sich eine Datei namens *cellspace.ini* befindet. Alle nötigen Daten eines Cellspaces (Quellcode, kompilierte Hypercells, ...) befinden sich innerhalb dieses Verzeichnisses. 

Das hcdk agiert immer auf Cellspace-Ebene.

### Erstellen

Ein neuer Cellspace lässt sich erstellen, indem man folgenden hcdk Befehl in einem leeren Verzeichnis ausführt

	hcdk create --nsroot rootNamespace

Dabei wird die cellspace.ini mit ihrer Standardkonfiguration angelegt und das Quell- (src/) sowie Zielverzeichnis (build/) erstellt. Alle enthaltenen Hypercells können nach dem Einbinden in eine Anwendung über den Namensraum *rootNamespace* angesprochen werden.

![created-cellspace](https://image.ibb.co/bDFdFJ/cellspace_created.png)

### Kompilieren

Das Kompilieren geschieht immer Paketweise. Der Cellspace lässt sich kompilieren, indem man folgenden Befehl im gewünschten Cellspace-Stammverzeichnis ausführt

	hcdk build
	
Nach dem Bauvorgang wird findet sich im Stammverzeichnis des Cellspaces eine Datei namens *cellspace.map*. Im Zielverzeichnis befinden sich die kompilierten Hypercells.

### cellspace.map

Nach dem kompilieren eines Cellspaces werden alle enthaltenen Hypercells in dieser Datei gelistet. Hierbei wird der vollqualifizierten Name jeder Hypercell dem jeweiligen Pfad zu der kompilierten Datei (relativ zum Cellspace-Root) zugeordnet. Diese Datei wird vom Hypercell Framework benötigt, um das automatische Laden der Klassen zu ermöglichen. Außer dieser Datei und dem Hypercell Zielverzeichnis können die restlichen Dateien für den Produktivbetrieb aus dem Cellspace gelöscht werden.

Die aktuell hinterlegte Map-Datei kann mit dem Konsolenbefehl `hcdk map` angezeigt werden

	rootNamespace\package\MyCell=build/rootNamespace.package.MyCell.hc
	rootNamespace\package\MyCell\MySubCell=build/rootNamespace.package.MyCell.MySubCell.hc

### cellspace.ini

Diese Datei enthält Informationen für den Kompilierungsvorgang eines Pakets. Diese Datei wird nicht zur Laufzeit benötigt. Im Folgenden eine kurze Erklärung der einzelnen Zeilen innerhalb der Konfigurationsdatei: 

	nsroot = "rootNamespace"

Namensraum unter welchem die in diesem Cellspace enthaltenen Hypercells adressiert werden

	source = "src/"
	
Verzeichnis relativ zum Cellspace-Root, in welchem sich die Quelldateien für kompilierbare Hypercells befinden

	target = "build/"

Verzeichnis relativ zum Cellspace-Root, in welches die kompilierten Hypercells geschrieben werden

	format = true

Wenn true, wird der Quellcode innerhalb einer kompilierten Hypercell formatiert

	ignore = []
	
Array von Verzeichnisnamen (relativ zm Quellverzeichnis) die zum Kompilierungszeitpunkt übersprungen werden sollen.

## Hypercell / HC

Eine Hypercell ist nach dem Kompilierungsvorgang im Grunde eine herkömmliche PHP-Klasse. Die Eigenschaften und Methoden dieser Klasse werden jedoch nicht direkt selbst geschrieben, sondern über einzelne Baugruppen (Assemblies) abgebildet. In der Entwicklungsphase einer Hypercell wird diese durch ein Verzeichnis repräsentiert, welches sich innerhalb des Cellspace-Quellverzeichnisses befindet. Nur wenn ein Verzeichnis zum Kompilierungszeitpunkt Assemblies enthält, wird es als Hypercell behandelt - andernfalls ist es ein Unterpaket. Hypercells können andere Komponenten und Unterpakete enthalten. 

### HCFQN

Relativ zum Cellspace-Quellverzeichnis welches durch den Namespace-Root repräsentiert wird, wird der Name jeder Verzeichnisebene (Hypercell/Unterpaket) dem vollqualifizierten Name der Komponente hinzugefügt und durch Punkte voneinander getrennt. Über den sogenannten HCFQN (**H**yper**c**ell **F**ully **Q**ualified **N**ame) lassen sich die einzelnen Hypercells adressieren.

Eine gültige HCFQN für eine Hypercell namens *Component* innerhalb des Pakets *utils* welches sich in einem Cellspace mit dem Namespace-Root *app* befindet wird wie folgt geschrieben
	
	app.utils.Component

Eine Ausnahme bei der HCFQN Notation bildet PHP selbst, da dort Namensräume standardmäßig mittels einem Backslash (\\) getrennt werden. Damit PHP weiß, dass ein absoluter Namensraum referenziert wird, muss der HCFQN zusätzlich ein Backslash vorangestellt werden. Ansonsten wird vom Namensraum der Hypercell ausgegangen, die diese Komponente referenziert. Aus diesen Gründen muss innerhalb von PHP-Assemblies der obige HCFQN wie folgt geschrieben werden

	\app\utils\Component
	
Diese Ausnahme trifft nur bei direkt ausgeführtem PHP-Skript zu. Wird innerhalb einer PHP Assembly ein HCFQN in Form eines Strings erwartet, kann die übgliche Notation verwendet werden.

### Reguläre und abstrakte Hypercells

Beginnt der Verzeichnisname einer Hypercell mit einem Großbuchstaben, so wird diese zu einer regulären Klasse kompiliert. Handelt es sich um einen Kleinbuchstaben, ist das Resultat eine [abstrakte Klasse](http://php.net/manual/de/language.oop5.abstract.php).

### Hinzufügen zu einem Cellspace

Eine neue (leere) Hypercell lässt sich zu einem Cellspace hinzufügen, indem man folgenden Befehl in der Kommandozeile ausführt

	hcdk add rootNamespace.mySubPackage.MyCell
		
Dabei steht `rootNamespace.mySubPackage.MyCell` für den HCFQN der neuen Komponente anhand welcher das hcdk die Ordnerstruktur anlegen wird. 

![created-hc](https://image.ibb.co/eKC3hy/hc_created_fold.png)

## Assembly

Assemblies sind die einzelnen Baugruppen einer Komponente. Während der Entwicklungsphase einer Hypercell wird eine Baugruppe jeweils durch eine Datei innerhalb des Hypercell-Verzeichnisses repräsentiert. Der Name der Datei beschreibt die Art der Baugruppe - den Assembly-Typen. Der Assembly-Typ besteht mindestens aus einem Rollennamen und wird oftmals von einem Quelltypen gefolgt. Rollenname sowie Quelltyp werden in Kleinbuchstaben geschrieben und durch einen Punkt (.) voneinander getrennt.

| Assembly-Typ 		| Rollenname  | Quelltyp 	|
|---------------------	|------------	|----------	|
| **base** 	  		| base 		| *Keiner* 	|
| **client.js** 		| client 	 	| js  	   	|
| **config.ini** 		| config 		| ini 		|
| **config.json** 		| config 		| json 		|
| ... 				|			|			| 

Hierbei legt der Rollenname fest, wofür der Inhalt dieser Baugruppe verwendet wird. Sofern vorhanden, bestimmt der Quelltyp das Eingangsformat der Datei und wie dieses zu Methoden und Eigenschaften verarbeitet wird. Gibt es innerhalb eines Assembly-Typs keine Quelltypen, handelt es sich um ein proprietäres Format welches im Rahmen der jeweiligen Rollendefinition erklärt wird.

### Hinzufügen zu einer Hypercell

Dem Befehl `hcdk add HCFQN` können zusätzlich Assemblies angegeben werden, die mit dieser Hypercell zu einem Cellspace hinzugefügt werden sollen. Diesem Befehl können nach dem gewünschten HCFQN zusätzlich die benötigten Assemblies angegeben werden

	hcdk add rootNamespace.mySubPackage.MyCell config.ini controller.php

In diesem Fall fügt das hcdk die Assemblies *config.ini* sowie *controller.php* in das Verzeichnis der Hypercell *rootNamespace.mySubPackage.MyCell* ein. Je nach Assembly-Typ befüllt das hcdk die Datei mit dem passenden Grundgerüst. Ein nachträgliches hinzufügen von Assemblies ist noch nicht über die Kommandozeile möglich.

![hypercell-assemblies](https://image.ibb.co/cQ5pNy/hc_created.png)

### Besondere Eigenschaften

Manche Assembly-Typen haben spezielle Eigenschaften, die die Art ihrer Verarbeitung im Kompilierungsvorgang beeinflussen.

#### Attachment

Benötigt eine Baugruppe ihren unveränderten Inhalt zur Laufzeit, so handelt es sich bei dieser Assembly um ein Attachment. Der Inhalt dieser Baugruppen wird zum Kompilierungszeitpunkt am Ende der Hypercell eingebettet. Attachments können im Rahmen von *surfacing* zur Laufzeit überschrieben werden. 

#### Executable

Ist der Quelltyp einer Assembly *PHP* so wird deren Inhalt im Kompilierungsvorgang nicht verarbeitet sondern direkt unter dem sogenannten *Executable Offset* einer Hypercell eingebettet. Somit kann man es als ein ausführbares Attachment bezeichnen, welches sich jedoch nicht zur Laufzeit überschreiben lässt. Das *Executable Offset* erweitert den Namensraum der jeweiligen Hypercell um *\_\_EO\_\_* unter welchem der ausführbare Baugruppen Inhalt eingebettet und in der Hypercell-Klasse referenziert wird. Dieser erweiterte Namensraum ist nötig, um etwaige Namenskollisionen mit anderen Hypercells zu vermeiden, da der Inhalt des *Executable Offsets* zur Laufzeit von PHP geparsed wird. 

#### Placeholders

Manche Assemblies erlauben die Verwendung von Platzhaltern. Mit Platzhaltern lassen sich andere Assemblies oder Teile der eigenen innerhalb einer Hypercell referenzieren. Der Grundaufbau eines Platzhalters ist `{{typ:wert}}` welcher innerhalb einer Assembly verwendet werden kann, sofern sie diese Eigenschaft besitzt. Es ist möglich, Platzhalter ineinander zu verschachteln: `{{method:{{property:method_to_use}}}}`. Dabei werden diese von innen nach außen aufgelöst. 

Bei der Funktionsweise der Platzhalter ist es wichtig zu wissen, dass diese im Kontext einer Methode agieren. Somit werden die Platzhalter erst beim Aufruf dieser Methode innerhalb einer kompilierten Hypercell ersetzt.

Folgende Platzhalter stehen zur Verfügung

| Typ  | Wert | Bedeutung | Beispiel |
|---|---|---|---|
| method | *Methodenname* | Die angegebene Methode wird aufgerufen und deren Rückgabewert anstelle des Platzhalters verwendet. Die Methode muss sich innerhalb der selben Hypercell befinden. | `{{method:myMethod}}` | 
| property | *Eigenschaftsname*  | Der Platzhalter wird durch den Wert der angegebenen Eigenschaft ersetzt. Die Eigenschaft muss sich innerhalb der selben Hypercell befinden. Handelt es sich bei der Eigenschaft um ein Objekt, so kann direkt über den Placeholder auf einen Schlüssel dieses Objekts zugegriffen werden. | `{{property:my_prop}}` <br/>  oder `{{property:my_obj_prop.my_key}}` |
| const | *Konstante* | Wert einer Konstante mit welchem der Platzhalter ersetzt werden soll. | `{{const:HCFQN}}` |
| arg | 0-n | Innerhalb der Methode in welchem der Platzhalter agiert kann hiermit ein Index der übergebenen Funktionsvariablen verwendet werden, durch deren Wert der Platzhalter ersetzt werden soll. | `{{arg:0}}` |
| local | *Variablenname* | Wert einer lokalen Variable, welche in dieser Methode existiert und gültig ist. | `{{local:var}}` |

#### Sections

Als Section wird ein Bereich innerhalb der Baugruppe bezeichnet, welcher eine anhand des Quelltyps zu erzeugende Methode beschreibt. Eine Section beginnt mit dem Section-Header und endet entweder am Dateiende oder der nächsten Section. Zwischen den Section-Headern steht der Section-Body, wessen Inhalt abhängig vom Quelltyp ist. Der Section-Header ist wie folgt aufgebaut
	
	[BINDUNG][SICHTBARKEIT][NAME][DELIMITER]

Die erste Section jeder Assembly mit dieser Eigenschaft kann ohne Header definiert werden. Ist dies der Fall, wird als Header `#~stdTpl:` verwendet. 

##### Bindung

| Symbol | Bedeutung | Beispiel Header |
|:------:|:---------:|:--------|
| @ 		| Statisch | `@~myStaticMethod:` |
| # 		| Regulär | `#~myRegularMethod:` |

Im Falle einer statischen Bindung, kann innerhalb dieser Methode lediglich auf statische Eigenschaften und Methoden der Hypercell referenziert werden.

##### Sichtbarkeit

| Symbol | Bedeutung | Beispiel Header |
|:------:|:---------:|:--------|
| - 		| Private | `#-myPrivateMethod:` |
| ~		| Protected | `#~myProtectedMethod:` |
| + 		| Public | `@+myPublicStaticMethod:` |

##### Name

Der angegebene Name ist der Name der späteren Methode. Hierbei können alle Zeichen verwendet werden, die für eine herkömmliche Methode zulässig sind.

##### Delimiter

Anhand des Delimiters wird der Header vom eigentlichen Body abgegrenzt. Als Delimiter-Symbol wird ein Doppelpunkt (`:`) erwartet.


## Assembly-Typen

Im folgenden werden die verschiedenen Assembly-Typen erklärt, aus denen sich eine Hypercell zusammensetzt.

### base

| Attachment | Executable | Placeholders | Sections |
|:----------:|:----------:|:------------:|:---------:|
| Nein 	    | Nein       | Nein         | Nein 	 |

Diese Baugruppe legt fest, von welcher Klasse oder Hypercell diese Komponente abgeleitet werden soll. Dabei wird der Name der abzuleitenden Klasse als Inhalt der Datei angegeben. 

Will man z.B. eine Exception implementieren muss von der PHP-Klasse *Exception* abgeleitet werden, welche somit als Inhalt der Base-Assembly benötigt wird. Unabhängig davon, ob von einer Hypercell oder einer regulären PHP-Klasse abgeleitet wird, wird der Name der abzuleitenden Klasse in der HCFQN-Notation erwartet. Fügt man das Schlüsselwort *implicit* hinter den Namen der abzuleitenden Klasse an, so wird beim instanzieren der Eltern-Konstruktor am Ende des eigenen Konstruktors aufgerufen.
	
Mit Eltern-Konstruktor Aufruf am Ende des eigenen

	absolute.namespace.toMy.SuperClass implicit
	
Ohne Eltern-Konstruktor Aufruf am Ende des eigenen

	absolute.namespace.toMy.SuperClass

### client

Client Assemblies enthalten Daten, welche im Rahmen einer Webanwendung an den aufrufenden Client der Webseite übergeben werden müssen. 

Die Hypercell *hcf.web.Container.Autoloader* des Hypercell-Frameworks stellt eine Konfiguration bereit, über welche Client-Assemblies durch angabe ihres HCFQN über den *hcf.web.Container* automatisch geladen werden. 

#### client.js

| Attachment | Executable | Placeholders | Sections |
|:----------:|:----------:|:------------:|:---------:|
| Nein 	    | Nein       | Nein         | Nein 	 |

Hierbei handelt es sich um Javascript, welches im Browser des Clients ausgeführt werden soll. Im Kompiliervorgang dieser Baugruppe wird das Javascript minimiert und die Kommentare werden entfernt. 

Client.js Assemblies fügen einer Hypercell die statische Methode `script` hinzu, über welche sich das mittels [JShrink](https://github.com/tedious/JShrink) minimierte Javascript abrufen lässt.

#### client.css

| Attachment | Executable | Placeholders | Sections |
|:----------:|:----------:|:------------:|:---------:|
| Ja 	    | Nein       | Nein         | Nein 	 |

Der Inhalt dieser Baugruppe ist ein *Cascading Stylesheet* welches vom Browser für das Design einer Webseite benötigt wird. Dieser Quelltyp wird während des Kompiliervorgangs weder minimiert noch werden die Kommentare entfernt. Dieser Assembly-Typ lässt sich dafür zur Laufzeit überschreiben. Um ein minimiertes sowie kommentarfreies Cascading Stylesheet an den Client zu übergeben, muss der Quelltyp *scss* verwendet werden.

Client.css Assemblies fügen einer Hypercell die statische Methode `style` hinzu, über welche sich das Stylesheet abrufen lässt. Übergibt man dieser Methode `true` als Parameter, wird anstelle des CSS-Strings [ein Array anhand des CSS gebildet](https://www.phpclasses.org/package/1289-PHP-CSS-parser-class.html) und dieses zurück gegeben.

#### client.scss

| Attachment | Executable | Placeholders | Sections |
|:----------:|:----------:|:------------:|:---------:|
| Nein 	    | Nein       | Nein         | Nein 	 |

Der Inhalt dieser Baugruppe ist ein *Cascasing Stylesheet* mit [SCSS](https://de.wikipedia.org/wiki/Sass_(Stylesheet-Sprache)#SCSS-Syntax) Unterstützung. Der Inhalt der Datei wird während des Hypercell Kompiliervorgangs mit dem [SCSSPHP Compiler von Leafo](http://leafo.github.io/scssphp/) Übersetzt.

Client.scss Assemblies fügen der Hypercell die statische Methode `style` hinzu, über welche sich das kompilierte Stylesheet abrufen lässt. Da der selbe Methodenname vom Assembly-Type *client.css* hinzugefügt wird, können diese nicht in der selben Hypercell verwendet werden. Übergibt man dieser Methode `true` als Parameter, wird anstelle des CSS-Strings [ein Array anhand des CSS gebildet](https://www.phpclasses.org/package/1289-PHP-CSS-parser-class.html) und dieses zurück gegeben. 

Wird innerhalb der client.scss Assembly die Anweisung `@import` verwendet, bezieht sich das Import-Verzeichnis immer auf das Verzeichnis der Komponente.

### config

| Attachment | Executable | Placeholders | Sections |
|:----------:|:----------:|:------------:|:---------:|
| Ja 	    | Nein       | Nein         | Nein 	 |

Config Assemblies sind statische Konfigurationen, die über eine Hypercell abgerufen werden können. Diese Baugruppen fügen der Komponente jeweils eine statische `config` Methode hinzu, welche beim Aufruf ein Objekt mit der geparsten Konfiguration zurückgibt. Das Objekt dieser Konfiguration wird in der statischen Eigenschaft `$config` gespeichert. Pro Komponente kann immer nur ein config Quelltyp verwendet werden. Config Assemblies lassen sich zur Laufzeit im Rahmen von *surfacing* überschreiben. Dadurch lassen sich für die Webanwendung systemabhängige Konfigurationen (*Entwicklungssystem*, *Testsystem*, *Produktivsystem*) abbilden.

#### config.ini

Der Inhalt dieser Assembly folgt der Syntax einer [Initialisierungsdatei](https://de.wikipedia.org/wiki/Initialisierungsdatei). Die Umwandlung in ein Objekt geschieht anhand dem [IniParser von Austin Hyde](https://github.com/austinhyde/IniParser).

#### config.json

Config.json Assemblies enthalten einen JSON-String welcher als Konfigurationsobjekt dient. Die Umwandlung in ein Objekt geschieht anhand der in PHP enthaltenen [JSON-Funktionen](http://php.net/manual/de/ref.json.php).

### constant

| Attachment | Executable | Placeholders | Sections |
|:----------:|:----------:|:------------:|:---------:|
| Nein 	    | Nein       | Nein         | Nein 	 |

Mit der Constant Assembly lassen sich an einer Hypercell Konstanten definieren. Der Inhalt ist ein simples Key-Value Format, bei dem eine Zeile einer Konstante entspricht. Das erste Leerzeichen in jeder Zeile trennt den Namen der Konstante durch ihren Wert

	MY_CONSTANT_VALUE_1 1001
	MY_CONSTANT_VALUE_2 This is a string.



Die hinzugefügten Konstanten können anschließend über den HCFQN der Komponente erreicht werden.

	\rootNamespace\package\MyCell::MY_CONSTANT_VALUE
	
Jeder Hypercell wird während des Kompilierungsvorgangs standardmäßig eine `HCFQN` sowie `NAME` Konstante hinzugefügt. Dabei steht `HCFQN` für den absoluten Namen der Hypercell und `NAME` lediglich für den Name der Klasse selbst. Diese beiden Konstanten können deshalb nicht in einer Constant-Assembly verwendet werden.


### controller

Ein Controller enthält die restliche Logik einer Komponente, welche nicht über die anderen Assemblies abgebildet werden kann.

#### controller.php

| Attachment | Executable | Placeholders | Sections |
|:----------:|:----------:|:------------:|:---------:|
| Nein 	    | Ja         | Nein         | Nein 	 |

Diese Baugruppe wird anhand eines [Traits](http://php.net/manual/de/language.oop5.traits.php) namens *Controller* abgebildet und über das *Executable Offset* mit der Komponente verbunden. Die Schlüsselwörter `$this` und `self::` beziehen sich innerhalb des Controllers auf die Instanz der jeweiligen Komponente. PHP unterbindet die Verwendung der `__construct` Methode innerhalb von Traits. Aus diesem Grund muss innerhalb des Controller-Traits die Methode `onConstruct` verwendet werden, welche als Konstruktor der Hypercell aufgerufen wird.

	<?php
	trait Controller
	{
		public function onConstruct()
		{
			// Konstruktor
		}
		
		...
	}
	?>
	
### Internal

Diese Assembly wird vom hcdk erzeugt, sobald eine Hypercell erstmalig kompiliert wurde. Der Inhalt der Datei sollte nicht manuell geändert werden, da sie Informationen für das Kompilieren einer Hypercell enthält.

Die erste Zeile der Datei enthält die Build-Nummer der Komponente sowie das Datum, wann sie kompiliert wurde. In der zweiten Zeile steht ein Hash, welcher anhand den Assemblies dieser Hypercell zum Kompilierzeitpunkt gebildet wurde. Wird nun ein Build-Vorgang angestoßen, wird anhand dieses Hashes überprüft ob sich der Inhalt dieser Hypercell verändert hat. Ist er unverändert, so wird die Komponente nicht erneut kompiliert.

	18.05.25#310
	5fe5d3ec2f17e353ebd2206f2ee38b76

### log

| Attachment | Executable | Placeholders | Sections |
|:----------:|:----------:|:------------:|:---------:|
| Ja 	    | Nein       | Nein         | Nein 	 |

Log-Assemblies verwenden Apaches [log4php Framework](https://logging.apache.org/log4php/). Der Inhalt jeder Assembly ist eine log4php Konfiguration, welche zur Laufzeit überschrieben werden kann. Diese Baugruppe fügt einer Hypercell die statische Methode `log` hinzu. Beim Aufruf dieser Methode wird eine [Logger-Instanz](https://logging.apache.org/log4php/docs/loggers.html) anhand der Konfiguration erzeugt. Dabei kann der Methode ein String übergeben werden, welcher den Namen des zu erzeugenden Loggers enthält. Wird kein Name angegeben, wird eine Instanz des Root-Loggers erzeugt.

	\rootNamespace\package\MyLoggingService::log('foo');

#### log.xml

Dieser Quelltyp enthält eine [XML Konfiguration](https://logging.apache.org/log4php/docs/configuration.html#XML) für log4php.

#### log.properties

Dieser Quelltyp enthält eine [Properties Konfiguration](https://logging.apache.org/log4php/docs/configuration.html#INI) für log4php.

### output

Output Assemblies legen fest, wie sich eine Hypercell-Instanz als String repräsentiert. Dazu wird die [magische Methode](http://php.net/manual/de/language.oop5.magic.php) `__toString` sowie der Alias `toString` an die jeweilige Komponente hinzugefügt.

#### output.raw

| Attachment | Executable | Placeholders | Sections |
|:----------:|:----------:|:------------:|:---------:|
| Nein 	    | Nein       | Nein         | Nein 	 |

Der Inhalt dieses Quelltyps ist an keinen Typ gebunden. Weiter werden enthaltene Platzhalter nicht aufgelöst.

Somit wird anhand folgendem Inhalt 

	I'm just a String.
	
die `__toString` Methode erstellt. Wird die Hypercell nun in irgendeiner Form als String verwendet, wird der Text `I'm just a String.` als Repräsentation der Instanz zurückgegeben.

#### output.text

| Attachment | Executable | Placeholders | Sections |
|:----------:|:----------:|:------------:|:---------:|
| Nein 	    | Nein       | Ja         | Nein 	 |

Output.text ist an keinen Typ gebunden. Anders als *output.raw* Assemblies können diese jedoch Platzhalter enthalten, welche zum Kompilierungszeitpunkt aufgelöst und beim Aufruf der `__toString` Methode ersetzt werden.

Mithilfe von Platzhaltern lassen sich dynamischere Ausgaben erstellen:
	
	You've got {{property:message_count}} new Messages.

Hierbei gibt die `__toString` Methode `You've got 4 new Messages.` zurück. Die enthaltenen Zahl entspricht dem Wert der Komponenten-Eigenschaften `message_count`, wie sie zum Zeitpunkt des Aufrufes dort hinterlegt war.


#### output.xml

| Attachment | Executable | Placeholders | Sections |
|:----------:|:----------:|:------------:|:---------:|
| Nein 	    | Nein       | Ja         | Nein 	 |

Im Rahmen einer Webanwendung spielt XML (meist als HTML) eine wichtige Rolle. Deshalb werden output.xml Assemblies mithilfe von PHPs [SimpleXML-Erweiterung](http://php.net/manual/de/intro.simplexml.php) zum Kompilierungszeitpunkt geparsed. Dies stellt zum einen sicher, dass das zu generierende XML valide ist, zum anderen können auf diesem Wege spezielle Prozessor-Elemente eingesetzt werden, die die Arbeit mit output.xml vereinfachen. Eine output Baugruppe vom Quelltyp XML sieht wie folgt aus 

	<div class="element-class">
		<span id="span-id">{{method:renderContent}}</span>
	</div>

Hierbei ist das `<?xml ...?>` Element am Anfang nicht zwingend notwending, da es zum Verarbeitungszeitpunkt automatisch hinzugefügt wird. Ein XML-Output darf immer nur mit einem Root-Element beginnen.

##### Platzhalter

Im Falle von output.xml Assemblies gilt es zu beachten, dass Platzhalter erst nach dem Verarbeiten des XMLs aufgelöst werden. Das bedeutet, dass Platzhalter vom XML-Parser als regulärer Text gesehen werden, welcher nur innerhalb von Elementen oder Attributen vorkommen darf. Folgendes XML würde somit zum Kompilierungszeitpunkt einen Fehler verursachen, da sowohl `{` als auch `}` keine gültigen Zeichen für Element- sowie Attribut-Namen sind.
	
	<{{property:element_name}}>
		<div {{property:attribute_name}}="attribute-value"/>
	</{{property:element_name}}>

Will man dennoch einen XML-String auf diesem Wege erzeugen, bietet sich die template.text Assembly oder die Verwendung von [CDATA-Elementen](https://de.wikipedia.org/wiki/CDATA) an.

##### Prozessor-Elemente

Prozessor-Elemente unterscheiden sich in ihrem Aussehen nicht von anderen XML-Elementen innerhalb der Assembly. Ausschlaggebend ist hierbei der verwendete Element-Name selbst. Dabei wird in den Basis String `hcdk.data.xml.Fragment.[ELEMENT-NAME]Fragment` der aktuell zu verarbeitende Element-Name eingefügt. Dies ist das HCFQN-Muster, nach welchem die Prozessor-Komponenten innerhalb des hcdk-Cellspaces gespeichert sind. Wird nun z.B. das Element `<condition.if>...</condition.if>` verarbeitet, ergibt sich hierfür folgender HCFQN: `hcdk.data.xml.Fragment.condition.IfFragment`. Existiert unter dieser HCFQN eine Hypercell, wird diese zur Verarbeitung des Elements verwendet. Existiert keine Komponente, wird das Element so übernommen wie es in der Baugruppe geschrieben steht - dies übernimmt der XML-Prozessor `hcdk.data.xml.Fragment` von welchem sich die anderen Prozessoren ableiten.

Unter dem HCFQN `hcdk.data.xml.Fragment` existieren folgende Komponenten (= Prozessoren)

##### `<dummy.text>`

Generiert anhand der im Attribut *length* angegebenen Länge einen Lorem-Ipsum Platzhalter-Text.

	<dummy.text length="100"/>


##### `<dummy.container>`

Das Element selbst wird nicht übernommen, lediglich sein Inhalt. Dies ist nützlich, wenn ein Template kein einzelnes Wurzel-Element verwendet, was von PHPs XML-Parser sowie den XML-Standards erwartet wird. Außerdem kann dieses Element nützlich sein, wenn man Text zwischen Elemente anzeigen will, ohne den Text in ein zusätzliches Element zu verschieben. Grund dafür ist die Art, wie der XML-Parser arbeitet. Er kennt die Position des Textes zum Zeitpunkt der Verarbeitung nicht und schneidet diesen ab, sofern sich noch Elemente innerhalb dieses Knoten befinden.

	<dummy.container>
		<dummy.container>Hello, </dummy.container>
		<b>{{property:name}}</b>
		<dummy.container>!</dummy.container>
	</dummy.container>

##### `<loop.foreach>`

Iteriert über eine im Attribut *var* angegebene Komponenteneigenschaft vom Typ Array. Über die Attribute *key* und *value* lassen sich Namen angeben, die den jeweiligen Schlüssel bzw. Wert des aktuellen Array-Indexes als Locale innerhalb des Elements bereitstellen. Das Attribut *call* nimmt einen Methodennamen entgegen, welcher vor jedem Iterationsschritt mit dem aktuellen Schlüssel-Wert Paar aufgerufen wird.

	<loop.foreach var="{{property:my_prop}}" key="my_local_key" value="my_local_value" call="myProcessorMethod">
		<b>{{local:my_local_key}}: </b><i>{{local:my_local_value}}</i>
	</loop.foreach>

##### `<condition.if>` / `<condition.else>`

Nur wenn die Bedingung erfüllt wird, wird der Inhalt des Fragments dem Template-String hinzugefügt. Die Operatoren in form von Attributen haben folgende Bedeutung

| Attribut | Operator |
|:--------:|:---------|
| `is="var"`	| `== var` |
| `is-gt="var"` | `> var` |
| `is-lt="var"` | `< var` |
| `is-gte="var"` | `>= var` |
| `is-lte="var"` | `<= var` |


	<condition.if value="{{arg:0}}" is-gt="{{property:max}}">
		<b>Too high</b>
	</condition.if>
	<condition.else value="{{arg:0}}" is-lt="{{property:min}}>
		<b>Too low</b>
	</condition.else>
	<condition.else>
		<i>ok</i>
	</condition.else>
	

##### `<condition.switch>` / `<condition.case>`

Case-Elemente dürfen nur auf oberster Ebene innerhalb eines Switch-Elements vorkommen. Nur wenn das Attribut *value* des Case-Elements mit Wert des Switch-Elements übereinstimmt, wird das darin enthaltene Markup dem Template-String hinzugefügt. Wird ein Case-Element ohne Value-Attribut angegeben, entspricht es dem Default-Case. 

	<condition.switch value="{{arg:0}}">
		<condition.case value="ERROR>
			<b>Error</b>
		</condition.case>
		<condition.case value="OK">
			<i>OK</i>
		</condition.case>
		<condition.case>
			<u>What</u>
		</condition.case>
	</condition.switch>

##### `<embed.data>`

Mithilfe dieses Elements lassen sich Schlüssel-Wert Paare eines Arrays in form von [HTML5-Data-Attributen](https://developer.mozilla.org/en-US/docs/Learn/HTML/Howto/Use_data_attributes) auf ein XML-Element übertragen. Das Attribut `as` gibt den Namen des Elements an und `var` referenziert ein Array. Die restlichen Attribute werden von dem Element übernommen.

	<embed.data as="div" var="{{property:my_prop}}">
		...
	</embed.data>


### template

Anhand von Templates lassen sich Methoden generieren, die Strings eines bestimmten (Quell-)Typs zum Aufrufzeitpunkt erzeugen. Eine Template-Assembly kann beliebig viele Template-Methoden enthalten. Jede Template-Methode wird anhand einer Section generiert. Die einzelnen Quelltypen verhalten sich wie die der output Assembly, nur dass Templates zusätzlich Sections unterstützen und somit nicht an die `__toString` Methode gebunden sind.

#### template.raw

| Attachment | Executable | Placeholders | Sections |
|:----------:|:----------:|:------------:|:---------:|
| Nein 	    | Nein       | Nein         | Ja 	 |

Der Inhalt dieses Quelltyps ist an keinen Typ gebunden. Weiter werden enthaltene Platzhalter nicht aufgelöst.

Somit wird anhand folgendem Template 

	#+myRawTemplate:
	I'm just a String.
	
eine reguläre, öffentliche Methode erstellt, die den String `I'm just a String.` zurück gibt.

#### template.text

| Attachment | Executable | Placeholders | Sections |
|:----------:|:----------:|:------------:|:---------:|
| Nein 	    | Nein       | Ja         | Ja 	 |

Text-Templates sind an keinen Typ gebunden. Anders als *template.raw* Templates können diese jedoch Platzhalter enthalten, welche zum Kompilierungszeitpunkt aufgelöst und beim Aufruf der Template-Methode ersetzt werden.

Mithilfe von Platzhaltern lassen sich dynamischere Templates erstellen und miteinander verbinden:
	
	#+messageText:
	You've got {{method:messageCount}} Messages.

	#-messageCount:
	{{property:unread_message_count}} unread and {{property:new_message_count}} new

Dies erstellt die zwei Methoden `messageText` und `messageCount`. Ruft man die öffentliche Methode `messageText` auf, wird der String `You've got 4 unread and 2 new Messages.` zurückgegeben. Die enthaltenen Zahlen entsprechen den Werten der Komponenten-Eigenschaften `unread_message_count` bzw. `new_message_count`, wie sie zum Zeitpunkt des Aufrufes dort hinterlegt waren.

#### template.sql

| Attachment | Executable | Placeholders | Sections  |
|:----------:|:----------:|:------------:|:---------:|
| Nein 	    | Nein       | Ja           | Ja 	 	  |

Template.sql Assemblies sind im Grunde ein Alias für template.text Assemblies. Der Quelltyp *SQL* hat hier einen symbolischen Charakter, welchem dem Entwickler zeigt, dass diese Komponente SQL Queries verwendet/bereitstellt. Außerdem wird durch den Quelltyp SQL automatisch das Syntax-Highlightning für SQL aktiviert.

	@+selectAllCustomers:
	SELECT * FROM {{property:config.table.customer_table}};

#### template.xml

| Attachment | Executable | Placeholders | Sections |
|:----------:|:----------:|:------------:|:---------:|
| Nein 	    | Nein       | Ja           | Ja 	 |

Der Inhalt einer template.xml Baugruppe wird wie die output.xml Assemblies zum Kompilierungszeitpunkt geparsed. Somit können hier ebenfalls Prozessor-Elemente verwendet werden, wie sie innerhalb des output.xml Abschnitts erklärt werden.
	
	#-renderList:
	<ul>
		<loop.foreach var="{{property:content_items}}" value="current_item">
			<li>{{local:current_item}}</li>
		</loop.foreach>
	</ul>
	
	#+render:
	<div class="element-class">
    	<span id="span-id">{{method:renderList}}</span>
	</div>

## Surfacing

Mittels surfacing werden Cellspaces über ein Dokument (die Surface) eingebunden und innerhalb diesem verwendet. Als Dokument kann hierfür ein beliebiges PHP-Skript dienen, welches das Hypercell-Framework (*hcf*) lädt. Das hcf stellt hierfür innerhalb seines Cellspace-Verzeichnisses eine Datei bereit, welche am Anfang der Surface eingebunden werden muss.
	
	<?php
		require_once '/path/to/your/cellspaces/hcf.cs/hcf.php';
		...

Beim laden dieses Skripts wird innerhalb des selben Verzeichnisses eine Datei namens *surface.ini* benötigt.

### surface.ini

Anhand der Datei *surface.ini* wird das Hypercell-Framework initialisiert. Ihr Inhalt folgt der Syntax einer [Initialisierungsdatei](https://de.wikipedia.org/wiki/Initialisierungsdatei).

#### Verfügbare Optionen

Für die Initialisierung einer Surface können folgende Werte innerhalb der surface.ini angegeben werden. 

	include = ['../cellspaces/App.cs']

Ein Array welches Pfade zu den Cellspace-Verzeichnissen enthält, die für diese Surface geladen werden sollen. Hierbei muss der Cellspace des Hypercell-Frameworks nicht angegeben werden, da dieser über das einbinden der *hcf.php* geladen wird.

	libs = ['../3rd-party']

Ein Array welches Verzeichnisse enthält, die reguläre PHP-Klassen beinhaltet die zum Initialisierungszeitpunkt geladen werden sollen. 

	shared = 'shared'
	
Ein Verzeichnis welches über den Browser erreichbar ist. Die Angabe muss relativ zum Document-Root der Webanwendung sein. Dieses Verzeichnis wird von Hypercells wie hcf.web.Container.Autoloader verwendet um 3rd-Party Client-Libraries zu laden. Der hier konfigurierte Wert wird über die globale Konstante `HCF_SHARED` verfügbar gemacht.

	attachments = '../attachments'
	
Ein Verzeichnis welches die zu überschreibenden Hypercell-Attachments beinhaltet. Der hier konfigurierte Wert wird über die Konstante `HCF_ATT_OVERRIDE` verfügbar gemacht.

	strict = true
	
Ein Boolean welcher im Falle von `true` [PHPs error_reporting Level](http://php.net/manual/en/function.error-reporting.php#refsect1-function.error-reporting-changelog) auf `E_ALL` setzt. Dieser Wert wird über die globale Konstante `HCF_STRICT` verfügbar gemacht.

	display-errors = true

Ein Boolean welcher im Falle von `true` alle auftretende Fehler an den Standard-Output weiterleitet und diese somit anzeigt. Auf Produktiv-Umgebungen sollte dieser Wert auf `false` gesetzt sein.

	http-hooks = [GET, POST]
	
Ein Array welches [HTTP-Methoden](https://de.wikipedia.org/wiki/Hypertext_Transfer_Protocol#HTTP-Anfragemethoden) enthält. Wird eine Surface mit einer in der Liste enthaltenen Methode aufgerufen, wird die Anfrage an die Hypercell hcf.web.Router delegiert und das restliche Surface-Skript übersprungen.

#### Konfigurationsmöglichkeiten 

Es gibt zwei Möglichkeiten, Surfaces für die Initialisierung anzusprechen:

##### 1. Allgemeine Konfiguration

In diesem Fall wird eine einmalige Konfiguration verwendet, welche für alle Dateien innerhalb dieses Verzeichnisses gelten, die das Hypercell-Framework laden. Der Inhalt der surface.ini wird hierfür einmalig direkt in die Root-Section der Initialisierungsdatei geschrieben.

	include = ['../cellspaces/App.cs']
	libs = ['../3rd-party']
	shared = 'shared'
	attachments = '../attachments'
	strict = true
	display-errors = true
	http-hooks = [GET,POST]

##### 2. Spezifische Konfiguration

Hierbei wird pro Dokument eine Ini-Section verwendet, welche eine eigene Konfiguration enthält. Der Name der Ini-Section ist der Name des Dokuments, ohne dessen Dateiendung (da diese immer PHP ist). Sollen also z.B. die Surfaces *app.php* und *api.php* unterschiedlich konfiguriert werden, so wird die Konfiguration wie folgt aufgebaut
	
	[app]
	include = ['../cellspaces/App.cs']
	libs = ['../3rd-party']
	shared = 'shared'
	attachments = '../app-attachments'
	strict = true
	display-errors = true
	http-hooks = [POST]
	
	[api]
	include = ['../cellspaces/Api.cs']
	libs = ['../3rd-party']
	shared = null
	attachments = '../api-attachments'
	strict = true
	display-errors = true
	http-hooks = [GET,POST]


### Attachment-Assemblies überschreiben

In der *surface.ini* kann ein Verzeichnis angegeben werden, innerhalb welchem Attachment-Assemblies von einzelnen Hypercells zur Laufzeit überschrieben werden können. Dabei überschreibt eine Datei jeweils ein Attachment einer Komponente. Der Dateiname gibt an, welche Hypercell sowie Assembly überschrieben werden soll. Der Dateiname folgt folgendem Muster

	HCFQN@rollenname.quelltyp

will man z.B. die config.ini Assembly der Komponente hcf.web.Router überschreiben, so muss die Datei folgenden Namen tragen
	
	hcf.web.Router@config.ini
	
Ist innerhalb des Verzeichnisses keine Datei für ein Attachment zu finden, so wird das Attachment am Ende der jeweiligen Hypercell-Quelldatei verwendet.

### HTTP-Hooks

Wird eine Surface per HTTP-Request aufgerufen, geschieht dies anhand einer [HTTP-Methode](https://de.wikipedia.org/wiki/Hypertext_Transfer_Protocol#HTTP-Anfragemethoden). Ist für die aufgerufene Surface die verwendete HTTP-Methode im konfigurierten HTTP-Hook Array der surface.ini enthalten, wird dieser Aufruf zum Initialisierungszeitpunkt an die Hypercell hcf.web.Router delegiert. Nachdem der hcf.web.Router die Anfrage verarbeitet hat, wird dessen Ausgabe als Response auf die HTTP-Request gesendet und die Ausführung des Skriptes beendet. Alles was in der betroffenen Surface nach dem Einbinden der *hcf.php* geschieht, wird somit übersprungen. 

Wird eine Surface mit dem URL-Parameter `!` aufgerufen, wird der HTTP-Hook erzwungen - unabhängig davon, ob die dafür verwendete Methode im HTTP-Hook Array steht oder nicht. Diese Variante wird von der hcf.web.Bridge Hypercell als *Loopback* benötigt um eine einfache Client-Server Kommunikation zu ermöglichen.