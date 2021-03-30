require 'fox16'
require 'sqlite3'
include Fox
class Menu3 < FXMainWindow
    def initialize(app,id)
        @app = app
        @id = id
        db = SQLite3::Database.new "test.db"
        super(app, "Inicio Alumnos", :width=>500, :height=>400)
        db.execute( "select nombres,apellidos from alumnos where id='#{@id}'" ) do |row|
            @name = row[0]+" "+row[1]
        end

        @bt = FXButton.new(self, "||Cerrar sesión||", :opts=> LAYOUT_EXPLICIT, :width=>280, :height=>35, :x=>300, :y=>350)

        FXLabel.new(self, "Bienvenido #{@name}, estas son tus materias y calificaciones: ")

        #Tabla
        @tabla = FXTable.new(self)
        @tabla.visibleColumns = 3
        @tabla.visibleRows = 8
        @tabla.setTableSize(50,4)
        @tabla.setItemJustify(0,0, FXTableItem::CENTER_X | FXTableItem::CENTER_Y)

        @tabla.setColumnText(0,"Materia")
        @tabla.setColumnText(1,"Calificación")
        @tabla.setColumnText(2,"Docente")

        @fila = 0
        @promedioFinal = 0
        @contador = 0
        db.execute( "select materia,promedio,materia from promedios where iduser='#{@id}'" ) do |row|
            @promedioFinal = @promedioFinal + row[1].to_i
            @contador+=1
            for i in 0...2
                @tabla.setItemText(@fila, i, row[i].to_s)
            end
            db.execute( "select nombres,apellidos from maestros where materia='#{row[2]}'" ) do |row|
                cc = row[0]+" "+row[1]
                @tabla.setItemText(@fila, 2, cc)
            end
            @fila = @fila+1  
        end
        if @contador === 0
            FXLabel.new(self, "No estas dado de alta en ninguna materia :ç")             
        else
            FXLabel.new(self, "Tu promedio hasta ahora es de: #{@promedioFinal/@contador}")
        end
        @bt.connect(SEL_COMMAND) do
            b = Ventana.new(@app)
            b.create
            b.show(PLACEMENT_SCREEN)
            self.close
        end
    end

    def create
        super
        show(PLACEMENT_SCREEN)
    end
end