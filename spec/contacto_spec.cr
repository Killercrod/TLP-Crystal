require "spec"
require "./src/contacto"

describe Contacto do
  describe "#initialize" do
    it "crea un contacto con todos los atributos" do
      contacto = Contacto.new("Juan Pérez", "juan@example.com", "+34 123456789", 15, 3)
      
      contacto.nombre.should eq("Juan Pérez")
      contacto.email.should eq("juan@example.com")
      contacto.telefono.should eq("+34 123456789")
      contacto.dia.should eq(15)
      contacto.mes.should eq(3)
    end

    it "lanza error si el día es inválido" do
      expect_raises(ArgumentError) do
        Contacto.new("Juan", "juan@example.com", "+34 123", 0, 5)
      end
      
      expect_raises(ArgumentError) do
        Contacto.new("Juan", "juan@example.com", "+34 123", 32, 5)
      end
    end

    it "lanza error si el día es inválido para el mes" do
      expect_raises(ArgumentError) do
        # Febrero no puede tener 30 días
        Contacto.new("Juan", "juan@example.com", "+34 123", 30, 2)
      end
      
      expect_raises(ArgumentError) do
        # Abril solo tiene 30 días
        Contacto.new("Juan", "juan@example.com", "+34 123", 31, 4)
      end

      expect_raises(ArgumentError) do
        # Junio solo tiene 30 días
        Contacto.new("Juan", "juan@example.com", "+34 123", 31, 6)
      end

      expect_raises(ArgumentError) do
        # Septiembre solo tiene 30 días
        Contacto.new("Juan", "juan@example.com", "+34 123", 31, 9)
      end

      expect_raises(ArgumentError) do
        # Noviembre solo tiene 30 días
        Contacto.new("Juan", "juan@example.com", "+34 123", 31, 11)
      end
    end
  end

  describe "#fecha_cumpleanos" do
    it "retorna la fecha formateada como dd/mm" do
      contacto = Contacto.new("Ana", "ana@example.com", "+34 456", 5, 6)
      contacto.fecha_cumpleanos.should eq("05/06")
    end

    it "formatea correctamente con ceros a la izquierda" do
      contacto = Contacto.new("Bob", "bob@example.com", "+34 789", 1, 1)
      contacto.fecha_cumpleanos.should eq("01/01")
    end
  end

  describe "#dia= y #mes=" do
    it "permite modificar el día" do
      contacto = Contacto.new("Maria", "maria@example.com", "+34 111", 10, 5)
      contacto.dia = 20
      contacto.dia.should eq(20)
    end

    it "permite modificar el mes" do
      contacto = Contacto.new("Carlos", "carlos@example.com", "+34 222", 15, 5)
      contacto.mes = 12
      contacto.mes.should eq(12)
    end

    it "valida el nuevo día según el mes" do
      # Contacto con día 30 en mes de 31 días
      contacto = Contacto.new("Laura", "laura@example.com", "+34 333", 30, 1)
      contacto.dia = 31  # Enero tiene 31 días
      contacto.dia.should eq(31)

      expect_raises(ArgumentError) do
        # No puede cambiar a día 31 en febrero
        contacto_feb = Contacto.new("Laura", "laura@example.com", "+34 333", 15, 2)
        contacto_feb.dia = 31
      end

      expect_raises(ArgumentError) do
        # No puede cambiar a día 31 en abril (solo 30)
        contacto_abr = Contacto.new("Laura", "laura@example.com", "+34 333", 15, 4)
        contacto_abr.dia = 31
      end
    end

    it "valida que el mes nuevo sea compatible con el día actual" do
      # Contacto con día 31 en mes de 31 días
      contacto = Contacto.new("Carlos", "carlos@example.com", "+34 222", 31, 1)
      
      # Puede cambiar a otro mes con 31 días
      contacto.mes = 12
      contacto.mes.should eq(12)

      # Pero no puede cambiar a un mes con menos días
      expect_raises(ArgumentError) do
        contacto.mes = 4  # Abril solo tiene 30 días
      end

      expect_raises(ArgumentError) do
        contacto.mes = 2  # Febrero solo tiene 29 días
      end
    end
  end

  describe "#to_s" do
    it "retorna la información completa formateada" do
      contacto = Contacto.new("Juan Pérez", "juan@example.com", "+34 123456789", 15, 3)
      salida = contacto.to_s
      
      salida.should contain("Juan Pérez")
      salida.should contain("juan@example.com")
      salida.should contain("+34 123456789")
      salida.should contain("15/03")
    end
  end

  describe "#to_s_corto" do
    it "retorna solo nombre y teléfono" do
      contacto = Contacto.new("Ana García", "ana@example.com", "+34 987654321", 5, 6)
      salida = contacto.to_s_corto
      
      salida.should eq("Ana García | +34 987654321")
    end
  end

  describe "#to_s_detallado" do
    it "retorna información multilinea formateada" do
      contacto = Contacto.new("Bob", "bob@example.com", "+34 555", 25, 12)
      salida = contacto.to_s_detallado
      
      salida.should contain("Nombre:")
      salida.should contain("Bob")
      salida.should contain("Email:")
      salida.should contain("Teléfono:")
      salida.should contain("Cumpleaños:")
      salida.should contain("25/12")
    end
  end

  describe "#<=>" do
    it "compara contactos alfabéticamente por nombre" do
      ana = Contacto.new("Ana", "ana@example.com", "+34 111", 5, 5)
      beto = Contacto.new("Beto", "beto@example.com", "+34 222", 10, 10)
      
      (ana <=> beto).should eq(-1)
      (beto <=> ana).should eq(1)
    end

    it "es case-insensitive" do
      ana_lower = Contacto.new("ana", "ana@example.com", "+34 111", 5, 5)
      ana_upper = Contacto.new("ANA", "ana2@example.com", "+34 222", 5, 5)
      
      (ana_lower <=> ana_upper).should eq(0)
    end
  end

  describe "#==" do
    it "compara por nombre ignorando mayúsculas" do
      contacto1 = Contacto.new("Juan", "juan@example.com", "+34 123", 15, 3)
      contacto2 = Contacto.new("juan", "juan2@example.com", "+34 456", 20, 6)
      contacto3 = Contacto.new("Pedro", "pedro@example.com", "+34 789", 25, 9)
      
      (contacto1 == contacto2).should be_true
      (contacto1 == contacto3).should be_false
    end
  end

  describe "#hash" do
    it "retorna el mismo hash para nombres iguales" do
      contacto1 = Contacto.new("Juan", "juan@example.com", "+34 123", 15, 3)
      contacto2 = Contacto.new("juan", "juan2@example.com", "+34 456", 20, 6)
      
      contacto1.hash.should eq(contacto2.hash)
    end
  end

  describe "#dup" do
    it "crea una copia del contacto" do
      original = Contacto.new("Maria", "maria@example.com", "+34 111", 10, 5)
      copia = original.dup
      
      copia.nombre.should eq(original.nombre)
      copia.email.should eq(original.email)
      copia.telefono.should eq(original.telefono)
      copia.dia.should eq(original.dia)
      copia.mes.should eq(original.mes)
    end

    it "la copia es independiente del original" do
      original = Contacto.new("Carlos", "carlos@example.com", "+34 222", 15, 6)
      copia = original.dup
      
      copia.nombre = "Nuevo Nombre"
      
      original.nombre.should eq("Carlos")
      copia.nombre.should eq("Nuevo Nombre")
    end
  end

  describe "#valido?" do
    it "retorna true para un contacto válido" do
      contacto = Contacto.new("Laura", "laura@example.com", "+34 333", 20, 7)
      contacto.valido?.should be_true
    end

    it "retorna true incluso después de modificaciones válidas" do
      contacto = Contacto.new("Rosa", "rosa@example.com", "+34 444", 15, 8)
      contacto.dia = 28
      contacto.mes = 12
      contacto.valido?.should be_true
    end

    it "valida correctamente días para meses de 31 días" do
      # Enero (31 días)
      contacto_ene = Contacto.new("Test", "test@example.com", "+34 123", 31, 1)
      contacto_ene.valido?.should be_true

      # Febrero - día 31 no es válido
      expect_raises(ArgumentError) do
        Contacto.new("Test", "test@example.com", "+34 123", 31, 2)
      end
    end

    it "valida correctamente días para meses de 30 días" do
      # Abril (30 días)
      contacto_abr = Contacto.new("Test", "test@example.com", "+34 123", 30, 4)
      contacto_abr.valido?.should be_true

      # Abril - día 31 no es válido
      expect_raises(ArgumentError) do
        Contacto.new("Test", "test@example.com", "+34 123", 31, 4)
      end
    end

    it "valida correctamente días para febrero" do
      # Febrero (máximo 29 días)
      contacto_feb = Contacto.new("Test", "test@example.com", "+34 123", 29, 2)
      contacto_feb.valido?.should be_true

      # Febrero - día 30 no es válido
      expect_raises(ArgumentError) do
        Contacto.new("Test", "test@example.com", "+34 123", 30, 2)
      end
    end
  end

  describe "propiedades modificables" do
    it "permite modificar nombre" do
      contacto = Contacto.new("Juan", "juan@example.com", "+34 123", 15, 3)
      contacto.nombre = "Pedro"
      contacto.nombre.should eq("Pedro")
    end

    it "permite modificar email" do
      contacto = Contacto.new("Juan", "juan@example.com", "+34 123", 15, 3)
      contacto.email = "nuevo@example.com"
      contacto.email.should eq("nuevo@example.com")
    end

    it "permite modificar teléfono" do
      contacto = Contacto.new("Juan", "juan@example.com", "+34 123", 15, 3)
      contacto.telefono = "+34 987654321"
      contacto.telefono.should eq("+34 987654321")
    end
  end
end
