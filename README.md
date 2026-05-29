# TLP-Crystal
# Requerimientos del proyecto

En equipos, diseñar e implementar una aplicación usando el lenguaje de programación asignado. La aplicación consistirá en un programa para guardar y consultar la información de un grupo de contactos. La información que se requiere almacenar para cada contacto es: nombre, fecha de cumpleaños (dd/mm), teléfono y correo electrónico. La información de los contactos se deberá almacenar en un archivo en almacenamiento secundario antes de terminar la ejecución de la aplicación para mantener su persistencia, y al iniciar la ejecución de la aplicación se deberá leer del archivo la información de los contactos.

Las opciones de la aplicación serán al menos:

1. agregar un contacto;
2. borrar un contacto;
3. consultar los datos de un contacto especificado por nombre;
4. listar los contactos y su fecha de cumpleaños ordenados a partir del día actual;
5. listar todos los contactos ordenados alfabéticamente por nombre junto con su teléfono y correo-e.
   
# Requerimientos Funcionales y No Funcionales

## Requerimientos Funcionales

| ID  | Requerimiento |
|-----|---------------|
| RF1 | El sistema debe permitir agregar un nuevo contacto con los siguientes datos: nombre, fecha de cumpleaños (dd/mm), teléfono y correo electrónico. |
| RF2 | El sistema debe permitir borrar un contacto existente. |
| RF3 | El sistema debe permitir consultar todos los datos de un contacto especificando su nombre. |
| RF4 | El sistema debe listar todos los contactos junto con su fecha de cumpleaños, ordenados cronológicamente a partir del día actual (considerando solo día y mes). |
| RF5 | El sistema debe listar todos los contactos ordenados alfabéticamente por nombre, mostrando para cada uno: nombre, teléfono y correo electrónico. |
| RF6 | El sistema debe almacenar la información de los contactos en un archivo en almacenamiento secundario antes de finalizar la ejecución. |
| RF7 | Al iniciar la ejecución, el sistema debe leer el archivo de almacenamiento secundario y cargar los contactos previamente guardados. |

## Requerimientos No Funcionales

| ID   | Requerimiento |
|------|---------------|
| RNF1 | La aplicación debe desarrollarse en el lenguaje de programación asignado por la cátedra/equipo. |
| RNF2 | El archivo de persistencia debe tener un formato estructurado (ej. CSV, JSON, binario, etc.) que permita guardar y recuperar todos los campos de cada contacto. |
| RNF3 | La aplicación debe ser ejecutable en un entorno de consola (línea de comandos) sin dependencia de interfaz gráfica. |
| RNF4 | El ordenamiento de los contactos por fecha de cumpleaños debe ser circular: a partir del día actual, continuando con meses/días posteriores y luego los anteriores al actual. |
| RNF5 | El sistema debe manejar correctamente la ausencia del archivo de datos al primer inicio (creándolo o informando que no hay contactos). |
| RNF6 | Las operaciones de agregar, borrar y consultar deben reflejarse inmediatamente en la estructura en memoria y, cuando corresponda, persistirse en el archivo. |
```mermaid
flowchart TD

    %% =========================
    %% USUARIO
    %% =========================
    U[Usuario]

    %% =========================
    %% MENU PRINCIPAL
    %% =========================
    M[Menu Principal]

    U --> M

    %% =========================
    %% OPCIONES MENU
    %% =========================
    M --> A1[Alta de contacto]
    M --> A2[Buscar contacto]
    M --> A3[Eliminar contacto]
    M --> A4[Modificar contacto]
    M --> A5[Buscar por mes]
    M --> A6[Listar contactos]
    M --> A7[Guardar datos]
    M --> A8[Salir]

    %% =========================
    %% FLUJO ALTA
    %% =========================
    A1 --> B1[Validar datos]
    B1 --> B2[Crear objeto Contacto]
    B2 --> BST

    %% =========================
    %% FLUJO BUSQUEDA
    %% =========================
    A2 --> C1[Solicitar nombre]
    C1 --> BST
    BST --> C2[Mostrar contacto]

    %% =========================
    %% FLUJO ELIMINACION
    %% =========================
    A3 --> D1[Solicitar nombre]
    D1 --> BST
    BST --> D2[Eliminar nodo]
    D2 --> CSV

    %% =========================
    %% FLUJO MODIFICACION
    %% =========================
    A4 --> E1[Buscar contacto]
    E1 --> BST
    BST --> E2[Modificar datos]
    E2 --> CSV

    %% =========================
    %% FLUJO BUSQUEDA POR MES
    %% =========================
    A5 --> F1[Solicitar mes]
    F1 --> BST
    BST --> F2[Filtrar cumpleaños]
    F2 --> FECHA
    FECHA --> F3[Mostrar dia de semana]

    %% =========================
    %% LISTADO GENERAL
    %% =========================
    A6 --> G1[Recorrido inorder]
    G1 --> BST
    BST --> G2[Mostrar orden alfabetico]

    %% =========================
    %% GUARDAR ARCHIVO
    %% =========================
    A7 --> H1[Recorrer BST]
    H1 --> H2[Convertir a CSV]
    H2 --> CSV

    %% =========================
    %% INICIO SISTEMA
    %% =========================
    START[Inicio programa]
    START --> LOAD[Leer archivo CSV]
    LOAD --> BUILD[Construir BST]
    BUILD --> M

    %% =========================
    %% MODULOS
    %% =========================
    subgraph SISTEMA

        BST[Arbol Binario de Busqueda]

        subgraph ESTRUCTURAS
            CONTACTO[Clase Contacto]
            NODO[Clase Nodo]
        end

        subgraph ARCHIVOS
            CSV[(contactos.csv)]
        end

        subgraph UTILIDADES
            FECHA[Utilidades Fecha]
        end

    end

    %% =========================
    %% RELACIONES INTERNAS
    %% =========================
    BST --> NODO
    NODO --> CONTACTO

    %% =========================
    %% PERSISTENCIA
    %% =========================
    BST --> CSV
```
