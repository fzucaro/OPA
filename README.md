OPA
===

 

Procedura per agganciarsi ad un repository remoto:

1.  Mi posiziono nella directory che contiene i file di progetto

2.  Eseguo i seguenti comandi

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo "# OPA" >> README.md
git init
git add README.md
git commit -m "first commit"
git remote add origin https://github.com/fzucaro/OPA.git
git push -u origin master
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

 

Appunti su Git
==============

Posso bypassare area di stage mediante il comando git commit -a -m “”: in questo
modo committo tutti i file che inizialmente erano tracciati.

 
