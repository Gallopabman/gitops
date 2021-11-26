# Week 01 - Assignments
Repositorio para los assignments de la primer semana.

# Java Application

## Prerequisites

	1. Internet connection
	2. git
	3. Go installed
	4. Terraform
	5. 

## Instalar Terraform

	1. curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -

	2. sudo apt-add-repository "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com $(lsb_release -cs) main"

	3. sudo apt install terraform

## Tareas Realizadas

	1. repo original https://gitlab.com/equipo-devops/bootcamps/semperti-bootcamp clonado y pusheado a https://gitlab.com/equipo-devops/bootcamps/sre-bootcamp-pablo-20211115	
	2. Branch general creada
	3. readme.md modificado 
	4. cambios pusheados a la rama general
	5. PR generada con cambios del primer assignment a rama master

## Comandos ejecutados

	1. apt install git - Para poder utilizar todos los comandos de git
	2. git init - iniciar la carpeta de archivos con git
	3. git remote add origin https://gitlab.com/equipo-devops/bootcamps/sre-bootcamp-pablo-20211115.git - asocia la carpeta con el repositorio de gitlab
	4. git add . - para agregar los cambios a los archivos que debemos pushear
	5. git commit -m "first commit" - para tagear el commit que sera pusheado
	6. git config - para configurar nombre de usuario y password
	7. git push --set-upstream origin master - para pushear todo a la rama master
	8. git checkout -b general - crear la rama general y hacer checkout a la misma
	9. git add .
	10. git commit -m "assignment 0 completed"
	11. git push - para pushear a la branch activa, en este caso general



## Inconvenientes encontrados

	1. Algunos comandos varian ligeramente con los acostumbrados
	2. Interfa de Gitlab resulta poco intuitiva de momento

## Instrucciones para correr esta aplicación

	1. Configurar la conexión de la base de datos desde Code/src/main/resources/application.properties
	2. Ubicate en la carpeta del código y ejecutá "mvn spring-boot:run".
	3. Revisá la siguiente dirección http://localhost:8080
	4. [Opcional] Por defecto, la aplicación almacena los PDFs en el directorio <User_home>/upload. Si querés cambiar este directorio, podés utilizar la propiedad -Dupload-dir=<path>.
	5. [Opcional] Los PDFs predefinidos pueden encontrarse en la carpeta PDF. Si querés ver los PDFs, tenés que copiar los contenidos de esta carpeta a lo definido en el paso anterior.
	
## Datos de autenticación

	El sistema viene con 4 cuentas pre-definidas:
		1. publishers:
			- username: publisher1 / password: publisher1
			- username: publisher2 / password: publisher2
		2. public users:
			- username: user1 / password: user1
			- username: user2 / password: user2
            
# Contact

Cualquier duda o consulta, ubicanos en [Slack](https://semperti.slack.com).
