
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

  # Construye un contacto a partir de una línea CSV con 5 valores.
  def self.from_csv_line(linea : String) : Contacto
    campos = linea.chomp.split(",").map(&.strip)
    if campos.size != 5
      raise ArgumentError.new("Línea CSV inválida: se esperaban 5 campos")
    end

    nombre, email, telefono, dia_str, mes_str = campos
    Contacto.new(nombre, email, telefono, dia_str.to_i, mes_str.to_i)
  end

  # Obtener los días máximos de un mes
  # Retorna: 31, 30, o 29 según el mes
  private def dias_max_del_mes(mes : Int32) : Int32
    case mes
    when 1, 3, 5, 7, 8, 10, 12  # Enero, Marzo, Mayo, Julio, Agosto, Octubre, Diciembre
      31
    when 4, 6, 9, 11             # Abril, Junio, Septiembre, Noviembre
      30
    when 2                        # Febrero (máximo 29 en año bisiesto)
      29
    else
      0
    end
  end

  # Validación interna de la fecha
  # Verifica que día y mes sean válidos, considerando días por mes
  private def validar_fecha
    if @mes < 1 || @mes > 12
      raise ArgumentError.new("El mes debe estar entre 1 y 12")
    end
    
    dias_max = dias_max_del_mes(@mes)
    if @dia < 1 || @dia > dias_max
      raise ArgumentError.new("El día debe estar entre 1 y #{dias_max} para el mes #{@mes}")
    end
  end

  # Obtener fecha de cumpleaños 
  # Formato: dd/mm
  def fecha_cumpleanos : String
    "%02d/%02d" % [@dia, @mes]
  end

  # Modificar solo el día del cumpleaños
  def dia=(valor : Int32)
    if valor < 1 || valor > dias_max_del_mes(@mes)
      raise ArgumentError.new("El día debe estar entre 1 y #{dias_max_del_mes(@mes)} para el mes #{@mes}")
    end
    @dia = valor
  end

  # Modificar solo el mes del cumpleaños
  def mes=(valor : Int32)
    if valor < 1 || valor > 12
      raise ArgumentError.new("El mes debe estar entre 1 y 12")
    end
    # Validar que el día actual sea válido para el nuevo mes
    if @dia > dias_max_del_mes(valor)
      raise ArgumentError.new("El día #{@dia} no es válido para el mes #{valor}. El mes #{valor} solo tiene #{dias_max_del_mes(valor)} días")
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

  # Comparación por nombre para busquedas 
  # Retorna: -1, 0 o 1 según comparación alfabética
  def <=>(otro : Contacto) : Int32
    @nombre.downcase <=> otro.nombre.downcase
  end

  # Igualdad basada en nombre 
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
    @mes >= 1 && @mes <= 12 &&
    @dia >= 1 && @dia <= dias_max_del_mes(@mes)
  end
end
