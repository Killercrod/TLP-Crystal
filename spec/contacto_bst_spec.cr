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

  it "elimina una hoja sin romper el orden" do
    arbol = ContactoBST.new
    arbol.insertar Contacto.new("Carlos", "carlos@example.com", "555-1000", 10, 4)
    arbol.insertar Contacto.new("Ana", "ana@example.com", "555-2000", 11, 5)
    arbol.insertar Contacto.new("Pedro", "pedro@example.com", "555-3000", 12, 6)

    eliminado = arbol.eliminar_por_nombre("Ana")
    eliminado.should_not be_nil
    eliminado.not_nil!.nombre.should eq("Ana")
    arbol.listar_inorden.map(&.nombre).should eq(["Carlos", "Pedro"])
    arbol.buscar_por_nombre("Ana").should be_nil
  end

  it "elimina un nodo con un hijo y conserva el subárbol" do
    arbol = ContactoBST.new
    arbol.insertar Contacto.new("Luis", "luis@example.com", "555-4000", 1, 1)
    arbol.insertar Contacto.new("Ana", "ana@example.com", "555-5000", 2, 2)
    arbol.insertar Contacto.new("Beatriz", "beatriz@example.com", "555-6000", 3, 3)
    arbol.insertar Contacto.new("Zoe", "zoe@example.com", "555-7000", 4, 4)

    eliminado = arbol.eliminar_por_nombre("Ana")
    eliminado.should_not be_nil
    eliminado.not_nil!.nombre.should eq("Ana")
    arbol.listar_inorden.map(&.nombre).should eq(["Beatriz", "Luis", "Zoe"])
    arbol.buscar_por_nombre("Beatriz").should_not be_nil
  end

  it "elimina un nodo con dos hijos y mantiene ambos subárboles" do
    arbol = ContactoBST.new
    arbol.insertar Contacto.new("Luis", "luis@example.com", "555-8000", 5, 5)
    arbol.insertar Contacto.new("Ana", "ana@example.com", "555-9000", 6, 6)
    arbol.insertar Contacto.new("Pedro", "pedro@example.com", "555-0100", 7, 7)
    arbol.insertar Contacto.new("Marco", "marco@example.com", "555-0200", 8, 8)

    eliminado = arbol.eliminar_por_nombre("Luis")
    eliminado.should_not be_nil
    eliminado.not_nil!.nombre.should eq("Luis")
    arbol.listar_inorden.map(&.nombre).should eq(["Ana", "Marco", "Pedro"])
    arbol.buscar_por_nombre("Luis").should be_nil
    arbol.buscar_por_nombre("Ana").should_not be_nil
    arbol.buscar_por_nombre("Pedro").should_not be_nil
  end

  it "devuelve nil cuando el contacto no existe" do
    arbol = ContactoBST.new
    arbol.insertar Contacto.new("Carlos", "carlos@example.com", "555-1111", 9, 9)

    arbol.eliminar_por_nombre("Inexistente").should be_nil
    arbol.listar_inorden.map(&.nombre).should eq(["Carlos"])
  end
end
