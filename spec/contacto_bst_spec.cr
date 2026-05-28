require "spec"
require "../src/contacto_bst"

describe ContactoBST do
  describe "#insertar" do
    it "asigna la raíz al insertar en un árbol vacío" do
      arbol = ContactoBST.new
      contacto = Contacto.new("Luis", "luis@example.com", "+34 111", 10, 5)

      arbol.insertar(contacto)

      arbol.buscar_por_nombre("Luis").should eq(contacto)
    end

    it "inserta contactos en los subárboles izquierdo y derecho" do
      arbol = ContactoBST.new
      luis = Contacto.new("Luis", "luis@example.com", "+34 111", 10, 5)
      ana = Contacto.new("Ana", "ana@example.com", "+34 222", 11, 6)
      pedro = Contacto.new("Pedro", "pedro@example.com", "+34 333", 12, 7)

      arbol.insertar(luis)
      arbol.insertar(ana)
      arbol.insertar(pedro)

      arbol.buscar_por_nombre("Ana").should eq(ana)
      arbol.buscar_por_nombre("Pedro").should eq(pedro)
    end

    it "inserta de forma recursiva en niveles inferiores" do
      arbol = ContactoBST.new
      luis = Contacto.new("Luis", "luis@example.com", "+34 111", 10, 5)
      ana = Contacto.new("Ana", "ana@example.com", "+34 222", 11, 6)
      abel = Contacto.new("Abel", "abel@example.com", "+34 444", 13, 8)
      pedro = Contacto.new("Pedro", "pedro@example.com", "+34 333", 12, 7)
      zoe = Contacto.new("Zoe", "zoe@example.com", "+34 555", 14, 9)

      arbol.insertar(luis)
      arbol.insertar(ana)
      arbol.insertar(abel)
      arbol.insertar(pedro)
      arbol.insertar(zoe)

      nombres = arbol.listar_inorden.map(&.nombre)
      nombres.should eq(["Abel", "Ana", "Luis", "Pedro", "Zoe"])
    end
  end
end