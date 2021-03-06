
Setting up a Dev Environment
============================

We are going to set up a development environment using the OpenMRS SDK, with some custom steps to install the set of 40+ 
modules used by the PIH EMR.

Prerequisites
-------------

First, install git, mvn, and the OpenMRS SDK by following the "Installation" instructions here:

https://wiki.openmrs.org/display/docs/OpenMRS+SDK#OpenMRSSDK-Installation

Next, we need to install MySQL.  The OpenMRS SDK uses the H2 database by default, but H2 doesn't work with some of the 
modules we use, so we must use MySQL, which needs to be configured separately.  You should install MySQL Community 
Server 5.6 following the instructions for your platform. It must be version 5.6, other versions will not work.

Set up a development environment of a PIH EMR distibution
---------------------------------------------------------

### Step 1: Clone the "mirebalais-puppet" project
The various configuration files that determine what applications and options are turned on on different servers are
found here and later on in process you will need to tell OpenMRS where to find them.

```
$ git clone https://github.com/PIH/mirebalais-puppet.git
```

### Step 2: Ensure that MySQL has a password set up for the root user.
- If you are able to run ```$ mysql -u root``` and access the MySQL Monitor without receiving an access denied error,
it means that there is no root password set and you have to set it following the instructions here: https://dev.mysql.com/doc/refman/5.6/en/resetting-permissions.html
- Once the root password has been set, you should be able to access the MySQL Monitor by running:  
  ```$ mysql -u root -p``` followed by entering the password when prompted.  

### Step 3: Set up the environment
Set up the environment via the following command, chosing the serverId and dbName you want to use. Specify
the DB password for your root user as set in Step 2.
*Note that the environment will be set up the directory ~/openmrs/[serverId]*
*The convention for dbNames are "openmrs_[some name]"*

```
$ mvn openmrs-sdk:setup -DserverId=[serverId] -Ddistro=org.openmrs.module:mirebalais:1.2-SNAPSHOT \
    -DdbUri=jdbc:mysql://localhost:3306/[dbName] -DdbUser=root -DdbPassword=[password]
```

### Step 4: Start up the server

```
$ mvn openmrs-sdk:run -DserverId=[serverId]
```

It should run for several minutes, setting up the database, (you may have to go to http://localhost:8080/openmrs to trigger this) BUT, in the end, it will fail.  You should cancel the current run (Ctrl-C in the terminal window).

After it fails, notice that a openmrs-runtime.properties file should have been created in the ~/openmrs/[serverId]

You will need to add two lines to these file, one specifying which of our configs to use for this server, and another
referencing the location of the config files (which you checked out as part of the mirebalais-puppet project above).
For instance, if you want to set up the Mirebalais CI environment, and you checked out the mirebalais puppet project
into your home directory, add the following into the runtime properties:

- pih.config=mirebalais,mirebalais-humci
- pih.config.dir=/[path to]/mirebalais-puppet/mirebalais-modules/openmrs/files/config

Then rerun:

```
$ mvn openmrs-sdk:run -DserverId=[serverId]
```

Startup should take several minutes as it loads in all required metadata, etc, for the first time.

### Step 5: Create a local identifier source
After startup, login
- Enter "http://localhost:8080/openmrs/login.htm" into the Chrome web browser
  - Log in with the following details:
    - Username: admin
    - Password: Admin123
  - (The password is the default password, it is referenced in the openmrs-server.properties file within the ~/openmrs/[serverId] folder)
- Enter the legacy admin page "http://localhost:8080/openmrs/admin"
- Go to "Manage Patient Identifier Sources" under the header "Patients"

Check if there is an existing local identifier source. If there isn't, you'll
need to create a local identifier source to generate "fake" ZL EMR IDs:
- Add a new "Local Identifier Generator" for the "ZL EMR ID" with the following settings:
  - Name: ZL Identifier Generator
  - Base Character Set: ACDEFGHJKLMNPRTUVWXY1234567890
  - First Identifier Base: 1000
  - Prefix: Y
  - Suffix: (Leave Blank)
  - Max Length: 6
  - Min Length: 6
- Link the local generator to the Local Pool of Zl Identifiers
  - Click the Configure Action next to the local pool
  - Set "Pool Identifier Source" to "ZL Identifier Generator"
  - Change "When to fill" to "When you request an identifier"


Updating
--------

Once you have installed the distribution, you should be able to update it with the following commands... 

If you are watching any modules, first execute "mvn openmrs-sdk:pull" to pull in any changes to these modules via git.

Then, from the base directory of the mirebalais project run the following two commands to update any changes to modules
you aren't watching:

```
$ git pull
$ mvn openmrs-sdk:deploy -Ddistro=api/src/main/resources/openmrs-distro.properties -U
```

(I have created a shell script shortcut to execute the two commands above, pihemrDeploy.sh)

To run the server: 
```
$ mvn openmrs-sdk:run
```

Making Things Easy
------------------

### Aliases

(You might be able to set the "debug" flag at project creation time now. 
`pihemrDeploy.sh` is a utility script created by Mark Goodrich.)

```
$ alias omrs-pull='mvn openmrs-sdk:pull'
$ alias omrs-deploy='cd /home/mgoodrich/openmrs/modules/mirebalais && ./pihemrDeploy.sh'
$ alias omrs-run='mvn openmrs-sdk:run -Ddebug'
```

So to do a daily update of the system, run:

```
$ omrs-pull
$ omrs-deploy
$ omrs-run
```

### PyInvoke

There's an [Invoke](http://www.pyinvoke.org/) file for doing local development of the PIH EMR
[here](https://github.com/brandones/pih-emr-workspace/blob/master/tasks.py).
Feel free to make pull requests.

Source Code
-----------

All source code for OpenMRS is stored on Github, in either the OpenMRS organizaiton (for core and community modules) or 
the PIH organization (for PIH-specific modules).

https://github.com/openmrs
https://github.com/PIH

The naming convention for a module repo is "openmrs-module-[module_name]".

Getting Set Up with IntelliJ
----------------------------

At least with `openmrs-module-pihcore`, IntelliJ may want to identify some 
directories as modules that are not modules,
and are in fact subdirectories of actual modules. The problem is that these phony modules don't inherit Maven
dependency information from the parent modules, so IntelliJ will fail to resolve references to those dependencies.
To fix this, go to Project Structure -> Modules and remove those directories.

Other than that, this project is more or less plug-and-play in IntelliJ.
