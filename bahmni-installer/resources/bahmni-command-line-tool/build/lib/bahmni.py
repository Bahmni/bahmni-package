import click
import os
import subprocess
import sys


@click.group()
@click.option("--implementation", "-I", help='Option to specify the implementation config to be installed. Default value is default. If this options is used, implementation config folder has to be placed in /etc/bahmni-installer/deployment-artifacts with name <impelementation>_config')
@click.option("--inventory", "-i", required=True, help='Inventory file that needs to picked up from /etc/bahmni-installer')
@click.option("--sql_path", "-path", help='Option to accept the exact file path from which the db will be restored ')
@click.option("--database", "-db", help='Option to accept the specific database name')
@click.option("--verbose", "-v", is_flag=True, help='verbose operation')
@click.option("--implementation_play","-impl-play",help='Path of implementation specific ansible play')
@click.option("--migrate", "-m", help='Give a comma seperated list of modules to run migrations for. It has to be used with run_migrations command.Ex: bahmni --migrate erp,elis,mrs run_migrations')
@click.option("--only", "-o", help='Install only specified components. Possible values can be bahmni-emr, bahmni-reports, bahmni-lab, bahmni-erp, dcm4chee, pacs-integration, bahmni-event-log-service')
@click.option("--skip", "-s", help='Skip installation of specified components. Possible values can be bahmni-emr, bahmni-reports, bahmni-lab, bahmni-erp, dcm4chee, pacs-integration, bahmni-event-log-service')
@click.option("--ansible_rpm_url", "-aru", default='https://dl.bintray.com/bahmni/rpm/ansible-2.2.0.0-3.el6.noarch.rpm',
              help='Specify URL of the Ansible rpm')
@click.option("--pgbackrest","-pgb",help='Backup and restore via pgbackrest')

@click.pass_context
def cli(ctx, implementation, inventory, sql_path, database, verbose, implementation_play, migrate, only, skip,
        ansible_rpm_url,pgbackrest):
    ctx.obj={}
    """Command line utility for Bahmni"""
    os.chdir('/opt/bahmni-installer/bahmni-playbooks')
    ctx.obj['EXTRA_VARS'] =""

    addExtraVarFile(ctx, "/etc/bahmni-installer/rpm_versions.yml")
    addExtraVarFile(ctx, "/etc/bahmni-installer/setup.yml")
    addExtraVar(ctx,"implementation_name", implementation )

    installAnsible(ansible_rpm_url)

    verbosity="-vvvv" if verbose else "-vv"
    ctx.obj['INVENTORY'] = '/etc/bahmni-installer/'+inventory
    ctx.obj['IMPLEMENTATION_PLAY'] = implementation_play
    ctx.obj['ANSIBLE_COMMAND'] =  "ansible-playbook -i "+ ctx.obj['INVENTORY'] +" {0} " +verbosity+ " {1}"
    ctx.obj['SQL_PATH'] = sql_path
    ctx.obj['DATABASE'] = database
    ctx.obj['MIGRATE'] = migrate
    ctx.obj['PGBACKREST']="pgbackrest"+"{0}"+"{1}"
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

@cli.command(name="db-backup", short_help="Take db backup in DB machine at /db-backup directory. Optionally can be copied to the local machine as well")
@click.pass_context
def db_backup(ctx):
   should_copy_to_local_machine =  click.prompt('Do you want to copy db backup to local machine in /db-backup directory? y/N', type=bool)
   if should_copy_to_local_machine:
      addExtraVar(ctx,"copy_to_local_machine", "yes" )
   command = ctx.obj['ANSIBLE_COMMAND'].format("db-backup.yml", ctx.obj['EXTRA_VARS'])
   click.echo(command)
   subprocess.check_call(command, shell=True)

@cli.command(name="db-restore", short_help="Restore the sql dump present in the path provided. Also pass the exact file path and the database name")
@click.pass_context
def db_restore(ctx):
    if not ctx.obj['SQL_PATH']:
        click.echo("Please provide the exact file path for the restored db")
        return
    if not ctx.obj['DATABASE']:
        click.echo("Please provide the database name")
        return
    addExtraVar(ctx,"file_path", ctx.obj['SQL_PATH'] )
    addExtraVar(ctx,"db_name", ctx.obj['DATABASE'] )
    command = ctx.obj['ANSIBLE_COMMAND'].format("db-restore.yml", ctx.obj['EXTRA_VARS'])
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

@cli.command(name="pgbackrest-backup", short_help="Backs up postgres db via pgbackrest,Enter --help for help")
@click.option("--type_of_backup", "-b",required=True, help='Enter type of backup where: \nincr:creates incremental backup \nfull:creates fullbackup \ncronincr:creates periodic-incremental \ncronfull:creates periodic-full')
@click.pass_context
def pgbackrest_backup(ctx,type_of_backup):
   addExtraVar(ctx,"type_of_backup", type_of_backup )
   command = ctx.obj['ANSIBLE_COMMAND'].format("pgbackrest-backup.yml", ctx.obj['EXTRA_VARS'])
   click.echo(command)
   subprocess.check_call(command, shell=True)

@cli.command(name="pgbackrest-restore", short_help="Restores postgres db via pgbackrest")
@click.option("--type_of_restore", "-r",required=True, help='Enter type of restore where: \ndelta:performs delta restore \nfull:performs full restore')
@click.pass_context
def pgbackrest_restore(ctx,type_of_restore):
   addExtraVar(ctx,"type_of_restore", type_of_restore )
   command = ctx.obj['ANSIBLE_COMMAND'].format("pgbackrest-restore.yml", ctx.obj['EXTRA_VARS'])
   click.echo(command)
   subprocess.check_call(command, shell=True)
