#Clase Jugada que representa una de las cinco formas de jugar
class Jugada

    @pierde = []
    @imagen = nil
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
        attr_accessor :pierde, :imagen
    end

end

#Clase piedra que representa la jugada piedra
class Piedra < Jugada

    attr_accessor :pierde, :imagen
    @pierde = ["Papel", "Spock"]
    @imagen = "images/papel.png"



    def to_s
        return "Piedra"
    end

end

#Clase papel que representa la jugada papel
class Papel < Jugada

    @pierde = ["Lagarto", "Tijeras"]
    @imagen = "images/papel.png"

    attr_accessor :pierde, :imagen

    def to_s
        return "Papel"
    end
end

#Clase tijeras que representa la jugada Tijeras
class Tijeras < Jugada

    attr_accessor :pierde, :imagen
    @pierde = ["Piedra", "Spock"]
    @imagen = "images/tijeras.png"



    def to_s
        puts "Tijeras"
    end

    def pierde
        @pierde
    end
end

#Clase lagarto que representa la jugada lagarto
class Lagarto < Jugada

    @pierde = ["Piedra", "Tijeras"]
    @imagen = "images/lizard.png"

    attr_accessor :pierde, :imagen

    def to_s
        puts "Lagarto"
    end
end

#Clase spock que representa la jugada spock
class Spock < Jugada

    @pierde = ["Papel", "Lagarto"]
    @imagen = "images/spock.png"

    attr_accessor :pierde, :imagen

    def to_s
        puts "Spock"
    end
end

#Clase estrategia que representa el modo de pensar de la computadora al momento
#de generar los resultados
class Estrategia
    
    @random = Random.new(42)

    attr_accessor :random

end

# las salidas se hacen de manera uniforme
class Uniforme < Estrategia

    attr_accessor :random

    def initialize(jugadas)
        for x in (0..jugadas.length-1)
            jugadas[x] = fromSymbolToClass(jugadas[x])
        end
        @arreglo = jugadas
        @random = Random.new(42)
    end

    def prox(j)
        return @arreglo[@random.rand(@arreglo.length)]
    end

    def to_s
        "Uniforme con : #{@arreglo}"   
    end

    def reset 
        @random = Random.new(42)
    end
end

# LAs salidas se crean de manera sesgada dependiendo de la probabilidad deseada
class Sesgada < Estrategia

    attr_accessor :probabilidad, :yaJugadas, :numeroJugadas, :random

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

            @random = Random.new(42)
            
        else
            puts 'Error: No diccionario pasado como parametro'
        end
    end

    #resetea todo
    def reset
        @yaJugadas = [0] * @arreglo.length
        @jugadas = [0] * @arreglo.length
        @numeroJugadas = 0
        @random = Random.new(42)
    end

    #Devuelve una jugada
    def prox(j)
        i = @random.rand(@arreglo.length)
        #Chequea que la probabilidad sea menor de la ya dada
        while @probabilidad[i] < @yaJugadas[i]
            #puts "next"
            i = (i + 1) % @arreglo.length
        end

        @numeroJugadas = @numeroJugadas +1
        @jugadas[i] = @jugadas[i] + 1


        @yaJugadas = crearProbabilidad(@numeroJugadas, @jugadas)



        #Chequea que en la proxima iteracion haya al menos una posibilidad
        if !hayPosibilidades(@probabilidad, @yaJugadas) 
            #puts "reset"
            self.reset
        end


        return @llaves[i]
    end

end


class Pensar < Estrategia
    @Papel=0
    @Tijeras = 0
    @Piedra = 0
    @Spock = 0
    @Lagarto = 0


    def to_s
        "Pensar"
    end

    def prox(m)
        if m.is_a? Jugada
            if m.class == Piedra
                @Piedra = @Piedra + 1
            elsif m.class == Tijeras
                @Tijeras = @Tijeras +1
            elsif m.class == Papel
                @Papel = @Papel +1
            elsif m.class == Spock
                @Spock = @Spock +1
            elsif m.class == Lagarto
                @Lagarto = @Lagarto +1
            end
        else
            puts "Parametro invalido. No es una jugada"
        end

        r = (@Piedra+@Tijeras+@Papel+@Spock+@Lagarto)-1
        if r == -1
            r = 0
        end
        n = Random.rand(0..r)
        if 0 <= n and n < @Piedra
            return Piedra.new
        elsif @Piedra <= n and n < @Piedra+@Papel
            return Papel.new
        elsif @Piedra+@Papel <= n and n < @Piedra+@Papel+@Tijeras
            return Tijeras.new
        elsif @Piedra+@Papel+@Tijeras <= n and n < @Piedra+@Papel+@Tijeras+@Lagarto
            return Lagarto.new
        elsif   @Piedra+@Papel+@Tijeras+@Lagarto <= n and n < r
            return Spock.new
        end
    end

    def reset
        @Papel=0
        @Tijeras = 0
        @Piedra = 0
        @Spock = 0
        @Lagarto = 0
    end

end

#Estrategia copiar. Que copia la jugada pasada
class Copiar < Estrategia
    def to_s
        "Copiar"
    end

    #Creo un booleano que me dice si la primera sucedio o no
    def initialize
        @primeraVez = true
    end

    attr_accessor @primeraVez

    # Da la proxima. la primera vez devuelve piedra
    def prox(j)
        if !@primeraVez
            if j.is_a? Jugada
                return j
            else
                puts "Parametro invalido"
            end
        else
            @primeraVez = false
            retrun Piedra.new
        end
    end

    def reset
        @primeraVez = true
    end

end


#Clase manual que solicita una entrada
class Manual < Estrategia

    @guiOn = false

    def to_s
        "Manual"
    end

    def prox(j)
        if !@guiOn
            begin
                puts "Introduce una jugada"
                STDOUT.flush
                @Jugada = gets.chomp
                @Jugada = fromSymbolToClass(@Jugada.to_sym)
                return @Jugada
            rescue => exception
                puts "Jugada inválida"
                prox(Piedra.new)
            end
        else
            if j.is_a? Jugada
                return j
            end
        end
    end

    def turnOnGui
        @guiOn = true
    end

    def reset
        return
    end
end

#Clase partida que representa una partida
class Partida

    attr_accessor :s1, :s2


    def initialize(hash)
        raise ArgumentError, 'Argumento tiene mas o menos de dos jugadores' unless hash.length==2

        hash.values.each do  |jugadores|
            if jugadores.is_a? Estrategia
                next
            else
                raise ArgumentError, 'Argumento tiene cosas que no son Estrategias'
            end
        end

        @s1 = hash.values[0]
        @s2 = hash.values[1]
        @jugador1 = hash.keys[0]
        @jugador2 = hash.keys[1]
        @rondas = 0
        @ganadas1 = 0
        @ganadas2 = 0
    

    end

    # dado un entero n, genera n partidas
    def rondas(n)
        if !(n.is_a? Integer)
            raise ArgumentError, "Argumento no es entero"
        end

        jugada1 = Piedra.new
        jugada2 = Piedra.new
        for x in (0..n-1)
            @rondas = @rondas +1
            jugada1 = @s1.prox(jugada2)
            jugada2 = @s2.prox(jugada1)
            puntos = jugada1.puntos(jugada2)
            @ganadas1 = @ganadas1 + puntos[0]
            @ganadas2 = @ganadas2 + puntos[1]
        end
        return
    end

    #Dado un entero n, hace tantas rondas sean necesarias para que algun jugador
    # gane n veces
    def alcanzar(n)
        if !(n.is_a? Integer)
            raise ArgumentError, "Argumento no es entero"
        end

        jugada1 = Piedra.new
        jugada2 = Piedra.new
        while @ganadas1 < n and @ganadas2 < n
            @rondas = @rondas +1
            jugada1 = @s1.prox(jugada2)
            jugada2 = @s2.prox(jugada1)
            puntos = jugada1.puntos(jugada2)
            @ganadas1 = @ganadas1 + puntos[0]
            @ganadas2 = @ganadas2 + puntos[1]
        end

        self.info


    end

    #Devuelve un mapa con la informacion de la partida
    def info
        hash = { @jugador1 => @ganadas1, @jugador2 => @ganadas2, :Round => @rondas}
        puts "#{hash}"
    end

    def reset
        @rondas = 0
        @ganadas1 = 0
        @ganadas2 = 0
        @s1.reset
        @s2.reset
    end

end

# Funcion que chequea que al menos un elementos del primer arreglo es mayor al segundo
def hayPosibilidades(probabilidad, actual)
    for x in 0..(probabilidad.length-1)
        if probabilidad[x] > actual[x]
            return true
        end
    end
    return false
end

#Funcion que suma una arreglo de enteros
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

#Funcion que dado un numero y un arreglo de numero, devuelve un arreglo 
# del mismo tamano con arreglo(i)/suma en cada posicion
def crearProbabilidad(suma, arreglo)
    flotante = suma.to_f
    arreglo_aux = [0] * arreglo.length

    for x in 0..(arreglo.length-1)
        arreglo_aux[x] = arreglo[x] / flotante
    end
    return arreglo_aux
end


#Dado un simbolo devuelve una instancia
def fromSymbolToClass(symbol)
    if symbol == :Tijeras
        return Tijeras.new
    elsif symbol == :Piedra
        return Piedra.new
    elsif symbol == :Lagarto
        return Lagarto.new
    elsif symbol == :Spock
        return Spock.new
    elsif symbol == :Papel 
        return Papel.new
    else
        raise JugadaError, 'Jugada inválida'
    end
end

