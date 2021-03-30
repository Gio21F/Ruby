require 'fox16'
require 'sqlite3'
include Fox
class CrearA < FXMainWindow
    def initialize(app)
        db = SQLite3::Database.new "test.db"
        super(app, "Agregar Alumnos", :width=>300, :height=>300)

        #Datos a agregar
        #Tambien es un cambio
        FXLabel.new(self, "Correo", :x=>20, :y=>20)
        @correo = FXTextField.new(self, 25)
        FXLabel.new(self, "Contraseña", :x=>20, :y=>20)
        @password = FXTextField.new(self, 25)
        FXLabel.new(self, "Nombres", :x=>20, :y=>20)
        @nom = FXTextField.new(self, 25)
        FXLabel.new(self, "Apellidos", :x=>20, :y=>20)
        @ape = FXTextField.new(self, 25)

        bot1 = FXButton.new(self, "Agregar") 
        
        bot1.connect(SEL_COMMAND) do
            co = @correo.text
            pa = @password.text
            no = @nom.text
            ap = @ape.text
            if co.empty? || pa.empty? || no.empty? || ap.empty?
                FXMessageBox.information(app, MBOX_OK, "Oh no!", "Rellena todos los datos!") 
            else
                db.execute("INSERT INTO alumnos (correo, password, nombres, apellidos) 
                VALUES (?, ?, ?, ?)", ["#{co}", "#{pa}", "#{no}", "#{ap}"])
                FXMessageBox.information(app, MBOX_OK, "Genial!", "Alumno creado correctamente") 
                self.close
            end
            
        end
        
    end

    def create
        super
        show(PLACEMENT_SCREEN)
    end
end