require "./contacto"
require "./contacto_bst"

# Clase que orquesta la lógica de negocio sobre los contactos
class AgendaContactos
  def initialize
    @arbol = ContactoBST.new
  end

  # Agrega un contacto nuevo; lanza ArgumentError si ya existe por nombre
  def agregar_contacto(nombre : String, email : String, telefono : String, dia : Int32, mes : Int32)
    contacto = Contacto.new(nombre, email, telefono, dia, mes)

    if @arbol.buscar_por_nombre(nombre)
      raise ArgumentError.new("Ya existe un contacto con ese nombre")
    end

    @arbol.insertar(contacto)
  end

  # Busca un contacto por nombre (case-insensitive)
  def buscar_contacto(nombre : String) : Contacto?
    @arbol.buscar_por_nombre(nombre)
  end

  # Eliminar contacto por nombre. Retorna true si se eliminó, false si no existía.
  def eliminar_contacto(nombre : String) : Bool
    @arbol.eliminar(nombre)
  end

  # Buscar contactos por mes (delegado al BST)
  def buscar_por_mes(mes : Int32) : Array(Contacto)
    @arbol.buscar_por_mes(mes)
  end

  # Listar todos los contactos en orden alfabético
  def listar_contactos : Array(Contacto)
    @arbol.listar_inorden
  end
end
