import click
import subprocess
import os

@click.group()
@click.option("--implementation", "-I", help='Option to specify the implementation config to be installed. Default value is default. If this options is used, implementation config folder has to be placed in /etc/bahmni-installer/deployment-artifacts with name <impelementation>_config')
@click.option("--inventory", "-i", default='local', help='Inventory file that needs to picked up from /etc/bahmni-installer')
@click.option("--sql_path", "-path", help='Option to accept the exact file path from which the db will be restored ')
@click.option("--database", "-db", help='Option to accept the specific database name')

@click.pass_context
def cli(ctx, implementation, inventory, sql_path, database):
    ctx.obj={}
    """Command line utility for Bahmni"""
    os.chdir('/opt/bahmni-installer/bahmni-playbooks')
    ctx.obj['EXTRA_VARS'] =""

    addExtraVarFile(ctx, "/etc/bahmni-installer/rpm_versions.yml")
    addExtraVarFile(ctx, "/etc/bahmni-installer/setup.yml")
    addExtraVar(ctx,"implementation_name", implementation )
    ansible_version = os.popen("ansible --version").read()
    if "ansible 2.0.1" not in ansible_version:
        subprocess.call('sudo yum install -y ansible-lint --enablerepo=epel-testing', shell=True)
    ctx.obj['INVENTORY'] = '/etc/bahmni-installer/'+inventory
    ctx.obj['ANSIBLE_COMMAND'] =  "ansible-playbook -i "+ ctx.obj['INVENTORY'] +" {0} -vvvv {1}"
    ctx.obj['SQL_PATH'] = sql_path
    ctx.obj['DATABASE'] = database

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
   click.echo(command)
   return subprocess.call(command, shell=True)


@cli.command(short_help="starts all the services required for bahmni")
@click.pass_context
def start(ctx):
   command = ctx.obj['ANSIBLE_COMMAND'].format("all.yml", ctx.obj['EXTRA_VARS']) + " -t start_bahmni"
   click.echo(command)
   subprocess.call(command, shell=True)

@cli.command(short_help="stops all the services required for bahmni")
@click.pass_context
def stop(ctx):
   command = ctx.obj['ANSIBLE_COMMAND'].format("all.yml", ctx.obj['EXTRA_VARS']) + " -t stop_bahmni"
   click.echo(command)
   subprocess.call(command, shell=True)

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
   subprocess.call(command, shell=True)

@cli.command(name="concat-configs",
 short_help="Concatenating configs from /var/www/bahmni_config/openmrs directory")
@click.pass_context
def update_config(ctx):
   command = ctx.obj['ANSIBLE_COMMAND'].format("concat-config.yml", ctx.obj['EXTRA_VARS'])
   click.echo(command)
   subprocess.call(command, shell=True)

@cli.command(name="setup-mysql-replication", short_help="sets up mysql db replication")
@click.pass_context
def setup_mysql_replication(ctx):
   command = ctx.obj['ANSIBLE_COMMAND'].format("mysql-replication.yml", ctx.obj['EXTRA_VARS'])
   click.echo(command)
   subprocess.call(command, shell=True)

@cli.command(name="setup-postgres-replication", short_help="sets up postgres db replication")
@click.pass_context
def setup_postgres_replication(ctx):
   command = ctx.obj['ANSIBLE_COMMAND'].format("postgres-replication.yml", ctx.obj['EXTRA_VARS'])
   click.echo(command)
   subprocess.call(command, shell=True)

@cli.command(name="db-backup", short_help="Take db backup in DB machine at /db-backup directory. Optionally can be copied to the local machine as well")
@click.pass_context
def db_backup(ctx):
   should_copy_to_local_machine =  click.prompt('Do you want to copy db backup to local machine in /db-backup directory? y/N', type=bool)
   if should_copy_to_local_machine:
      addExtraVar(ctx,"copy_to_local_machine", "yes" )
   command = ctx.obj['ANSIBLE_COMMAND'].format("db-backup.yml", ctx.obj['EXTRA_VARS'])
   click.echo(command)
   subprocess.call(command, shell=True)

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
    subprocess.call(command, shell=True)

