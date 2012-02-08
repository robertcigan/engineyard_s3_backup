EngineYard S3 backup
====================

Why?
----
When something happens to EY or you remove the environment/account you loose all DB backups so why not regulary copy those backups somewhere else, just to be sure.

How?
----
`ssh deploy@YOUR_ENV_IP_OR_HOSTNAME`

run following commands to get the source and create a config file

`cd ~`

`git clone https://github.com/robertcigan/engineyard_s3_backup`

`cd engineyard_s3_backup/`

`cp s3backup.yaml.example s3backup.yaml`

Set you source and target S3 credentials by editing s3backup.yaml as following:

Source credentials for EY S3 account that stores you DB backups can be found in /etc/chef/dna.json. 
You can get those easily by running ie.

`sudo cat /etc/chef/dna.json | grep aws_secret_key`

`sudo cat /etc/chef/dna.json | grep aws_secret_id`

Source bucket pattern is just how EY names their buckets to store your backups. RIght now it always contains string ey-backup

Set your target S3 credentials - files will be copied there
Target bucket is a name of your bucket to store all the backups. It will be created automatically so no need to created that ahead. 
No files will be overwritten (the script does no delete/update) so it should be safe to set it to already existing bucket with some objects in it.

You need to install 'aws-sdk' gem

`sudo gem install aws-sdk`

Run the command

`ruby s3backup.rb`

or put it into the cron definition of your EngineYard environment via their console (note that the output is being put into the s3backup.log for futher review if needed)

`cd ~/engineyard_s3_backup && ruby s3backup.rb >> ~/s3backup.log`

Specials
--------

Tested & working in 1.9.2

Does regular addition of new files that appeared in ey-backup buckets. 

Does NO delete/update of files. 

Copies only new files that are automatically added by EY scripts.