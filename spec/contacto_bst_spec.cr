require "spec"
require "../src/contacto"
require "../src/contacto_bst"

describe ContactoBST do
  it "devuelve un arreglo vacío cuando el árbol está vacío" do
    arbol = ContactoBST.new
    arbol.listar_inorden.should eq([] of Contacto)
  end

  it "recorre todos los nodos en orden alfabético" do
    arbol = ContactoBST.new
    arbol.insertar Contacto.new("Carlos", "carlos@example.com", "555-1234", 10, 4)
    arbol.insertar Contacto.new("Ana", "ana@example.com", "555-5678", 22, 6)
    arbol.insertar Contacto.new("María", "maria@example.com", "555-9012", 5, 12)

    nombres = arbol.listar_inorden.map(&.nombre)
    nombres.should eq(["Ana", "Carlos", "María"])
  end

  it "funciona con subárboles y ordena correctamente" do
    arbol = ContactoBST.new
    arbol.insertar Contacto.new("Daniel", "daniel@example.com", "555-0001", 1, 1)
    arbol.insertar Contacto.new("Beatriz", "beatriz@example.com", "555-0002", 2, 2)
    arbol.insertar Contacto.new("Ernesto", "ernesto@example.com", "555-0003", 3, 3)
    arbol.insertar Contacto.new("Ana", "ana@example.com", "555-0004", 4, 4)
    arbol.insertar Contacto.new("Clara", "clara@example.com", "555-0005", 5, 5)

    nombres = arbol.listar_inorden.map(&.nombre)
    nombres.should eq(["Ana", "Beatriz", "Clara", "Daniel", "Ernesto"])
  end
end
