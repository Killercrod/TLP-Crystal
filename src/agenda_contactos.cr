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
    guardar_contacto_csv(contacto)
    contacto
  end

  def buscar_contacto(nombre : String) : Contacto?
    @arbol.buscar_por_nombre(nombre)
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

  private def cargar_contactos : Void
    return unless File.exists?(@archivo_csv)

    File.open(@archivo_csv, "r") do |file|
      first_line = true
      file.each_line do |line|
        next if first_line
        first_line = false

        fields = line.chomp.split(",")
        next if fields.size < 5

        nombre = fields[0].to_s
        email = fields[1].to_s
        telefono = fields[2].to_s
        dia = fields[3].to_i
        mes = fields[4].to_i

        begin
          contacto = Contacto.new(nombre, email, telefono, dia, mes)
          @arbol.insertar(contacto)
        rescue ex
          # Ignorar filas inválidas
        end
      end
    end
  rescue ex
    # Ignorar errores al leer el archivo CSV
  end

  private def guardar_contacto_csv(contacto : Contacto) : Void
    new_file = !File.exists?(@archivo_csv)

    File.open(@archivo_csv, "a+") do |file|
      if new_file
        file.puts "Nombre,Email,Telefono,Dia,Mes"
      end

      file.puts escapar_csv(contacto.nombre, contacto.email, contacto.telefono, contacto.dia, contacto.mes)
    end
  end

  private def escapar_csv(nombre : String, email : String, telefono : String, dia : Int32, mes : Int32) : String
    [nombre, email, telefono, dia.to_s, mes.to_s].map do |campo|
      if campo.includes?(",") || campo.includes?("\"") || campo.includes?("\n")
        "\"#{campo.gsub("\"", "\"\"")}\""
      else
        campo
      end
    end.join(",")
  end
end