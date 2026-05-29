require "spec"
require "../src/agenda_contactos"

describe AgendaContactos do
  describe "#guardar_en_csv" do
    it "guarda los contactos en orden inorder y sobrescribe el archivo" do
      agenda = AgendaContactos.new
      agenda.agregar_contacto("Luis", "luis@example.com", "+34 111", 10, 5)
      agenda.agregar_contacto("Ana", "ana@example.com", "+34 222", 11, 6)
      agenda.agregar_contacto("Pedro", "pedro@example.com", "+34 333", 12, 7)

      ruta = "contactos_prueba.csv"
      begin
        File.write(ruta, "contenido viejo\n")

        agenda.guardar_en_csv(ruta).should eq(ruta)

        contenido = File.read(ruta)
        contenido.should eq("Nombre,Email,Telefono,Dia,Mes\nAna,ana@example.com,+34 222,11,6\nLuis,luis@example.com,+34 111,10,5\nPedro,pedro@example.com,+34 333,12,7\n")
      ensure
        File.delete(ruta) if File.exists?(ruta)
      end
    end

    it "escapa valores con comas o comillas" do
      agenda = AgendaContactos.new
      agenda.agregar_contacto("Juan, Jr.", "juan@example.com", "Tel \"1\"", 1, 1)

      ruta = "contactos_escapados.csv"
      begin
        agenda.guardar_en_csv(ruta)

        contenido = File.read(ruta)
        contenido.should contain("\"Juan, Jr.\"")
        contenido.should contain("\"Tel \"\"1\"\"\"")
      ensure
        File.delete(ruta) if File.exists?(ruta)
      end
    end
  end
end