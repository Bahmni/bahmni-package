import click
import subprocess
import os

@click.group()
@click.option("--implementation", "-I", help='Option to specify the implementation config to be installed. Default value is default. If this options is used, implementation config folder has to be placed in /etc/bahmni-installer/deployment-artifacts with name <impelementation>_config')
@click.option("--inventory", "-i", default='local', help='Inventory file that needs to picked up from /etc/bahmni-installer')
@click.pass_context
def cli(ctx, implementation, inventory):
    ctx.obj={}
    """Command line utility for Bahmni"""
    os.chdir('/opt/bahmni-installer/bahmni-playbooks')
    ctx.obj['EXTRA_VARS'] =""

    addExtraVarFile(ctx, "/etc/bahmni-installer/rpm_versions.yml")
    addExtraVarFile(ctx, "/etc/bahmni-installer/setup.yml")
    addExtraVar(ctx,"implementation_name", implementation )

    ctx.obj['INVENTORY'] = '/etc/bahmni-installer/'+inventory
    ctx.obj['ANSIBLE_COMMAND'] =  "ansible-playbook -i "+ ctx.obj['INVENTORY'] +" {0} -vvvv "+ ctx.obj['EXTRA_VARS']
    
def addExtraVarFile(ctx, file_path):
    if(os.path.isfile(file_path)):
      ctx.obj['EXTRA_VARS']  = ctx.obj['EXTRA_VARS'] + " --extra-vars '@"+file_path+"'"

def addExtraVar(ctx, var_name, var_value): 
    if var_value:     
      ctx.obj['EXTRA_VARS']  = ctx.obj['EXTRA_VARS'] + " --extra-vars '{0}={1}'".format(var_name, var_value)

@cli.command(short_help="Installs bahmni components on respective hosts specified in inventory file")
@click.pass_context
def install(ctx):
   command = ctx.obj['ANSIBLE_COMMAND'].format("all.yml")
   click.echo(command)
   subprocess.call(command, shell=True)


@cli.command(short_help="starts all the services required for bahmni")
@click.pass_context
def start(ctx):
   command = ctx.obj['ANSIBLE_COMMAND'].format("all.yml") + " -t start_bahmni"
   click.echo(command)
   subprocess.call(command, shell=True)

@cli.command(short_help="stops all the services required for bahmni")
@click.pass_context
def stop(ctx):
   command = ctx.obj['ANSIBLE_COMMAND'].format("all.yml") + " -t stop_bahmni"
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
   command = ctx.obj['ANSIBLE_COMMAND'].format("all.yml") + " -t config"
   click.echo(command)
   subprocess.call(command, shell=True)

@cli.command(name="concat-configs",
 short_help="Concatenating configs from /var/www/bahmni_config/openmrs directory")
@click.pass_context
def update_config(ctx):
   command = ctx.obj['ANSIBLE_COMMAND'].format("concat-config.yml")
   click.echo(command)
   subprocess.call(command, shell=True)

@cli.command(name="setup-replication", short_help="sets up mysql db replication")
@click.pass_context
def setup_replication(ctx):
   command = ctx.obj['ANSIBLE_COMMAND'].format("replication.yml")
   click.echo(command)
   subprocess.call(command, shell=True)

