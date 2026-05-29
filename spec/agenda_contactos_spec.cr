require "spec"
require "../src/agenda_contactos"

describe AgendaContactos do
  describe "#eliminar_contacto" do
    it "elimina un contacto existente" do
      agenda = AgendaContactos.new
      agenda.agregar_contacto("Ana", "ana@example.com", "+34 111", 11, 6)
      agenda.agregar_contacto("Luis", "luis@example.com", "+34 222", 10, 5)

      agenda.eliminar_contacto("Ana").should be_true
      agenda.buscar_contacto("Ana").should be_nil
      agenda.listar_contactos.map(&.nombre).should eq(["Luis"])
    end
  end

  describe "#agregar_contacto" do
    it "agrega contactos y los lista en orden" do
      agenda = AgendaContactos.new
      agenda.agregar_contacto("Luis", "luis@example.com", "+34 111", 10, 5)
      agenda.agregar_contacto("Ana", "ana@example.com", "+34 222", 11, 6)
      agenda.agregar_contacto("Pedro", "pedro@example.com", "+34 333", 12, 7)

      agenda.listar_contactos.map(&.nombre).should eq(["Ana", "Luis", "Pedro"])
    end

    it "no permite duplicados por nombre" do
      agenda = AgendaContactos.new
      agenda.agregar_contacto("Ana", "ana@example.com", "+34 111", 11, 6)

      expect_raises(ArgumentError, "Ya existe un contacto con ese nombre") do
        agenda.agregar_contacto("Ana", "otro@example.com", "+34 999", 1, 1)
      end
    end
  end

  describe "#cargar_desde_csv" do
    it "carga contactos válidos desde archivo" do
      agenda = AgendaContactos.new
      ruta = "contactos_carga_prueba.csv"

      begin
        File.write(ruta, "Ana,ana@example.com,+34 111,11,6\nLuis,luis@example.com,+34 222,10,5\n")

        agenda.cargar_desde_csv(ruta)

        agenda.listar_contactos.map(&.nombre).should eq(["Ana", "Luis"])
      ensure
        File.delete(ruta) if File.exists?(ruta)
      end
    end

    it "falla si en CSV hay un nombre duplicado" do
      agenda = AgendaContactos.new
      ruta = "contactos_duplicados_prueba.csv"

      begin
        File.write(ruta, "Ana,ana@example.com,+34 111,11,6\nAna,ana2@example.com,+34 222,10,5\n")

        expect_raises(ArgumentError, "Ya existe un contacto con ese nombre: Ana") do
          agenda.cargar_desde_csv(ruta)
        end
      ensure
        File.delete(ruta) if File.exists?(ruta)
      end
    end
  end
end
