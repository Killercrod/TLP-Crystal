require "spec"
require "file_utils"
require "../src/agenda_contactos"

describe AgendaContactos do
  it "carga contactos desde un archivo CSV y los inserta en el BST" do
    FileUtils.mkdir_p("tmp")
    ruta = "tmp/contactos_test.csv"

    File.open(ruta, "w") do |archivo|
      archivo.puts "Carlos,carlos@gmail.com,9999999999,14,5"
      archivo.puts "Laura,laura@gmail.com,8888888888,2,10"
      archivo.puts "Sofía,sofia@gmail.com,7777777777,30,12"
    end

    agenda = AgendaContactos.new
    agenda.cargar_desde_csv(ruta)

    nombres = agenda.listar_contactos.map(&.nombre)
    nombres.should eq(["Carlos", "Laura", "Sofía"])

    contacto = agenda.buscar_contacto("Laura")
    contacto.should_not be_nil
    contacto.not_nil!.email.should eq("laura@gmail.com")
    contacto.not_nil!.dia.should eq(2)
    contacto.not_nil!.mes.should eq(10)
  ensure
    File.delete(ruta) if ruta && File.exists?(ruta)
  end

  it "no falla con un archivo CSV vacío" do
    FileUtils.mkdir_p("tmp")
    ruta = "tmp/contactos_vacio.csv"
    File.open(ruta, "w") { |_archivo| }

    agenda = AgendaContactos.new
    agenda.cargar_desde_csv(ruta)

    agenda.listar_contactos.should eq([] of Contacto)
  ensure
    File.delete(ruta) if ruta && File.exists?(ruta)
  end
end
