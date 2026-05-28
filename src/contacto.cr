# Entidad Principal del Sistema
# Representa un contacto en el catálogo
# Base de todo el sistema: BST, CSV, búsquedas, listados, modificaciones

class Contacto
  # Propiedades del contacto
  property nombre : String
  property email : String
  property telefono : String
  property dia : Int32      # 1-31
  property mes : Int32      # 1-12

  # Constructor
  # Crea un nuevo contacto con toda la información básica
  def initialize(
    @nombre : String,
    @email : String,
    @telefono : String,
    @dia : Int32,
    @mes : Int32
  )
    validar_fecha
  end

  # Validación interna de la fecha
  # Verifica que día y mes sean válidos
  private def validar_fecha
    if @dia < 1 || @dia > 31
      raise ArgumentError.new("El día debe estar entre 1 y 31")
    end
    
    if @mes < 1 || @mes > 12
      raise ArgumentError.new("El mes debe estar entre 1 y 12")
    end
  end

  # Obtener fecha de cumpleaños formateada como string
  # Formato: dd/mm
  def fecha_cumpleanos : String
    "%02d/%02d" % [@dia, @mes]
  end

  # Modificar solo el día del cumpleaños
  def dia=(valor : Int32)
    if valor < 1 || valor > 31
      raise ArgumentError.new("El día debe estar entre 1 y 31")
    end
    @dia = valor
  end

  # Modificar solo el mes del cumpleaños
  def mes=(valor : Int32)
    if valor < 1 || valor > 12
      raise ArgumentError.new("El mes debe estar entre 1 y 12")
    end
    @mes = valor
  end

  # Mostrar información completa del contacto
  # Formato: Nombre | Email | Teléfono | Cumpleaños (dd/mm)
  def to_s : String
    "#{@nombre} | #{@email} | #{@telefono} | #{fecha_cumpleanos}"
  end

  # Mostrar información en formato corto
  # Formato: Nombre | Teléfono
  def to_s_corto : String
    "#{@nombre} | #{@telefono}"
  end

  # Mostrar información detallada multilinea
  # Útil para consultas específicas
  def to_s_detallado : String
    <<-INFO
    Nombre:       #{@nombre}
    Email:        #{@email}
    Teléfono:     #{@telefono}
    Cumpleaños:   #{fecha_cumpleanos}
    INFO
  end

  # Comparación por nombre (para búsquedas y ordenamientos)
  # Retorna: -1, 0 o 1 según comparación alfabética
  def <=>(otro : Contacto) : Int32
    @nombre.downcase <=> otro.nombre.downcase
  end

  # Igualdad basada en nombre (case-insensitive)
  def ==(otro : Contacto) : Bool
    @nombre.downcase == otro.nombre.downcase
  end

  # Hash para usar en colecciones
  def hash : UInt64
    @nombre.downcase.hash
  end

  # Retorna una copia profunda del contacto
  def dup : Contacto
    Contacto.new(@nombre, @email, @telefono, @dia, @mes)
  end

  # Verificar si el contacto contiene información válida
  def valido? : Bool
    !@nombre.empty? && 
    !@email.empty? && 
    !@telefono.empty? &&
    @dia >= 1 && @dia <= 31 &&
    @mes >= 1 && @mes <= 12
  end
end
