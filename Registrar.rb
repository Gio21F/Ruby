require 'fox16'
require 'sqlite3'
require_relative 'Menu2'
include Fox
#Ventana para registrar promedios de sus materias
class Registrar < FXMainWindow
    def initialize(app, mat, id)
        @app = app
        @materia = mat
        @id = id
        db = SQLite3::Database.new "test.db"
        super(app, "Registrar", :width=>400, :height=>400)

        #ComboBox
        @combo = FXComboBox.new(self, 1, :opts=> LAYOUT_EXPLICIT, :width=>280, :height=>35, :x=>40, :y=>80)
        @combo.numVisible = 3
        @combo.editable = false
        #Elementos del comboBox
        @arregloId = []
        db.execute( "select id,nombres,apellidos,materias from alumnos" ) do |row|
            cadena = row[3].to_s
            @arregloId2 = cadena.split(",")
            if @arregloId2.include?(@materia)
                cad = "ID:#{row[0]} "+row[1]+" "+row[2]
                @arregloId.push(row[0])
                @combo.appendItem(cad.to_s)
            end
        end
        
        @combo.connect(SEL_COMMAND) do
            @type = @combo.text
            puts @type
        end
        FXLabel.new(self, "Calificación a cambiar(1-100): ")
        @cal = FXTextField.new(self, 25)
        FXLabel.new(self, "Selecciona el alumno: ")
        boton = FXButton.new(self, "|Cambiar|", :opts=> LAYOUT_EXPLICIT, :width=>150, :height=>35, :x=>100, :y=>120)

        boton.connect(SEL_COMMAND) do
            if @cal.text.empty?
                FXMessageBox.information(app, MBOX_OK, "Oh no!", "Agregue calificación") 
            else
                if @cal.text.to_i < 0 || @cal.text.to_i >100
                    FXMessageBox.information(app, MBOX_OK, "Oh no!", "Solo calificaciones de 0-100") 
                else
                    cad = @type.to_s.chars
                    res = @arregloId.include?(cad[3].to_i)
                    if res
                        cali=@cal.text
                        puts cali
                        db.execute("UPDATE promedios SET promedio='#{cali}' where iduser='#{cad[3.to_i]}' and materia='#{@materia}'")
                        FXMessageBox.information(app, MBOX_OK, "Genial", "Calificación modificada correctamente!") 
                        reinicioxD()
                    else
                        FXMessageBox.information(app, MBOX_OK, "Oh no!", "Selecciona un alumno") 
                    end
                end
            end
        
        end
        
    end

    def reinicioxD()
        x = Menu2.new(@app,@id)
        x.create
        x.show(PLACEMENT_SCREEN)
        self.close
        r = Registrar.new(@app, @materia.to_s,@id)
        r.create
        r.show(PLACEMENT_SCREEN)

    end

    def create
        super
        show(PLACEMENT_SCREEN)
    end
end