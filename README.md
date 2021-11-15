# Week 01 - Assignments
Repositorio para los assignments de la primer semana.

# Java Application

## Prerequisites

	1. Internet connection
	

## Tareas Realizadas

	1. repo original https://gitlab.com/equipo-devops/bootcamps/semperti-bootcamp clonado y pusheado a https://gitlab.com/equipo-devops/bootcamps/sre-bootcamp-pablo-20211115	
	2. Branch general creada
	3. readme.md modificado 
	4. cambios pusheados a la rama general
	5. PR generada con cambios del primer assignment a rama master

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
