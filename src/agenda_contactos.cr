require "csv"
require "./contacto"
require "./contacto_bst"

class AgendaContactos
  property arbol : ContactoBST
  property archivo_csv : String

  def initialize(archivo_csv = "contactos.csv")
    @archivo_csv = archivo_csv
    @arbol = ContactoBST.new
    cargar_contactos
  end

  def agregar_contacto(
    nombre : String,
    email : String,
    telefono : String,
    dia : Int32,
    mes : Int32
  ) : Contacto
    nombre = nombre.to_s.strip
    email = email.to_s.strip
    telefono = telefono.to_s.strip

    raise ArgumentError.new("El nombre no puede estar vacío") if nombre.empty?
    raise ArgumentError.new("El email no puede estar vacío") if email.empty?
    raise ArgumentError.new("El teléfono no puede estar vacío") if telefono.empty?

    if buscar_contacto(nombre)
      raise ArgumentError.new("Ya existe un contacto con ese nombre")
    end

    contacto = Contacto.new(nombre, email, telefono, dia, mes)
    raise ArgumentError.new("Contacto inválido") unless contacto.valido?

    @arbol.insertar(contacto)
    guardar_en_csv
    contacto
  end

  def buscar_contacto(nombre : String) : Contacto?
    @arbol.buscar_por_nombre(nombre)
  end

  def eliminar_contacto(nombre : String) : Contacto?
    contacto = @arbol.eliminar_por_nombre(nombre)
    guardar_en_csv if contacto
    contacto
  end

  def buscar_por_mes(mes : Int32) : Array(Contacto)
    if mes < 1 || mes > 12
      raise ArgumentError.new("El mes debe estar entre 1 y 12")
    end

    @arbol.buscar_por_mes(mes)
  end

  def listar_contactos : Array(Contacto)
    @arbol.listar_inorden
  end

  def guardar_en_csv(ruta : String = @archivo_csv) : String
    contenido = CSV.build do |csv|
      csv.row "Nombre", "Email", "Telefono", "Dia", "Mes"

      listar_contactos.each do |contacto|
        csv.row contacto.nombre, contacto.email, contacto.telefono, contacto.dia, contacto.mes
      end
    end

    File.write(ruta, contenido)
    @archivo_csv = ruta
    ruta
  end

  private def cargar_contactos : Void
    return unless File.exists?(@archivo_csv)

    contenido = File.read(@archivo_csv)
    csv = CSV.new(contenido, headers: true)

    while csv.next
      nombre = csv["Nombre"]?
      email = csv["Email"]?
      telefono = csv["Telefono"]?
      dia_texto = csv["Dia"]?
      mes_texto = csv["Mes"]?

      next unless nombre && email && telefono && dia_texto && mes_texto

      begin
        contacto = Contacto.new(nombre, email, telefono, dia_texto.to_i, mes_texto.to_i)
        @arbol.insertar(contacto)
      rescue
        # Ignorar filas inválidas
      end
    end
  rescue
    # Ignorar errores al leer el archivo CSV
  end
end
