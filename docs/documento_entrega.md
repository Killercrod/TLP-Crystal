# Documento de entrega - TLP-Crystal

## 1. Descripción general

La aplicación es un sistema de agenda de contactos desarrollado en Crystal. Permite registrar, buscar, eliminar, listar y guardar contactos, además de filtrar cumpleaños por mes. La información se mantiene en memoria principal mediante un árbol binario de búsqueda y se persiste en memoria secundaria en un archivo CSV.

## 2. Organización de la aplicación

La aplicación está organizada por responsabilidades:

- `src/main.cr`: punto de entrada y menú interactivo de la aplicación.
- `src/agenda_contactos.cr`: capa de lógica de negocio que coordina validaciones, búsquedas, altas, bajas y persistencia.
- `src/contacto_bst.cr`: implementación del árbol binario de búsqueda para contactos.
- `src/nodo.cr`: estructura auxiliar para los nodos del árbol.
- `src/contacto.cr`: modelo principal de contacto y validaciones de fecha.
- `contactos.csv`: archivo de persistencia donde se guardan y cargan los contactos.

### Flujo general

1. Al iniciar, la aplicación crea una instancia de `AgendaContactos`.
2. `AgendaContactos` carga los contactos desde `contactos.csv` si el archivo existe.
3. El usuario interactúa con el menú de `main.cr`.
4. Cada operación se delega a la capa de negocio.
5. Los cambios se reflejan en el árbol BST y se guardan en CSV cuando corresponde.

## 3. Funciones, procedimientos, clases y objetos

### Clase `Contacto`

Representa un contacto individual. Sus atributos son:

- `nombre`
- `email`
- `telefono`
- `dia`
- `mes`

Responsabilidades principales:

- validar fechas de cumpleaños,
- formatear la fecha de cumpleaños,
- mostrar información en distintos formatos,
- comparar contactos por nombre,
- crear copias del objeto.

### Clase `Nodo`

Es la estructura auxiliar del árbol binario de búsqueda. Cada nodo contiene:

- un objeto `Contacto`,
- referencia al hijo izquierdo,
- referencia al hijo derecho.

### Clase `ContactoBST`

Implementa la estructura de árbol binario de búsqueda. Sus funciones principales son:

- `insertar`: agrega un contacto manteniendo el orden alfabético por nombre,
- `buscar_por_nombre`: localiza un contacto por nombre,
- `eliminar_por_nombre`: elimina un contacto del árbol,
- `listar_inorden`: devuelve los contactos ordenados alfabéticamente,
- `buscar_por_mes`: filtra contactos por mes de cumpleaños.

La eliminación contempla los tres casos clásicos:

- nodo hoja,
- nodo con un hijo,
- nodo con dos hijos.

### Clase `AgendaContactos`

Es la capa de coordinación de la aplicación. Sus funciones principales son:

- `agregar_contacto`: valida datos, evita duplicados y guarda cambios,
- `buscar_contacto`: busca por nombre,
- `eliminar_contacto`: elimina un contacto y actualiza el archivo CSV,
- `buscar_por_mes`: filtra cumpleaños por mes,
- `listar_contactos`: obtiene el listado completo,
- `guardar_en_csv`: escribe la información en memoria secundaria,
- `cargar_contactos`: reconstruye la estructura al iniciar la aplicación.

### Procedimiento principal en `main.cr`

El archivo `src/main.cr` contiene el ciclo principal de la aplicación. Su comportamiento es:

- mostrar el menú,
- leer la opción del usuario,
- pedir los datos necesarios,
- llamar a la capa de negocio,
- mostrar mensajes de éxito o error,
- salir del programa cuando el usuario lo indique.

## 4. Estructuras de datos utilizadas

### 4.1 Memoria principal

La estructura principal es un **árbol binario de búsqueda (BST)**.

Ventajas en este proyecto:

- mantiene los contactos ordenados por nombre,
- facilita búsquedas por nombre,
- permite listar en orden alfabético con recorrido inorden,
- soporta eliminación preservando la estructura.

#### Estructura interna

- Cada nodo almacena un objeto `Contacto`.
- Los contactos menores al nodo actual se ubican a la izquierda.
- Los contactos mayores se ubican a la derecha.

### 4.2 Memoria secundaria

La persistencia se realiza en un archivo **CSV** llamado `contactos.csv`.

Características del archivo:

- primera fila con encabezados,
- una fila por contacto,
- columnas: `Nombre`, `Email`, `Telefono`, `Dia`, `Mes`.

El archivo se usa para:

- cargar la agenda al iniciar,
- guardar cambios después de agregar o eliminar contactos,
- conservar la información entre ejecuciones.

### 4.3 Estructuras auxiliares

- `Array(Contacto)` para recorridos y listados temporales.
- `CSV` de la biblioteca estándar para leer y escribir el archivo.

## 5. Organización interna de los archivos

La solución está separada por responsabilidades para facilitar mantenimiento y pruebas.

- `src/contacto.cr`: reglas de validación y formato de un contacto.
- `src/nodo.cr`: nodo del BST.
- `src/contacto_bst.cr`: operaciones del árbol.
- `src/agenda_contactos.cr`: lógica de negocio y persistencia.
- `src/main.cr`: interfaz de usuario por consola.
- `spec/*.cr`: pruebas automatizadas.

## 6. Capturas de pantalla de ejemplo de ejecución

A continuación se listan las capturas sugeridas para incluir en la entrega final. Si todavía no se han generado, se pueden agregar más adelante con nombres similares.

### Captura 1: menú principal

![Menú principal](screenshots/menu_principal.png)

### Captura 2: agregar contacto

![Alta de contacto](screenshots/agregar_contacto.png)

### Captura 3: búsqueda por nombre

![Buscar contacto](screenshots/buscar_contacto.png)

### Captura 4: eliminación de contacto

![Eliminar contacto](screenshots/eliminar_contacto.png)

### Captura 5: listado de contactos

![Listar contactos](screenshots/listar_contactos.png)

### Captura 6: archivo CSV generado

![CSV generado](screenshots/csv_generado.png)

## 7. Código fuente del programa

El código fuente completo del programa está organizado en los siguientes archivos:

- `src/contacto.cr`
- `src/nodo.cr`
- `src/contacto_bst.cr`
- `src/agenda_contactos.cr`
- `src/main.cr`

Las pruebas automáticas se encuentran en:

- `spec/contacto_spec.cr`
- `spec/contacto_bst_spec.cr`
- `spec/agenda_contactos_spec.cr`

Además, el repositorio incluye el archivo de persistencia `contactos.csv` y la configuración del proyecto en `shard.yml`.

## 8. Conclusión

La aplicación queda organizada en capas claras: modelo, estructura de datos, lógica de negocio e interfaz de consola. El uso de un BST permite búsquedas y organización eficiente en memoria principal, mientras que el CSV asegura persistencia entre ejecuciones.
