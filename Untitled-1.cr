
# Estructura Nodo para el Árbol Binario de Búsqueda
class Nodo
  property contacto : Contacto # Almacena Contacto
  property izquierda : Nodo | Nil
  property derecha : Nodo | Nil

  def initialize(@contacto)
    @izquierda = nil #Apunta al hijo izq
    @derecha = nil #Apunta al hijo der
    # Ambos apuntadores pueden ser nul
  end
end
