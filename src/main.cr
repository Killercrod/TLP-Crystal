require "./contacto"
require "./contacto_bst"
require "./agenda_contactos" #clase que manejara la logica de negocio

agenda = AgendaContactos.new

loop do
puts "\n===== AGENDA DE CONTACTOS ====="
puts "1. Agregar contacto"
puts "2. Buscar contacto"
puts "3. Eliminar contacto"
puts "4. Buscar por mes"
puts "5. Listar contactos"
puts "6. Salir"
print "Seleccione una opción: "

opcion = gets.to_s.chomp

case opcion

when "1"
puts "\n--- Agregar contacto ---"
print "Nombre: "
nombre = gets.to_s.chomp

print "Email: "
email = gets.to_s.chomp

print "Teléfono: "
telefono = gets.to_s.chomp

print "Día cumpleaños: "
dia = gets.to_s.chomp.to_i

print "Mes cumpleaños: "
mes = gets.to_s.chomp.to_i

begin
  agenda.agregar_contacto(nombre, email, telefono, dia, mes)
  puts "Contacto agregado correctamente."
rescue ex
  puts "Error: #{ex.message}"
end

print "Nombre: "
nombre = gets.to_s.chomp

print "Email: "
email = gets.to_s.chomp

print "Teléfono: "
telefono = gets.to_s.chomp

print "Día cumpleaños: "
dia = gets.to_s.chomp.to_i

print "Mes cumpleaños: "
mes = gets.to_s.chomp.to_i

begin
  agenda.agregar_contacto(nombre, email, telefono, dia, mes)
  puts "Contacto agregado correctamente."
rescue ex
  puts "Error: #{ex.message}"
end

when "2"
puts "\n--- Buscar contacto ---"
print "Nombre a buscar: "
nombre = gets.to_s.chomp

contacto = agenda.buscar_contacto(nombre)

if contacto
  puts contacto.to_s_detallado
else
  puts "Contacto no encontrado."
end

print "Nombre a buscar: "
nombre = gets.to_s.chomp

contacto = agenda.buscar_contacto(nombre)

if contacto
  puts contacto.to_s_detallado
else
  puts "Contacto no encontrado."
end

when "3"
puts "\nEliminar contacto aún no implementado."

print "Nombre a eliminar: "
nombre = gets.to_s.chomp

if agenda.eliminar_contacto(nombre)
  puts "Contacto eliminado correctamente."
else
  puts "Contacto no encontrado."
end

when "4"
puts "\n--- Buscar por mes ---"
print "Mes: "
mes = gets.to_s.chomp.to_i

begin
  resultados = agenda.buscar_por_mes(mes)

  if resultados.empty?
    puts "No hay contactos en ese mes."
  else
    puts "\nCumpleaños encontrados:"
    resultados.each do |contacto|
      puts "#{contacto.nombre} - #{contacto.fecha_cumpleanos}"
    end
  end

rescue ex
  puts "Error: #{ex.message}"
end

print "Mes: "
mes = gets.to_s.chomp.to_i

begin
  resultados = agenda.buscar_por_mes(mes)

  if resultados.empty?
    puts "No hay contactos en ese mes."
  else
    puts "\nCumpleaños encontrados:"
    resultados.each do |contacto|
      puts "#{contacto.nombre} - #{contacto.fecha_cumpleanos}"
    end
  end

rescue ex
  puts "Error: #{ex.message}"
end

when "5"
puts "\n--- Lista de contactos ---"

contactos = agenda.listar_contactos

if contactos.empty?
  puts "No hay contactos registrados."
else
  contactos.each do |contacto|
    puts contacto.to_s
  end
end

when "6"
puts "\nSaliendo del programa..."
break

else
puts "\nOpción inválida."
end
end
