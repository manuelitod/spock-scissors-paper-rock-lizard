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

class Tijera < Jugada

    @pierde = ["Piedra", "Spock"]

    def to_s
        puts "Tijera"
    end
end

class Lagarto < Jugada
    
    @pierde = ["Piedra", "Tijera"]

    def to_s
        puts "Lagarto"
    end
end

class Spock < Jugada
    
    @pierde = ["Papel", "Lagarto"]

    def to_s
        puts Spock
    end
end