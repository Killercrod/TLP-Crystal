require "./contacto"
require "./contacto_bst"

class AgendaContactos
  def initialize
    @arbol = ContactoBST.new
  end

  def agregar_contacto(nombre : String, email : String, telefono : String, dia : Int32, mes : Int32)
    contacto = Contacto.new(nombre, email, telefono, dia, mes)
    @arbol.insertar(contacto)
    contacto
  end

  def buscar_contacto(nombre : String) : Contacto?
    @arbol.buscar_por_nombre(nombre)
  end

  def buscar_por_mes(mes : Int32) : Array(Contacto)
    @arbol.buscar_por_mes(mes)
  end

  def listar_contactos : Array(Contacto)
    @arbol.listar_inorden
  end

  def guardar_en_csv(ruta : String = "contactos.csv") : String
    lineas = listar_contactos.map { |contacto| contacto_a_csv(contacto) }
    contenido = lineas.join("\n")
    contenido = "#{contenido}\n" unless contenido.empty?

    File.write(ruta, contenido)
    ruta
  end

  private def contacto_a_csv(contacto : Contacto) : String
    "#{contacto.nombre},#{contacto.email},#{contacto.telefono},#{contacto.dia},#{contacto.mes}"
  end
end