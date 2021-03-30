require 'fox16'
require 'sqlite3'
require_relative 'CrearA'
require_relative 'CrearM'
require_relative 'VerA'
require_relative 'VerM'
include Fox
class Menu < FXMainWindow
    def initialize(app, n)
        @app = app
        db = SQLite3::Database.new "test.db"
        super(app, "Inicio Administradores", :width=>300, :height=>300)
        FXLabel.new(self, "Bienvenido", :x=>20, :y=>20)
        btn1 = FXButton.new(self, "Agregar Alumnos")
        btn2 = FXButton.new(self, "Agregar Maestros")
        btn3 = FXButton.new(self, "Ver Alumnos")
        btn4 = FXButton.new(self, "Ver Maestros")
        @bt = FXButton.new(self, "||Cerrar sesión||", :opts=> LAYOUT_EXPLICIT, :width=>200, :height=>35, :x=>100, :y=>200)
        @bt.connect(SEL_COMMAND) do
            b = Ventana.new(@app)
            b.create
            b.show(PLACEMENT_SCREEN)
            self.close
        end
        btn1.connect(SEL_COMMAND) do
            a()
        end

        btn2.connect(SEL_COMMAND) do
            b()
        end

        btn3.connect(SEL_COMMAND) do
            c()
        end

        btn4.connect(SEL_COMMAND) do
            d()
        end
    end

    def a()
        i1 = CrearA.new(@app)
        i1.create
        i1.show(PLACEMENT_SCREEN)
    end

    def b()
        i2 = CrearM.new(@app)
        i2.create
        i2.show(PLACEMENT_SCREEN)
    end 

    def c()
        i3 = VerA.new(@app)
        i3.create
        i3.show(PLACEMENT_SCREEN)
    end

    def d()
        i4 = VerM.new(@app)
        i4.create
        i4.show(PLACEMENT_SCREEN)
    end

    def create
        super
        show(PLACEMENT_SCREEN)
    end
end