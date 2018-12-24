Shoes.app  :width => 490, :height => 280, :title => "Estoy en la Piedra" do
    require_relative 'game'
    background "#DFA"

    @player = nil
    @ai = nil

    flow() do
        style(:margin_left => '9%', margin_top => '25%')
        @player = image "images/papel.png"
        @ai = image "images/piedra.png"
    end


    flow() do
        style(:margin_left => '42%', margin_top => '25%')
        button "Play!" do
                #para "Seleccione una estrategia"
            flow() do
                estrategia = ask("Seleccione una estrategia\nc : Copiar\np : Pensar\ns : Sesgada\nu : Uniforme")
                n_partida = ask("Seleccione el numero de partidas que quiere jugar").to_i
            
                puts estrategia
                puts "que es estooooooooooooooooo\n"
                case estrategia
                    when "c", "C"
                        s1 =  Copiar.new
                    when "P", "p"
                        s1 = Pensar.new
                    when "s", "S"
                        s1 = Sesgada.new({:Piedra => 5, :Tijeras => 2, :Spock => 3, :Lagarto => 2, :Papel => 2})
                    when "u", "U"
                        s1 = Uniforme.new([:Piedra, :Tijeras, :Papel, :Spock, :Lagarto])
                end

                puts "Saliiiiii de la creacion"
                ganada1 = 0
                ganada2 = 0

                jugada1 = Piedra.new
                jugada2 = Piedra.new
                for x in (1..n_partida)
                    jugada1 = s1.prox(jugada2)
                    opcion = ask("Seleccione una jugada:\nt : Tijera\nr : Piedra\np : Papel\ns : Spock\nl : Lagarto\n  ")
                    case opcion
                        when "t"
                            jugada2 = Tijeras.new
                        when "p"
                            jugada2 = Papel.new
                        when "r"
                            jugada2 = Piedra.new
                        when "s"
                            jugada2 = Spock.new
                        when "l"
                            jugada2 = Lagarto.new
                    end


                    results = jugada1.puntos(jugada2)

                    ganada1 = ganada1 + results[0]
                    ganada2 = ganada2 + results[1]

                    puts "11111111111111111"

                    if results[0] == 1
                        mensaje = "Perdiste esta ronda. Tu oponente tenia " + jugada1.class.to_s 
                        alert( mensaje)
                    elsif results[1] == 1
                        mensaje = "Ganaste esta ronda. Tu oponente tenia " + jugada1.class.to_s + "\nNada mal para alguien sin talento"
                        alert( mensaje)
                    else
                        mensaje = "Perdiste esta ronda. Tu oponente tenia " + jugada1.class.to_s + "\nLas grandes mentes piensan igual"
                        alert( mensaje)
                    end


                end


                if ganada1 > ganada2
                    para "Perdiste en este duelo"
                    alert("Perdiste en este duelo")
                else
                    para "Ganaste este duelo. Solo porque creo que estoy enfermo"
                    alert("Ganaste este duelo. Solo porque creo que estoy enfermo" )
                end

            end
        end
    end
end