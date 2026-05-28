require "spec"
require "./src/contacto"
require "./src/contacto_bst"

describe ContactoBST do
  describe "#listar_inorden" do
    it "retorna un arreglo vacío cuando el árbol está vacío" do
      bst = ContactoBST.new
      bst.listar_inorden.should eq([] of Contacto)
    end

    it "devuelve los contactos ordenados alfabéticamente" do
      bst = ContactoBST.new
      ana = Contacto.new("Ana", "ana@example.com", "+34 111", 1, 1)
      bea = Contacto.new("Bea", "bea@example.com", "+34 222", 2, 2)
      carlos = Contacto.new("Carlos", "carlos@example.com", "+34 333", 3, 3)
      david = Contacto.new("David", "david@example.com", "+34 444", 4, 4)

      # Insertar en orden distinto para crear subárboles
      bst.insertar(carlos)
      bst.insertar(david)
      bst.insertar(ana)
      bst.insertar(bea)

      nombres = bst.listar_inorden.map(&.nombre)
      nombres.should eq(["Ana", "Bea", "Carlos", "David"])
    end

    it "recorre todos los nodos en subárboles izquierdos y derechos" do
      bst = ContactoBST.new
      contactos = [
        Contacto.new("Lucas", "lucas@example.com", "+34 101", 5, 5),
        Contacto.new("Ana", "ana@example.com", "+34 202", 6, 6),
        Contacto.new("Zoe", "zoe@example.com", "+34 303", 7, 7),
        Contacto.new("David", "david@example.com", "+34 404", 8, 8),
        Contacto.new("Bea", "bea@example.com", "+34 505", 9, 9)
      ]

      contactos.each do |contacto|
        bst.insertar(contacto)
      end

      orden_esperado = ["Ana", "Bea", "David", "Lucas", "Zoe"]
      resultados = bst.listar_inorden.map(&.nombre)

      resultados.should eq(orden_esperado)
      resultados.size.should eq(contactos.size)
    end
  end
end
