Created by visualjeff (a.k.a jgilber) to facilitate the management of Haraka-CouchDB and the cheezyMailClient.

Documents:
==========
README.md - This document.  Good starting point
How_To_Update.txt - Explains how to update the current docker containers with an updated image
.environment_info - Hidden file is where add new environments to be executed by the scripts.

Scripts: 
========
addDesignDocument.sh - Used to import mailBox.json view into each database (a.k.a mailbox).
backup_data.sh - Exports server data for all environments as a backup.
restore_data.sh - Imports server data for all environments from most recent backup.
finishUpdate.sh	- After a server update this script is used to re-import the data.
startup_clients.sh - Starts up the cheezymailclient for all environments. 
startup_servers.sh Starts up the haraka-couchdb containers for all environments.
update_client_only.sh -	Updates	the cheezymailclient containers	with a new image.
update_server_only.sh -	Updates	the haraka-couchdb containers with a new image.

Data:
=====
mailBox.json - A couchdb design	document (a.k.a., view).  Don't touch.

Directories:
============
couchdb-dump - Directory containing import and export scripts. 	Don't touch.
couchdb-dump/data - Where exported data goes.  Don't touch.
couchdb-dump/backup - Where backup data goes.  Don't touch.


To debug a script run this commend before you execute a script:
===============================================================
set -x

==> WARNINGS: <==
=================
DO NOT KILL THE SERVER CONTAINERS WITHOUT FIRST EXCUTING A BACKUP!!!  OTHERWISE YOU WILL LOSE TEST DATA.

