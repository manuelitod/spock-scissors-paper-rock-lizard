class Jugada

    @pierde = []
    def puntos(j)
        if j.is_a? Jugada
            if self.class.pierde.include? j.class.name
                return [0, 1]
            elsif j.class.name.eql? self.class.name
                return [0, 0]
            else
                return [1, 0]
            end
        else
            puts "J no es una jugada válida"
        end
    end

    class << self
        attr_accessor :pierde
    end

end

class Piedra < Jugada

    @pierde = ["Papel", "Spock"]

    def to_s
        puts "Piedra"
    end

end

class Papel < Jugada

    @pierde = ["Lagarto", "Tijera"]

    def to_s
        puts "Papel"
    end
end

class Tijeras < Jugada

    attr_accessor :pierde
    @pierde = ["Piedra", "Spock"]

    def to_s
        puts "Tijera"
    end

    def pierde
        @pierde
    end
end

class Lagarto < Jugada
    attr_accessor   :pierde
    @pierde = ["Piedra", "Tijera"]

    def to_s
        puts "Lagarto"
    end
end

class Spock < Jugada
    attr_accessor :pierde
    @pierde = ["Papel", "Lagarto"]

    def to_s
        puts "Spock"
    end
end


class Estrategia
    
    def prox(j)

    end
end

class Uniforme < Estrategia

    def initialize(jugadas)
        @arreglo = jugadas
    end

    def prox(j)
        return @arreglo[rand(@arreglo.length)]
    end

    def to_s
        "Uniforme con : #{@arreglo}"   
    end

    def reset 
    end
end

class Manual < Estrategia

    def to_s
        "Manual"
    end
end

class Sesgada < Estrategia

    attr_accessor :probabilidad, :yaJugadas, :numeroJugadas

    def initialize(hash)
        if hash.class == Hash
            if hash.length == 0
                puts "El diccionario debe tener al menos algo"
                return
            end


            @suma = sumarArreglo(hash.values)
            @llaves = hash.keys

            #TRansformamos Symbol to Classes
            for x in 0..(@llaves.length-1)
                @llaves[x] = fromSymbolToClass( @llaves[x] )
            end

            

            @arreglo = hash.values
            @numeroJugadas = 0
            @probabilidad = crearProbabilidad(@suma, @arreglo)
            @jugadas = [0] * @arreglo.length
            @yaJugadas = [0] * @arreglo.length

            if @suma == -1
                puts 'Error en el diccionario. Valores no numericos'
                return
            end

            
        else
            puts 'Error: No diccionario pasado como parametro'
        end
    end

    def reset
        @yaJugadas = [0] * @arreglo.length
        @jugadas = [0] * @arreglo.length
        @numeroJugadas = 0
    end

    def prox(j)
        i = rand(@arreglo.length)
        #Chequea que la probabilidad sea menor de la ya dada
        while @probabilidad[i] < @yaJugadas[i]
            puts "next"
            i = (i + 1) % @arreglo.length
        end

        @numeroJugadas = @numeroJugadas +1
        @jugadas[i] = @jugadas[i] + 1


        @yaJugadas = crearProbabilidad(@numeroJugadas, @jugadas)



        #Chequea que en la proxima iteracion haya al menos una posibilidad
        if !hayPosibilidades(@probabilidad, @yaJugadas) 
            puts "reset"
            self.reset
        end


        return @llaves[i]
    end




end

def hayPosibilidades(probabilidad, actual)
    for x in 0..(probabilidad.length-1)
        if probabilidad[x] > actual[x]
            return true
        end
    end
    return false
end

def sumarArreglo(arreglo)
    x = 0
    arreglo.each do |y|
        if y.is_a? Integer
            x = x + y
        else
            return -1
        end
    end
    return x
end

def crearProbabilidad(suma, arreglo)
    flotante = suma.to_f
    arreglo_aux = [0] * arreglo.length

    for x in 0..(arreglo.length-1)
        arreglo_aux[x] = arreglo[x] / flotante
    end
    return arreglo_aux
end



def fromSymbolToClass(symbol)
    if symbol == :Tijeras
        return Tijeras
    elsif symbol == :Piedra
        return Piedra
    elsif symbol == :Lagarto
        return Lagarto
    elsif symbol == :Spock
        return Spock
    elsif symbol == :Papel 
        return Papel
    end
end