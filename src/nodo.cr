# Estructura Nodo para el Árbol Binario de Búsqueda
class Nodo
  property contacto : Contacto
  property izquierda : Nodo?
  property derecha : Nodo?

  def initialize(@contacto : Contacto)
    @izquierda = nil
    @derecha = nil
  end
end