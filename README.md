# arquiI-armasm-rsa
Algoritmo de encriptado y descencriptado rsa

## Requisitos
  
  - Raspberry 3 b+ o Raspberry 3, con sistema operativo linux. Recomendado Unbuntu Mate 64 bits.
  - python 2.7
  - valgrind
  - gdb
  - aarch64-linux-gnu-gcc
  
## Instrucciones de uso

  Para ejecutar el algoritmo, los archivos deben encontrarse dentro de la plataforma de prueba. Para esto puede utilizar el archivo copy.sh que copia los archivos necesarios. Notar que se deben modificar la dirección IP y usar el correcto nombre de usuario. Ademas el mismo archivo contiene las instrucciones para compilar los archivos necesarios. 
  
  Tome en cuenta que la herramienta aarch64-linux-gnu-gcc debe estar instalada para el cross-compile.
  
  Para en la carpeta de prueba donde se van a encontrar los binarios del algoritmo dentro de la raspberry debe haber una carpeta llamada iofiles, donde están todos los archivos de entrada y salida. 
  
  Los archivos disponibles en esta carpeta debe tener los siguientes nombres:
  
  - msgDecryptedfile
  - msgEncryptedfile
  - msgfile
  - nfile
  - pfile
  - privateKfile
  - publicKfile
  - qfile
  
  Los unicos valores de entrada para el algoritmo son los de p, q y el mensaje que se desea trabajar.
  Para la lectura automatizada de estos archivos se creo el archivo ioparameters.py
  
  ### Evaluacion de performance
    
   Para la evaluacion performance se creo el archivo performance.sh que al ejecutarlo automatiza la generación de los resultados los cuales serán almacenados en la carpeta valgrind-out.
