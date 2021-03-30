require_relative 'Menu'
require_relative 'Menu2'
require_relative 'Menu3'
require 'fox16'
require 'sqlite3'
include Fox
class Ventana < FXMainWindow
    def initialize(app)
        #Inicializacion de ventana Login
        @app = app
        db = SQLite3::Database.new "test.db"
        super(app, "Log In", :width=>300, :height=>300)

        #RadioButtons
        @gropBox = FXGroupBox.new(self, "Tipo de usuario:")
        @dataTarget = FXDataTarget.new(3)
        FXRadioButton.new(@gropBox, "Administrador", @dataTarget, FXDataTarget::ID_OPTION)
        FXRadioButton.new(@gropBox, "Maestro", @dataTarget, FXDataTarget::ID_OPTION+1)
        FXRadioButton.new(@gropBox, "Alumno", @dataTarget, FXDataTarget::ID_OPTION+2)
        @dataTarget.connect(SEL_COMMAND) do
            @type = @dataTarget.value
        end

        #Log In
        FXLabel.new(self, "Correo", :x=>20, :y=>20)
        @user = FXTextField.new(self, 25)
        FXLabel.new(self, "Contaseña",:x=>20, :y=>20)
        @pass = FXTextField.new(self, 25)
        b1 = FXButton.new(self, "Aceptar")
        b2 = FXButton.new(self, "Salir")

        b1.connect(SEL_COMMAND) do
            uss = @user.text
            paa = @pass.text
            if @type != 0 && @type != 1 && @type != 2
                FXMessageBox.information(app, MBOX_OK, "Oh no!", "Selecciona un tipo de usuario!") 
            else
                @t = userT(@type)
                db.execute( "select * from #{@t} where correo='#{uss}'" ) do |row|
                    p row
                    if row[1] == uss && row[2] == paa
                        @n = row[0]
                        menu(@type)
                     else                    
                        FXMessageBox.error(app, MBOX_OK, "Error", "Contraseña incorrecta") 
                     end
                  end
            end
        end

        b2.connect(SEL_COMMAND) do
            self.close
        end
    end
    def menu(t)
        if t == 0
            inicio = Menu.new(@app,@n)
            inicio.create
            inicio.show(PLACEMENT_SCREEN)
        elsif t == 1
            inicio2 = Menu2.new(@app,@n)
            inicio2.create
            inicio2.show(PLACEMENT_SCREEN)
        elsif t == 2
            inicio3 = Menu3.new(@app,@n)
            inicio3.create
            inicio3.show(PLACEMENT_SCREEN)
        end
        
        self.close
    end

    def userT(tipo)
        if tipo == 0
            return "administradores"
        elsif tipo == 1
            return "maestros"
        elsif tipo == 2
            return "alumnos"
        end
    end

    def create
        super
        show(PLACEMENT_SCREEN)
    end
end

app = FXApp.new
Ventana.new(app)
app.create
app.run