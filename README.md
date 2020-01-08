# **Comenzando.**
Este proyecto desplegará en un entorno de desarrollo una infraestructura wordpress de alta disponibilidad. Usaremos Terraform para la configuración de la infraestructura y Azure Devops para el despliegue automático.
# **Requisitos previos**.
Tener instalado en un nuestro equipo local la última versión de Terraform. Actualmente la última versión estable es la 0.12.18.
*	**Instalar Terraform:**
    * apt-get update
    * wget https://releases.hashicorp.com/terraform/0.12.18/terraform_0.12.18_linux_amd64.zip
    * unzip terraform_0.12.18_linux_amd64.zip
    * sudo mv terraform /usr/local/bin/
*   **Comprobar instalación de Terraform:**
    * terraform --version 
* **Crear una Dynamo DB y un Bucket en AWS para nuestro Backend.**
# **Módulos y recursos.**
* **Módulo alb**: módulo de configuración del Balanceador de nuestra infra. Contendra los siguientes recursos:
    - **"aws_alb"** -> Load Balancer.
    - **"aws_lb_listener"** -> Listener.
    - **"aws_lb_target_group"** -> Target Group.
    - **"aws_security_group"** -> Security Group de nuestro Balanceador.
* **Módulo ec2:**: contendrá la configuracion de lanzamiento de nuestras instancias. Contendra los siguientes recursos:
    - **"aws_autoscaling_group"** -> grupo de autoescalado que lanzara la instancia.
    - **"aws_autoscaling_schedule** -> planificación de los escalados "up" y "down" de nuestras instancias. Se crearan 2 recursos, uno por cada configuración.
    - **"aws_launch_template"** -> plantilla de lanzamiento de nuestra instancia.
    - **"aws_security_group"** -> Security Group de nuestras instancias.
*   **Módulo efs**: punto de montaje del File System de nuestras instancias worpdress. Contendrá los siguientes recursos:
    - **"aws_efs_file_system"** -> Nuestro File System.
    - **"aws_efs_mount_target** -> Punto de montaje de nuestro EFS.
    - **""aws_security_group"** -> Security Group de nuestro File System.
*   **Módulo rds:**: configuración relativa a nuestra BBDD. Contendrá los siguientes recursos:
    - **"aws_db_instance"** -> instancia de nuestra BBDD.
    - **"aws_db_subnet_group"** -> grupo que dispondra de acceso a la DB.
    - **"aws_security_group"** -> Security Group de nuestra DB.
# Despliegue de la infraestructura.
*    **1. Iniciar nuestro Backend de Terraform**
    - terraform init
*    **2. Ejecutar plan**
    - terraform plan
*    **3. Aplicar infraestructura**
    - terraform apply
*    **4. Destruir infraestructura**
    - terraform destroy