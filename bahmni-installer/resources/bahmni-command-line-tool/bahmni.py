import click
import os
import subprocess
import sys


@click.group()
@click.option("--implementation", "-I", help='Option to specify the implementation config to be installed. Default value is default. If this options is used, implementation config folder has to be placed in /etc/bahmni-installer/deployment-artifacts with name <impelementation>_config')
@click.option("--inventory", "-i", help='Inventory file that needs to picked up from /etc/bahmni-installer')
@click.option("--verbose", "-v", is_flag=True, help='verbose operation')
@click.option("--implementation_play","-impl-play",help='Path of implementation specific ansible play')
@click.option("--migrate", "-m", help='Give a comma seperated list of modules to run migrations for. It has to be used with run_migrations command.Ex: bahmni --migrate erp,elis,mrs run_migrations')
@click.option("--only", "-o", help='Install only specified components. Possible values can be bahmni-emr, bahmni-reports, bahmni-lab, bahmni-erp, dcm4chee, pacs-integration, bahmni-event-log-service')
@click.option("--skip", "-s", help='Skip installation of specified components. Possible values can be bahmni-emr, bahmni-reports, bahmni-lab, bahmni-erp, dcm4chee, pacs-integration, bahmni-event-log-service')
@click.option("--ansible_rpm_url", "-aru", default='https://repo.mybahmni.org/releases/ansible-2.4.6.0-1.el7.ans.noarch.rpm',
              help='Specify URL of the Ansible rpm')


@click.pass_context
def cli(ctx, implementation, inventory,verbose, implementation_play, migrate, only, skip,
        ansible_rpm_url):
    ctx.obj={}
    """Command line utility for Bahmni"""
    os.chdir('/opt/bahmni-installer/bahmni-playbooks')
    ctx.obj['EXTRA_VARS'] =""

    addExtraVarFile(ctx, "/etc/bahmni-installer/rpm_versions.yml")
    addExtraVarFile(ctx, "/etc/bahmni-backrest.conf")
    addExtraVarFile(ctx, "/etc/bahmni-installer/setup.yml")
    addExtraVar(ctx,"implementation_name", implementation )

    installAnsible(ansible_rpm_url)

    verbosity="-vvvv" if verbose else "-vv"

    if inventory is None:
        inventory = getInventoryFileName()

    ctx.obj['INVENTORY'] = '/etc/bahmni-installer/'+inventory
    ctx.obj['INVENTORY_NAME'] = inventory
    ctx.obj['IMPLEMENTATION_PLAY'] = implementation_play
    ctx.obj['ANSIBLE_COMMAND'] =  "ansible-playbook -i "+ ctx.obj['INVENTORY'] +" {0} " +verbosity+ " {1}"
    ctx.obj['MIGRATE'] = migrate
    ctx.obj['ONLY'] = only
    ctx.obj['SKIP'] = skip
    if  only!=None and skip!=None :
        print ("Both \"Only and Skip\" can not be used on same time")
        sys.exit()

def installAnsible(ansible_rpm_url):
    ansible_rpm_package = ansible_rpm_url.split('/')[-1].replace('.rpm', '')
    installed_ansible_package = subprocess.Popen('rpm -q ' + ansible_rpm_package,
                                             stdout=subprocess.PIPE, shell=True).communicate()[0].strip()
    if installed_ansible_package != ansible_rpm_package:
        print "Installing Ansible from " + ansible_rpm_url + "..."
        ansible_installation_process = subprocess.Popen(['sudo yum install -y ' + ansible_rpm_url],
                                                        stdout=subprocess.PIPE,
                                                        stderr=subprocess.PIPE, shell=True)
        output, err = ansible_installation_process.communicate()
        print output, err
        if ansible_installation_process.returncode != 0:
            if "does not update installed package" not in output:
                sys.exit()

def addExtraVarFile(ctx, file_path):
    if(os.path.isfile(file_path)):
      ctx.obj['EXTRA_VARS']  = ctx.obj['EXTRA_VARS'] + " --extra-vars '@"+file_path+"'"

def addExtraVar(ctx, var_name, var_value): 
    if var_value:     
      ctx.obj['EXTRA_VARS']  = ctx.obj['EXTRA_VARS'] + " --extra-vars '{0}={1}'".format(var_name, var_value)

def getInventoryFileName():
    environment = os.environ
    default_inventory = environment.get('BAHMNI_INVENTORY')
    if  default_inventory:
        return default_inventory
    else:
        print ("BAHMNI_INVENTORY is not set.\nAlternately, use bahmni -i <inventory_file_name> install")
        sys.exit()

@cli.command(short_help="Installs bahmni components on respective hosts specified in inventory file")
@click.pass_context
def install(ctx):
    command = ctx.obj['ANSIBLE_COMMAND'].format("all.yml", ctx.obj['EXTRA_VARS'])
    if ctx.obj['ONLY'] is not None:
        command = command + " -t  " + ctx.obj['ONLY']
    elif ctx.obj['SKIP'] is not None:
        command = command + " --skip-tags " + ctx.obj['SKIP']
    click.echo(command)
    return subprocess.check_call(command, shell=True)

@cli.command(name="install-impl",short_help="Installs bahmni implementation specific customizations on respective hosts specified in inventory file")
@click.pass_context
def install_implementation(ctx):
   command = ctx.obj['ANSIBLE_COMMAND'].format(ctx.obj['IMPLEMENTATION_PLAY'], ctx.obj['EXTRA_VARS'])
   click.echo(command)
   return subprocess.check_call(command, shell=True)

@cli.command(short_help="starts all the services required for bahmni")
@click.pass_context
def start(ctx):
   command = ctx.obj['ANSIBLE_COMMAND'].format("all.yml", ctx.obj['EXTRA_VARS']) + " -t start_bahmni"
   click.echo(command)
   subprocess.check_call(command, shell=True)

@cli.command(short_help="stops all the services required for bahmni")
@click.pass_context
def stop(ctx):
   command = ctx.obj['ANSIBLE_COMMAND'].format("all.yml", ctx.obj['EXTRA_VARS']) + " -t stop_bahmni"
   click.echo(command)
   subprocess.check_call(command, shell=True)

@cli.command(short_help="restart all the services required for bahmni")
@click.pass_context
def restart(ctx):
   ctx.forward(stop)
   ctx.forward(start)

@cli.command(name="update-config",
 short_help="updates the implementation config from the location /etc/bahmni-installer/deployment-artifacts")
@click.pass_context
def update_config(ctx):
   command = ctx.obj['ANSIBLE_COMMAND'].format("all.yml", ctx.obj['EXTRA_VARS']) + " -t config"
   click.echo(command)
   subprocess.check_call(command, shell=True)

@cli.command(name="concat-configs",
 short_help="Concatenating configs from /var/www/bahmni_config/openmrs directory")
@click.pass_context
def update_config(ctx):
   command = ctx.obj['ANSIBLE_COMMAND'].format("concat-config.yml", ctx.obj['EXTRA_VARS'])
   click.echo(command)
   subprocess.check_call(command, shell=True)

@cli.command(name="create-connect-artifacts", short_help="Creates artifacts for bahmni connect Initial Sync configs")
@click.pass_context
def update_config(ctx):
    command = ctx.obj['ANSIBLE_COMMAND'].format("create-connect-artifacts.yml", ctx.obj['EXTRA_VARS'])
    click.echo(command)
    subprocess.check_call(command, shell=True)

@cli.command(name="setup-mysql-replication", short_help="sets up mysql db replication")
@click.pass_context
def setup_mysql_replication(ctx):
   command = ctx.obj['ANSIBLE_COMMAND'].format("mysql-replication.yml", ctx.obj['EXTRA_VARS'])
   click.echo(command)
   subprocess.check_call(command, shell=True)

@cli.command(name="setup-postgres-replication", short_help="sets up postgres db replication")
@click.pass_context
def setup_postgres_replication(ctx):
   command = ctx.obj['ANSIBLE_COMMAND'].format("postgres-replication.yml", ctx.obj['EXTRA_VARS'])
   click.echo(command)
   subprocess.check_call(command, shell=True)

@cli.command(name="install-nagios", short_help="Installs nagios server and nagios agents.")
@click.pass_context
def install_nagios(ctx):
    command = ctx.obj['ANSIBLE_COMMAND'].format("all.yml", ctx.obj['EXTRA_VARS'])+ " -t nagios"
    click.echo(command)
    return subprocess.check_call(command, shell=True)

@cli.command(name="version", short_help="Print the Bahmni installer version")
@click.pass_context
def installer_version(ctx):
    command = "yum list installed dcm4chee bahmni-* pacs-* | awk '{print $1,$2}' | sed 1,2d"
    return subprocess.check_call(command, shell=True)

@cli.command(short_help="Execute all/selected migrations")
@click.pass_context
def run_migrations(ctx):
    ctx.obj['MIGRATE'] = ctx.obj['MIGRATE'] or "mrs,erp,elis"
    modules = ctx.obj['MIGRATE'].split(',')
    getTag = lambda moduleName: "run-migration-open"+moduleName
    allTags = ",".join(map(getTag, modules))
    command = ctx.obj['ANSIBLE_COMMAND'].format("db-migrations.yml", ctx.obj['EXTRA_VARS']) + "  -t " + allTags
    click.echo(command)
    subprocess.check_call(command, shell=True)

@cli.command(name="install-certs", short_help="Install SSL certificates using LetsEncrypt")
@click.option("--email", "-e", required=True, help='Email to register a LetsEncrypt account.')
@click.option("--domain", "-d", required=True, help='Domain name to register the certificate to.')
@click.pass_context
def install_certs(ctx, email, domain):
    extra_vars = '--extra-vars "email={0} commonName={1}"'.format(email, domain)
    command = ctx.obj['ANSIBLE_COMMAND'].format("letsencrypt.yml", extra_vars)
    click.echo(command)
    subprocess.check_call(command, shell=True)

@cli.command(name="backup", short_help="Used for taking backup of application artifact files and databases")
@click.option("--backup_type", "-bt", required=False,default='all',type=click.Choice(['file', 'db','all']), help='Backup type can be file,db,all ')
@click.option("--options", "-op", required=False, default='all',type=click.Choice(['all','openmrs', 'postgres','clinlims','openerp','pacsdb','bahmni_pacs','bahmni_reports','patient_images','document_images','uploaded-files','uploaded_results','pacs_images','reports']), help='Use this to specify options for backup type. allowed values: openmrs,patient_files i.e: openmrs in case of backup_type is db ;')
@click.option("--strategy", "-st", required=False,type=click.Choice(['incr', 'full']), help="Strategy for db backups,full for full backup  or incr for incremental backup.")
@click.option("--schedule", "-sh", required=False, help="Schedule a command")
@click.pass_context
def main_backup(ctx,backup_type,options,strategy,schedule):
   artifacts = ["patient_images", "document_images", "pacs_images", "uploaded-files", "uploaded_results", "reports"]
   addExtraVar(ctx,"backup_type", backup_type )
   addExtraVar(ctx,"options", options )
   addExtraVar(ctx,"strategy", strategy )
   command = ''
   if schedule is not None:
      cron_command = schedule+' bahmni -i'+ctx.obj['INVENTORY_NAME']+' backup -bt '+backup_type+' -op '+options
      if strategy is not None:
          cron_command = cron_command +' -st '+strategy
      click.echo(cron_command)
      subprocess.call('(crontab -l  2>/dev/null ; echo \''+cron_command+'\')| crontab - ', shell=True)
      return

   if backup_type == 'db' or backup_type == 'all' :
      if 'openmrs' in options or options == 'all':
          addExtraVar(ctx,"db","openmrs" )
          command = ctx.obj['ANSIBLE_COMMAND'].format("incr-mysqldbbackup.yml", ctx.obj['EXTRA_VARS'])
          subprocess.call(command, shell=True)
      if 'bahmni_reports' in options or options == 'all':
          addExtraVar(ctx,"db","bahmni_reports" )
          command = ctx.obj['ANSIBLE_COMMAND'].format("incr-mysqldbbackup.yml", ctx.obj['EXTRA_VARS'])
          subprocess.call(command, shell=True)
      if 'postgres' in options or 'openerp' in options or 'clinlims' in options or options == 'bahmni_pacs' or options == 'pacsdb' or options == 'all':
          command = ctx.obj['ANSIBLE_COMMAND'].format("incr-postgresdbbackup.yml", ctx.obj['EXTRA_VARS'])
          subprocess.call(command, shell=True)
      
   if backup_type == 'file' or backup_type == 'all' :
      if options in artifacts or options == 'all':
          command = ctx.obj['ANSIBLE_COMMAND'].format("backup-artifacts.yml", ctx.obj['EXTRA_VARS'])
          subprocess.check_call(command, shell=True)
      else:
          click.echo("Invalid options!!..Choose from valid options available")

@cli.command(name="restore", short_help="Used for restoring of application files and databases")
@click.option("--restore_type", "-rt", required=True,type=click.Choice(['file', 'db']), help='Restore type can be file,db')
@click.option("--options", "-op", required=True, default='all',type=click.Choice(['all', 'openmrs', 'postgres','clinlims','openerp','pacsdb','bahmni_pacs','bahmni_reports','patient_images','document_images','uploaded-files','uploaded_results','pacs_images','reports']), help='Use this to specify options for backup type. allowed values: openmrs,patient_files i.e: openmrs in case of backup_type is db ;')
@click.option("--strategy", "-st", required=False,type=click.Choice(['pitr', 'dump']), help="Strategy for db backups,pitr for point in time recovery,dump to apply dbdump")
@click.option("--restore_point", "-rp", required=False, default='', help="Restoration point where we need to do restore")
@click.pass_context
def restore(ctx,restore_type,options,strategy,restore_point):
    artifacts = ["patient_images", "document_images", "pacs_images", "uploaded-files", "uploaded_results", "reports"]
    addExtraVar(ctx,"restore_type", restore_type )
    addExtraVar(ctx,"options", options )
    addExtraVar(ctx,"restore_point", restore_point )
    command = ''
    addExtraVar(ctx,"strategy", strategy )
    if restore_type == 'db'  :
      if 'openmrs' in options :
         addExtraVar(ctx,"db", "openmrs" )
         command = ctx.obj['ANSIBLE_COMMAND'].format("incr-mysqldbrestore.yml", ctx.obj['EXTRA_VARS'])
         subprocess.call(command, shell=True)
      elif 'bahmni_reports' in options :
         addExtraVar(ctx,"db", "bahmni_reports" )         
         command = ctx.obj['ANSIBLE_COMMAND'].format("incr-mysqldbrestore.yml", ctx.obj['EXTRA_VARS'])
         subprocess.call(command, shell=True)
      elif options == 'postgres' :
           if strategy == 'pitr' :
              command = ctx.obj['ANSIBLE_COMMAND'].format("incr-postgresdbrestore.yml", ctx.obj['EXTRA_VARS'])
              subprocess.call(command, shell=True)
           else:
               click.echo("Invalid strategy!!..Choose from valid strategy available")
      elif options == 'clinlims' or options == 'openerp' or options == 'bahmni_pacs' or options == 'pacsdb':
            if strategy == 'dump':
                 command = ctx.obj['ANSIBLE_COMMAND'].format("incr-postgresdbrestore.yml", ctx.obj['EXTRA_VARS'])
                 subprocess.call(command, shell=True)
            else:
                 click.echo("Invalid strategy!!..Choose from valid strategy available")
      else:
           click.echo("Invalid options!!..Choose from valid options available")

    if restore_type == 'file'  :
      if options in artifacts or options == 'all' :
          command = ctx.obj['ANSIBLE_COMMAND'].format("restore-artifacts.yml", ctx.obj['EXTRA_VARS'])
          click.echo(command)
          subprocess.call(command, shell=True)
      else:
          click.echo("Invalid options!!..Choose from valid options available")
