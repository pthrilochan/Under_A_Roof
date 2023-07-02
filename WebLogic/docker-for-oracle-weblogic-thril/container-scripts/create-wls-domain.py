#Copyright (c) 2014-2018 Oracle and/or its affiliates. All rights reserved.
#
#Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.
#
# WebLogic on Docker Default Domain
#
# Domain, as defined in DOMAIN_NAME, will be created in this script. Name defaults to 'base_domain'.
#
# Since : October, 2014
# Author: monica.riccelli@oracle.com
# ==============================================
# domain_path  = '/u01/oracle/user_projects/domains/%s' % domain_name
# domain_name  = os.environ.get("DOMAIN_NAME", "base_domain")
# production_mode = os.environ.get("PRODUCTION_MODE", "prod")
# admin_server_name  = os.environ.get("ADMIN_NAME", "AdminServer")
# admin_listen_port   = int(os.environ.get("ADMIN_LISTEN_PORT", "7001"))
# administration_port_enabled = os.environ.get("ADMINISTRATION_PORT_ENABLED", "true")
# administration_port = int(os.environ.get("ADMINISTRATION_PORT", "9002"))

# print('domain_path                 : [%s]' % domain_path);
# print('domain_name                 : [%s]' % domain_name);
# print('production_mode             : [%s]' % production_mode);
# print('admin name                  : [%s]' % admin_server_name);
# print('admin_listen_port           : [%s]' % admin_listen_port);
# print('administration_port_enabled : [%s]' % administration_port_enabled);
# print('administration_port         : [%s]' % administration_port);

# Open default domain template
# ============================
readTemplate("/u01/oracle/wlserver/common/templates/wls/wls.jar")

set('Name', domain_name)
setOption('DomainName', domain_name)
create(domain_name,'Log')
cd('/Log/%s' % domain_name);
set('FileName', '%s.log' % (domain_name))

# Configure the Administration Server
# ===================================
if administration_port_enabled != "false":
   set('AdministrationPort', administration_port)
   set('AdministrationPortEnabled', 'true')

# Disable Admin Console
# --------------------
# cmo.setConsoleEnabled(false)

# Configure the Administration Server and SSL port.
# =================================================
cd('/Servers/AdminServer')
set('Name', admin_server_name)
set('ListenAddress', '')
set('ListenPort', admin_listen_port)
if administration_port_enabled != "false":
   create('AdminServer','SSL')
   cd('SSL/AdminServer')
   set('Enabled', 'True')

# Set the admin user's username and password
# =====================================
cd(('/Security/%s/User/weblogic') % domain_name)
cmo.setName(username)
cmo.setPassword(password)

# Write the domain and close the domain template
# ==============================================
setOption('OverwriteDomain', 'true')
#setOption('ServerStartMode',production_mode)
# Create a cluster
# ================
cd('/')
cl=create(cluster_name, 'Cluster')

if cluster_type == "CONFIGURED":

  # Create managed servers
  for index in range(0, number_of_ms):
    cd('/')
    msIndex = index+1

    cd('/')
    name = '%s%s' % (managed_server_name_base, msIndex)

    create(name, 'Server')
    cd('/Servers/%s/' % name )
    print('managed server name is %s' % name);
    set('ListenPort', server_port)
    set('NumOfRetriesBeforeMSIMode', 0)
    set('RetryIntervalBeforeMSIMode', 1)
    set('Cluster', cluster_name)

else:
  print('Configuring Dynamic Cluster %s' % cluster_name)

  templateName = cluster_name + "-template"
  print('Creating Server Template: %s' % templateName)
  st1=create(templateName, 'ServerTemplate')
  print('Done creating Server Template: %s' % templateName)
  cd('/ServerTemplates/%s' % templateName)
  cmo.setListenPort(server_port)
  cmo.setCluster(cl)

  cd('/Clusters/%s' % cluster_name)
  create(cluster_name, 'DynamicServers')
  cd('DynamicServers/%s' % cluster_name)
  set('ServerTemplate', st1)
  set('ServerNamePrefix', managed_server_name_base)
  set('DynamicClusterSize', number_of_ms)
  set('MaxDynamicClusterSize', number_of_ms)
  set('CalculatedListenPorts', false)


# Create Node Manager
# ===================
#cd('/NMProperties')
#set('ListenAddress','')
#set('ListenPort',5556)
#set('CrashRecoveryEnabled', 'true')
#set('NativeVersionEnabled', 'true')
#set('StartScriptEnabled', 'false')
#set('SecureListener', 'false')
#set('LogLevel', 'FINEST')

# Set the Node Manager user name and password 
# ===========================================
#cd('/SecurityConfiguration/%s' % domain_name)
#set('NodeManagerUsername', username)
#set('NodeManagerPasswordEncrypted', password)

# Write Domain
# ============
writeDomain(domain_path)
closeTemplate()

# Exit WLST
# =========
exit()
