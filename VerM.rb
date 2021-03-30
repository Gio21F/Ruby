require 'fox16'
require 'sqlite3'
include Fox
class VerM < FXMainWindow
    def initialize(app)
        db = SQLite3::Database.new "test.db"
        super(app, "Maestros", :width=>800, :height=>400)

        #Tabla
        @tabla = FXTable.new(self)
        @tabla.visibleColumns = 5
        @tabla.visibleRows = 15
        @tabla.setTableSize(50,5)
        @tabla.setItemJustify(0,0, FXTableItem::CENTER_X | FXTableItem::CENTER_Y)

        @tabla.setColumnText(0,"Correo")
        @tabla.setColumnText(1,"Contraseña")
        @tabla.setColumnText(2,"Nombre")
        @tabla.setColumnText(3,"Apellidos")
        @tabla.setColumnText(4,"Materia")

        @fila = 0
        db.execute( "select * from maestros" ) do |row|
            for i in 1...6
                @tabla.setItemText(@fila, i-1, row[i].to_s)
            end
            @tabla.setRowText(@fila,row[0].to_s)
            @fila = @fila+1
        end
    end

    def create
        super
        show(PLACEMENT_SCREEN)
    end
end