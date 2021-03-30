require 'fox16'
require 'sqlite3'
include Fox
class CrearM < FXMainWindow
    def initialize(app)
        db = SQLite3::Database.new "test.db"
        super(app, "Agregar maestro", :width=>300, :height=>300)

        #Datos a agregar
        FXLabel.new(self, "Correo", :x=>20, :y=>20)
        @correo = FXTextField.new(self, 25)
        FXLabel.new(self, "Contraseña", :x=>20, :y=>20)
        @password = FXTextField.new(self, 25)
        FXLabel.new(self, "Nombres", :x=>20, :y=>20)
        @nom = FXTextField.new(self, 25)
        FXLabel.new(self, "Apellidos", :x=>20, :y=>20)
        @ape = FXTextField.new(self, 25)
        FXLabel.new(self, "Materia a impartir", :x=>20, :y=>20)
        @mat = FXTextField.new(self, 25)

        bot1 = FXButton.new(self, "Agregar") 
        
        bot1.connect(SEL_COMMAND) do
            co = @correo.text
            pa = @password.text
            no = @nom.text
            ap = @ape.text
            ma = @mat.text
            if co.empty? || pa.empty? || no.empty? || ap.empty? || ma.empty?
                FXMessageBox.information(app, MBOX_OK, "Oh no!", "Rellena todos los datos!") 
            else
                res = false
                db.execute( "select materia from maestros" ) do |row|
                    v = verificaNoRepetirString(ma,row[0])
                    if v
                        res = true
                    end 
                end
                if res
                    FXMessageBox.error(app, MBOX_OK, "Error!", "Materia ya existente!")
                else
                    db.execute("INSERT INTO maestros (correo, password, nombres, apellidos, materia) 
                    VALUES (?, ?, ?, ?, ?)", ["#{co}", "#{pa}", "#{no}", "#{ap}", "#{ma}"])
                    FXMessageBox.information(app, MBOX_OK, "Genial!", "Maestro creado correctamente") 
                    self.close
                end
            end
            
        end
        
    end

    def create
        super
        show(PLACEMENT_SCREEN)
    end

    def verificaNoRepetirString(c,d)
        res2 = /#{c.to_s.downcase}/.match(d.to_s.downcase)
        if res2
            return true
        else
            return false
        end
    end
end