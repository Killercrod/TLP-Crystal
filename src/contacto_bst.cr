# Árbol binario de búsqueda para `Contacto`
# Implementa inserción y búsqueda eficiente por nombre.

class NodoContacto
  property contacto : Contacto
  property izquierdo : NodoContacto?
  property derecho : NodoContacto?

  def initialize(@contacto : Contacto)
    @izquierdo = nil
    @derecho = nil
  end
end

class ContactoBST
  # Raíz del árbol
  @raiz : NodoContacto?

  def initialize
    @raiz = nil
  end

  # Insertar un contacto en el árbol.
  # Si el nombre ya existe, no lo duplica.
  # Comentario: la comparación se basa en `nombre.downcase` para mantener
  # consistencia con la clase `Contacto`.
  def insertar(contacto : Contacto)
    @raiz = insertar_rec(@raiz, contacto)
  end

  private def insertar_rec(nodo : NodoContacto?, contacto : Contacto) : NodoContacto
    # Si el nodo es nil, creamos un nuevo nodo con el contacto
    return NodoContacto.new(contacto) if nodo.nil?

    # Comparar nombres case-insensitive
    cmp = contacto.nombre.downcase <=> nodo.contacto.nombre.downcase

    if cmp < 0
      # El nuevo contacto va a la izquierda
      nodo.izquierdo = insertar_rec(nodo.izquierdo, contacto)
    elsif cmp > 0
      # Va a la derecha
      nodo.derecho = insertar_rec(nodo.derecho, contacto)
    else
      # Igual: ya existe un contacto con ese nombre. No duplicar.
      # Comentario: Si se desea actualizar datos en lugar de ignorar,
      # se podría asignar nodo.contacto = contacto aquí.
    end

    nodo
  end

  # Buscar contactos por mes de cumpleaños
# Retorna un arreglo con las coincidencias
# Ordenado por día de cumpleaños
def buscar_por_mes(mes : Int32) : Array(Contacto)
  resultados = Array(Contacto).new

  buscar_por_mes_rec(@raiz, mes, resultados)

  # Ordenar por día
  resultados.sort_by(&.dia)
end

# Recorrer el árbol completo buscando coincidencias
private def buscar_por_mes_rec(
  nodo : NodoContacto?,
  mes : Int32,
  resultados : Array(Contacto)
) : Void

  return if nodo.nil?

  # Recorrer izquierda
  buscar_por_mes_rec(nodo.izquierdo, mes, resultados)

  # Verificar coincidencia
  if nodo.contacto.mes == mes
    resultados << nodo.contacto
  end

  # Recorrer derecha
  buscar_por_mes_rec(nodo.derecho, mes, resultados)
end

  # Buscar por nombre (string).
  # Retorna el objeto Contacto si se encuentra, o nil si no existe.
  # Comentario: la búsqueda es recursiva y solo recorre la rama necesaria
  # comparando el nombre buscado con el del nodo actual.
  def buscar_por_nombre(nombre : String) : Contacto?
    buscar_rec(@raiz, nombre.downcase)
  end

  private def buscar_rec(nodo : NodoContacto?, nombre_minuscula : String) : Contacto?
    return nil if nodo.nil?

    # Comparar nombre buscado con el del nodo (case-insensitive)
    cmp = nombre_minuscula <=> nodo.contacto.nombre.downcase

    if cmp == 0
      # Encontrado: el nodo contiene el contacto buscado
      nodo.contacto
    elsif cmp < 0
      # Nombre buscado es menor -> buscar en subárbol izquierdo
      buscar_rec(nodo.izquierdo, nombre_minuscula)
    else
      # Nombre buscado es mayor -> buscar en subárbol derecho
      buscar_rec(nodo.derecho, nombre_minuscula)
    end
  end

  # Listado in-order (orden alfabético por nombre).
  # Comentario: útil para verificar estructura o exportar.
  def listar_inorden : Array(Contacto)
    resultado = Array(Contacto).new
    listar_rec(@raiz, resultado)
    resultado
  end

  # Eliminar un contacto por nombre (case-insensitive).
  # Retorna true si se eliminó un nodo, false si no se encontró.
  def eliminar(nombre : String) : Bool
    nuevo, eliminado = eliminar_rec(@raiz, nombre.downcase)
    @raiz = nuevo
    eliminado
  end

  private def eliminar_rec(nodo : NodoContacto?, nombre_minuscula : String) : Tuple(NodoContacto?, Bool)
    return {nil, false} if nodo.nil?

    cmp = nombre_minuscula <=> nodo.contacto.nombre.downcase

    if cmp < 0
      nuevo_izq, eliminado = eliminar_rec(nodo.izquierdo, nombre_minuscula)
      nodo.izquierdo = nuevo_izq
      return {nodo, eliminado}
    elsif cmp > 0
      nuevo_der, eliminado = eliminar_rec(nodo.derecho, nombre_minuscula)
      nodo.derecho = nuevo_der
      return {nodo, eliminado}
    else
      # Nodo a eliminar encontrado
      if nodo.izquierdo.nil? && nodo.derecho.nil?
        return {nil, true}
      elsif nodo.izquierdo.nil?
        return {nodo.derecho, true}
      elsif nodo.derecho.nil?
        return {nodo.izquierdo, true}
      else
        sucesor = min_node(nodo.derecho)
        nodo.contacto = sucesor.contacto
        nuevo_der, _ = eliminar_rec(nodo.derecho, sucesor.contacto.nombre.downcase)
        nodo.derecho = nuevo_der
        return {nodo, true}
      end
    end
  end

  private def min_node(nodo : NodoContacto) : NodoContacto
    actual = nodo
    while !actual.izquierdo.nil?
      actual = actual.izquierdo
    end

    actual
  end

  private def listar_rec(nodo : NodoContacto?, resultado : Array(Contacto)) : Void
    return if nodo.nil?
    listar_rec(nodo.izquierdo, resultado)
    resultado << nodo.contacto
    listar_rec(nodo.derecho, resultado)
  end
end

alias ArbolBST = ContactoBST
