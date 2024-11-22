/*
Requerimientos
Hacer el código correspondiente para resolver todos los ítems pedidos
Hacer al menos un test para el item 6 (emociones grupales)
*/

class Persona{
    var property edad
    var property emociones
    var property palabrotas

//punto (1)Averiguar si una persona es adolescente. Los expertos en las emociones informan que la etapa de adolescencia arranca con 
//12 años y termina cuando cumple 19.
    method esAdolescente() = self.edad().between(12,19)

    method cumplirAnios(){
        self.edad(edad + 1)
    }

//punto(2)Hacer que una persona tenga una nueva emoción.
    method nuevaEmocion(emocion){
        self.emociones(emociones + [emocion])
    }

//punto(3)Averiguar si está por explotar emocionalmente, lo que ocurre cuando todas las emociones de la persona pueden liberarse.
    method estaPorExplotar() = emociones.all{emocion => emocion.puedeLiberarse(self)}

    method olvidarPalabrota(){
        self.palabrotas(palabrotas.drop(1))
    }

//punto(4)Representar que una persona viva un evento, con las consecuencias que ello puede implicar.
//Debe poder liberarla y si puede liberarla, hacerlo
    method vivirEvento(evento){
        self.aumentarLosEventos()
        self.emocionesLiberables().forEach{emocion=>emocion.liberar(self,evento)}
    }

    method aumentarLosEventos(){
        self.emociones().forEach{emocion=>emocion.aumentarEvento()}
    }
    method emocionesLiberables() = emociones.filter{emocion=>emocion.puedeLiberarse(self)}
}
/*
Las emociones
El valor para considerar elevada la intensidad de una emoción es el mismo para todas las personas y emociones, pero puede cambiarse en 
cualquier momento. 

Todas las emociones deben poder informar cuántos eventos experimentaron en su existencia, independientemente si en estos fueron liberadas o no.
*/
class Emocion{
    var property intensidadElevada = 50
    var property intensidad
    var property eventosVividos = 0

    method puedeLiberarse(persona) = intensidad > intensidadElevada

    method liberar(persona,evento){
        self.intensidad(intensidad - evento.impacto())
    }

    method aumentarEvento(){
        self.eventosVividos(eventosVividos + 1)
    }
    method cambiarIntensidad(nuevaIntensidad){
//punto(5)Permitir modificar el valor para considerar elevada la intensidad de las emociones
        self.intensidadElevada(nuevaIntensidad)
    }
}
/*
Furia
La emoción de la furia consta de una serie de palabrotas que se van aprendiendo u olvidando con el tiempo. 
La furia de una persona puede liberarse si tiene una intensidad elevada y si conoce al menos una palabrota con más de 7 letras. 
La intensidad inicial es 100, pero puede variar.
Liberarse consiste en disminuir la intensidad tantas unidades como el impacto del evento. Además, olvida la primer palabrota aprendida. 
*/
class Furia inherits Emocion(intensidad = 100){

    override method puedeLiberarse(persona) = super(persona) and self.palabrotaLarga(persona)

    method palabrotaLarga(persona) = persona.palabrotas().any{palabra => palabra.size()>7}

    override method liberar(persona,evento){
        super(persona,evento)
        persona.olvidarPalabrota()
    }
}
/*
Alegría
No hay un valor inicial conocido para su intensidad, sino que depende de cada caso. Liberarse consiste en disminuir la intensidad 
tantas unidades como el impacto del evento. Nunca su intensidad puede ser negativa, sino que si por cualquier circunstancia se le 
quisiera dar un valor negativo, se le da el mismo valor, pero positivo. 
La alegría puede ser liberada cuando tiene una intensidad elevada y la cantidad de eventos vividos es par. 
*/
class Alegria inherits Emocion{

    override method puedeLiberarse(persona) = super(persona) and self.eventosVividos().even()

    override method liberar(persona,evento){
        super(persona,evento)
        if(intensidad < 0){
            self.intensidad(intensidad * (-1))
        }
    }
}
/*
Tristeza
La emoción de la tristeza de cualquier persona sabe que inicialmente su causa es la melancolía. Su intensidad puede variar sin limitaciones.
La tristeza puede ser liberada si su causa no sea precisamente la melancolía y su intensidad es elevada. 
Liberarse implica registrar como causa la descripción del evento vivido y disminuir la intensidad tantas unidades como el impacto del evento.
*/
class Tristeza inherits Emocion{
    var property causa = "melancolía"

    override method puedeLiberarse(persona) = super(persona) and !causa.equals("melancolia")

    override method liberar(persona,evento){
        super(persona,evento)
        self.causa(evento.descripcion())
    }
}
/*
Desagrado y temor:
En ambos casos, pueden ser liberadas cuando tienen una intensidad elevada y la cantidad de eventos vividos es mayor que su propia intensidad. 
Liberarse implica disminuir la intensidad tantas unidades como el impacto del evento.
*/

class Desagrado inherits Emocion{
    override method puedeLiberarse(persona) = super(persona) and persona.eventos().size()>intensidad
    //el metodo liberar es el mismo que el de Emocion
}

class Temor inherits Desagrado{
    //Es igual que desagrado, por lo que hago que herede todo de esa clase
}
/*
Intensamente 2
Aparece una nueva emoción que toda persona puede tener: ansiedad. Inventar una implementación que tenga algo diferente a las otras 
emociones, utilizando el concepto de polimorfismo y herencia. Explica para qué fueron útiles dichos conceptos. 
*/
class Ansiedad inherits Emocion{
    override method puedeLiberarse(persona) = super(persona) and persona.palabrotas().size()>=5

    override method liberar(persona,evento){
            super(persona,evento)
            persona.palabrotas(persona.palabrotas() + ["No quiero salir de la cama"])
    }

    /*El polimorfismo me permite utilizar las emociones dentro de una misma coleccion y realizar acciones sobre ellas,
    ya que, aunque sean diferentes, sus metodos reciben los mismos parametros

    La herencia fue util para poder reuilizar metodos ya creados en la clase padre y no tener que repetirlos
    */ 
}


/*
Los eventos 
El impacto de un evento se expresa con un número positivo. También se conoce la descripción de cada evento, que se representa como una 
cadena de caracteres.
*/
class Evento{
    const property descripcion
    var property impacto
}

//punto(6)Hacer que todos los integrantes de un grupo de personas vivan un mismo evento.
class Grupo{
    const integrantes

    method vivirEventoEnGrupo(evento){
        integrantes.forEach{persona=>persona.vivirEvento(evento)}
    }
}