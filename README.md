# Comenzando.
Este proyecto desplegará en un entorno de desarrollo una infraestructura wordpress de alta disponibilidad. Usaremos Terraform para la configuración de la infraestructura y Azure Devops para el despliegue automático.
# Requisitos previos.
Tener instalado en un nuestro equipo local la última versión de Terraform. Actualmente la última versión estable es la 0.12.18.
*	Instalar Terraform:
    * apt-get update
    * wget https://releases.hashicorp.com/terraform/0.12.7/terraform_0.12.18_linux_amd64.zip
    * unzip terraform_0.12.7_linux_amd64.zip
    * sudo mv terraform /usr/local/bin/
*   Comprobar instalación de Terraform:
    * terraform --version 
# Módulos y recursos.
* ALB: módulo de configuración del Balanceador de nuestra infra. Contendra los siguientes recursos:
    - osdf
* 
# Contribute
TODO: Explain how other users and developers can contribute to make your code better. 

If you want to learn more about creating good readme files then refer the following [guidelines](https://docs.microsoft.com/en-us/azure/devops/repos/git/create-a-readme?view=azure-devops). You can also seek inspiration from the below readme files:
- [ASP.NET Core](https://github.com/aspnet/Home)
- [Visual Studio Code](https://github.com/Microsoft/vscode)
- [Chakra Core](https://github.com/Microsoft/ChakraCore)