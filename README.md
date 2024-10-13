# drupalWorkSpace

**drupalWorkSpace** is a containerized development environment designed to facilitate the deployment of a Drupal instance. This project utilizes modern tools such as Docker, Caddy, PostgreSQL, GitLab, and FrankenPHP. The goal is to simplify the installation and management of Drupal while providing a workflow for continuous integration and deployment via GitLab.

## Table of Contents

1. [Workflows](#workflows)
   - [Development Mode](#1-development-mode)
   - [Production Mode](#2-production-mode)
   - [Deployment Mode (CI/CD)](#3-deployment-mode-cicd)
2. [Project Structure](#project-structure)
3. [Prerequisites](#prerequisites)
4. [Installation](#installation)
5. [Testing the Production Version Before Deployment](#test-the-production-version-before-deployment)
6. [Deployment (CI/CD)](#deployment-cicd)
7. [Available Commands](#available-commands)

## Workflows

### 1. Development Mode

The development mode of **drupalWorkSpace** allows you to quickly create a development environment for Drupal, with minimal prerequisites or tools to install on your workstation. To enable this mode, simply set the variable `ENVIRONMENT=dev` in the `.env` file located at the root of the project.

In development mode, three containers are deployed:
- **Drupal** with FrankenPHP
- **PostgreSQL**, which contains the database
- **Adminer**, which provides a database management interface

### 2. Production Mode

The production mode allows you to test your application in an environment similar to production before deployment. To switch to production mode, modify the variable `ENVIRONMENT=prod` in the `.env` file at the root of the project.

In production mode, only one container is deployed: the Drupal container. It is recommended to use a managed database and a Docker registry to store the project's deliverable. You will need to provide the database connection information as well as the Docker registry details in `config/prod/.env`. Once this is done, you will be ready to test the production version locally on your workstation.

### 3. Deployment Mode (CI/CD)

When you initialize Git in your project and push the code to the remote repository, you enter deployment mode. Here are some prerequisites to ensure a successful deployment:

1. Ensure you have a functional instance of GitLab with a configured GitLab Runner, or use [gitlab.com](https://gitlab.com).
2. Create the variables present in the `.gitlab-ci.yml` file at the GitLab level, in the **Settings > CI/CD > Variables** section. The variables related to the Docker registry do not need to be manually entered, as they are automatically available in GitLab (`$CI_REGISTRY_USER`, `$CI_REGISTRY_PASSWORD`, `$CI_REGISTRY`).
3. Prepare your server by depositing the **drupalWorkSpace** files.

Additional details regarding the setup of the three workflows are provided below.

## Project Structure

```bash
├── config/
│   ├── dev/
│   │   ├── .env
│   │   ├── Dockerfile
│   │   └── compose.yml
│   ├── prod/
│   │   ├── .env
│   │   ├── Dockerfile
│   │   └── compose.yml
│   ├── settings
│   ├── Caddyfile
├── docs/
│   └── contributing.md
├── drupal/
├── files/
├── .env
├── .gitlab-ci.yml
├── LICENSE
├── Makefile
├── README.md
```

## Prerequisites

Before you begin, make sure you have installed the following tools on your machine:

- [Docker](https://www.docker.com/)
- [Docker Compose](https://docs.docker.com/compose/)
- [Make](https://www.gnu.org/software/make/)

## Installation

1. **Clone the repository to your local machine:**

   ```bash
   git clone https://github.com/applize-io/drupalworkspace.git
   cd drupalworkspace
   ```

2. **Build the Docker containers with Docker Compose:**

   ```bash  
   make up
   ```

2. **Display logs from all services:**

   ```bash  
   make logs
   ```

3. **Initialize a Drupal project:**  
   Now that the container is running, you can initialize a Drupal project to be ready to work. If you want to start a new Drupal project, use the following command to create a Drupal project in its latest version (11 at the time of writing):

   ```bash  
   make project
   ```

4. **For an existing Drupal project:**  
   Place it directly in the `drupal` folder without executing the `make project` command. Then, adjust the default configuration in `web/sites/default/settings.php` with the contents of the `config/settings` file from **drupalWorkSpace**.

   ```php
   $databases['default']['default'] = array (
     'database' => getenv('DB_NAME'),
     'username' => getenv('DB_USER'),
     'password' => getenv('DB_PASSWORD'),
     'host' => getenv('DB_HOST'),
     'driver' => getenv('DB_DRIVER'),
     'port' => getenv('DB_PORT'),
     'prefix' => '',
   );

   $settings['backend_url'] = getenv('BACKEND_URL');
   $settings['frontend_url'] = getenv('FRONTEND_URL');
   $settings['config_sync_directory'] = getenv('CONFIG_SYNC_DIRECTORY');
   $settings['hash_salt'] = getenv('DRUPAL_HASH_SALT');
   $config['system.logging']['error_level'] = getenv('ERROR_LEVEL');
   ```

5. **Check Your Development Mode:**  
   Make sure you are in development mode by checking the `.env` file at the root of the project and confirming that `ENVIRONMENT=dev`. The development mode uses the files present in `config/dev` to launch the project. Feel free to make adjustments if necessary.

6. **Access Your Application:**  
   Open your browser and type [http://localhost:786](http://localhost:786) to see your running Drupal instance. You should see the Drupal installation interface. Proceed with the installation as usual.

## Test the Production Version Before Deployment

Before sending your project to the repository and enabling the continuous deployment process, it is essential to verify that the deployment will proceed correctly. If you are setting up the production environment for the first time, you must define the Drupal site ID in the online database. This will allow you to export the configurations made locally (for example, creating a new content type) and import them into the production version. Indeed, Drupal prevents import if the two instances (local and production) do not share the same site ID.

### Steps to Follow

1. **Export Configurations and Check Site ID**
   Run the following two commands. The first exports the configurations from your development Drupal instance, and the second displays the UUID of your development Drupal site.
   ```bash
   make drush config:export
   make drush config:get "system.site" uuid
   ```
   - **Note the displayed UUID.**

2. **Stop the Project**
   Use the following command to stop the project:
   ```bash
   make stop
   ```

3. **Enable Production Mode**
   Modify the `.env` file located at the root of the project to set `ENVIRONMENT=prod`.

4. **Configure the Database**
   Provide the database information, as well as the registry and Docker image in the `config/prod/.env` file. Ensure that your PostgreSQL database is accessible from the outside.

5. **Build and Push the Docker Image**
   Open a terminal at the root of the project and run the following command to build and push the project image to the configured Docker registry:
   ```bash
   make docker-push
   ```
   Enter the login credentials when prompted.

6. **Start the Project in Production Mode**
   Run the command below to start the project in production mode:
   ```bash
   make up
   ```
   If you want to force the refresh of the image used, use:
   ```bash
   make reset
   ```

   This command uses the `compose.yml` file present in `config/prod/`, which uses the image you just pushed to the registry, along with the online database access details provided in `config/prod/.env`.

7. **Access the Drupal Installation Interface**
   Once the project is started, go to the URL `https://localhost:786`. You should see the Drupal installation interface. Proceed with the installation as usual.

8. **Update the Site ID in the Online Database**
   Once Drupal is installed, return to the terminal and run the following command to update the site ID in the online database:
   ```bash
   make drush cset system.site uuid <copied_code>
   ```

9. **Import the Configurations**
   Next, run the command below to import the configurations:
   ```bash
   make drush config:import
   ```

10. **Verify the Online Site**
    Go back to `https://localhost:786` to check that the online site contains all the features implemented in the development version.

## Deployment (CI/CD)

In our context, the term "production" is used for the sake of simplicity and convenience. A production environment is, in reality, more complex. In a development cycle, it is common to put the project online to receive feedback from stakeholders, or when we are working as a team, especially in headless mode with Drupal. This implies that the frontend team is not necessarily the same as the backend team. Therefore, regular deployments are necessary to allow the frontend team to progress efficiently. This "production" mode corresponds more to a deployment on an online development server, although it may be suitable for a simple production site.

### Steps to Follow

1. **GitLab Instance:** You must have a functional instance of GitLab with a configured GitLab Runner, or use [GitLab.com](https://gitlab.com).
   
2. **Server:** You need to have a server where you will place the files for `drupalWorkSpace`. Choose a directory where you want to install your project, and then place the necessary files for deployment in production mode. Here is the file structure to follow:

   ```
   .
   ├── Makefile
   ├── config/
   │   └── prod/
   │       ├── .env
   │       └── compose.yml
   ├── files/
   ├── .env
   ├── LICENSE
   └── README.md
   ```

- **`files` directory:** This directory will contain the files uploaded by Drupal, as well as other files generated by it. The data is stored in a remote database, which can be hosted directly on the server.

- **`config/prod/.env` file:** This file contains the database and Docker registry information. If your database is hosted on the host server where the Docker container is running, leave the default value of the `DB_HOST` variable as `172.17.0.1`.

3. **GitLab CI/CD Variables:** You need to create the variables present in `.gitlab-ci.yml` in GitLab, under the `Settings > CI/CD > Variables` section. Here are the variables to set, with example values:

   ```bash  
   # The path where drupalWorkSpace is installed
   DEV_APP_PATH=/var/www/app.example.com

   # The RSA key to access your server via SSH
   # Choose the "file" type for this variable in GitLab.
   DEV_PRIVATE_KEY=-----BEGIN RSA PRIVATE KEY-----MIIJKQIB 

   # The IP address of your server
   DEV_SERVER_IP=1.1.1.1

   # The deployment user for your application
   DEV_USER=deployUser
   ```
   The variables concerning the registry do not need to be set, as they are automatically available from GitLab ($CI_REGISTRY_USER, $CI_REGISTRY_PASSWORD, $CI_REGISTRY).

4. **Initial Deployment:** If you have already manually pushed the image to the registry, you can perform an initial deployment manually. Navigate to the root of the project on the server and run the following command:

   ```bash  
   make up
   ```

   Enter the login credentials when prompted.

   If you haven’t pushed the image yet, this process may take longer due to the CI execution time. To ensure your server automatically saves access to your Docker registry, run the following command:

   ```bash  
   docker login https://registry.example.com
   ```
5. **Check the `.gitlab-ci.yml` file**: This file is essential for automating the deployment of Drupal on your server. By default, it is configured to trigger when you push code to the `main` branch. If you are using a different branch for deployment, make sure to adjust the file's configuration to account for this new branch.

6. **Push Your Project:** Once these steps are completed, you can push your project to the remote repository. GitLab should automatically build and push the image of your project to the registry, then connect to the server with the provided deployment user to deploy the new version of the image. Finally, it will finish by importing the new exported configurations.

## Available Commands

All commands from `drupalWorkSpace` are available in both development and production modes, except for the `make docker-push` command, which is only available in production mode, and the `make project` command, which is only available in development mode.

**1. make check**
Checks if Docker and Docker Compose are installed on your system.

```bash
make check
```

**2. make reset**
Stops, removes, rebuilds, and restarts the containers for the current environment with the latest changes.

```bash
make reset
```

**3. make up**
Stops and removes the existing containers, then starts the containers in the current environment with the latest changes without rebuilding the images.

```bash
make up
```

**4. make project**
Initialize a new Drupal installation in its latest version within the drupal/ directory located at the root of the project.

```bash
make project
```

**5. make start**
Starts the containers for the current environment without rebuilding the images.

```bash
make start
```

**6. make stop**
Stops the containers for the current environment.

```bash
make stop
```

**7. make prune**
Removes containers and volumes for the current environment.

```bash
make prune
```

**8. make logs**
Displays logs of the running containers.

```bash
make logs
```

**9. make ps**
Lists the running containers for the current environment.

```bash
make ps
```

**10. make drush**
Executes a Drush command inside the Drupal container.

Example usage:
```bash
make drush status
```

In this example, the `status` command is passed to Drush inside the container. You can replace `status` with any Drush command of your choice.

**11. make drupal**
Executes a command inside the Drupal container.

Example usage:
```bash
make drupal ls /opt/
```
In this example, the `ls /opt/` command is executed inside the Drupal container. You can replace this with any other system command.

**12. make docker-push**
Builds and pushes the Docker image to the registry.

```bash
make docker-push
```

**13. make db-export EXPORT_PATH=<path>**
Exports the database to a specified local path.

```bash
make db-export EXPORT_PATH=./backups/my_database.sql
```

In this example, the database is exported to `./backups/my_database.sql`. Make sure to specify the path where you want the export to be saved.

**14. make clean**
Removes unused Docker resources (containers, images, volumes, networks).

```bash
make clean
```

**15. make info**
Displays the current environment variables.

```bash
make info
```

Example output when running 'make info'

Environment: dev   
Project Name: drupalWorkSpace   
Compose file: config/dev/compose.yml   
Dockerfile: config/dev/Dockerfile   
Env file: config/dev/.env   

**16. make help**
Displays a list of all available targets in the `Makefile`, with a brief description.

```bash
make help
```