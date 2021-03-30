require_relative 'Registrar'
#require_relative 'Ventana'
require 'fox16'
require 'sqlite3'
include Fox
class Menu2 < FXMainWindow
    def initialize(app,id)
        @app = app
        @id = id
        db = SQLite3::Database.new "test.db"
        super(app, "Inicio Maestros", :width=>550, :height=>700)
        db.execute( "select * from maestros where id='#{id}'" ) do |row|
            @name = row[3]+" "+row[4]
            @materia = row[5]
        end
        @bt = FXButton.new(self, "||Cerrar sesión||", :opts=> LAYOUT_EXPLICIT, :width=>280, :height=>35, :x=>350, :y=>15)
        FXLabel.new(self, "Hola #{@name}", :x=>20, :y=>20)
        FXLabel.new(self, "Se encargara de la materia:  #{@materia}", :x=>20, :y=>20)
        FXLabel.new(self, "")

        ##Apartado para dar de alta calificaciones
        #ComboBox
        @combow = FXComboBox.new(self, 1, :opts=> LAYOUT_EXPLICIT, :width=>280, :height=>35, :x=>20, :y=>160)
        @combow.numVisible = 3
        @combow.editable = false
        #Elementos del comboBox
        @arregloIdw = []
        db.execute( "select id,nombres,apellidos,materias from alumnos" ) do |row|
            cadena = row[3].to_s
            @arregloId2 = cadena.split(",")
            if @arregloId2.include?(@materia)
                cad = "ID:#{row[0]} "+row[1]+" "+row[2]
                @arregloIdw.push(row[0])
                @combow.appendItem(cad.to_s)
            end
        end
        
        @combow.connect(SEL_COMMAND) do
            @typew = @combow.text
        end
        FXLabel.new(self, "+=+=+=+=+=+=+=+=+=+=+=+=+=MODIFICAR CALIFICACIONES+=+=+=+=+=+=+=+=+=+=+=+=+=")
        FXLabel.new(self, "")
        FXLabel.new(self, "Calificación a cambiar(1-100): ")
        @cal = FXTextField.new(self, 25)
        
        FXLabel.new(self, "Selecciona el alumno: ")
        @boton = FXButton.new(self, "|Cambiar|", :opts=> LAYOUT_EXPLICIT, :width=>150, :height=>35, :x=>300, :y=>160)
        10.times do |c|
            FXLabel.new(self, "")
        end
        #Apartado para ver, agrega
        FXLabel.new(self, "Alumnos que se encuentran registrados en su materia: ", :x=>20, :y=>20)
    
        
        #Tabla
        @tabla = FXTable.new(self)
        @tabla.visibleColumns = 4
        @tabla.visibleRows = 9
        @tabla.setTableSize(50,4)
        @tabla.setItemJustify(0,0, FXTableItem::CENTER_X | FXTableItem::CENTER_Y)

        @tabla.setColumnText(0,"Nombre")
        @tabla.setColumnText(1,"Apellidos")
        @tabla.setColumnText(2,"Correo")
        @tabla.setColumnText(3,"Promedio")

        @fila = 0
        db.execute( "select * from promedios where materia='#{@materia}'" ) do |row|
            p row
            idd = row[0]
            @tabla.setItemText(@fila, 3, row[2].to_s)
            db.execute( "select id,nombres,apellidos,correo from alumnos where id='#{idd}'") do |row|
                p row
                for i in 1...4
                    @tabla.setItemText(@fila, i-1, row[i].to_s)
                end
                
                @tabla.setRowText(@fila,row[0].to_s)
                @fila = @fila+1
            end
        end
        FXLabel.new(self, "")
        FXLabel.new(self, "+=+=+=+=+=+=+=+=+=+=+=+=+=AGREGAR ALUMNOS A: #{@materia}+=+=+=+=+=+=+=+=+=+=+=+=+=")
        

        #ComboBox
        @combo = FXComboBox.new(self, 1, :opts=> LAYOUT_EXPLICIT, :width=>280, :height=>35, :x=>40, :y=>530)
        @combo.numVisible = 3
        @combo.editable = false

        #Agregar alumno a materia (Accion Maestro)
        @arregloId = []
        db.execute( "select id,nombres,apellidos,materias from alumnos" ) do |row|
            cadena = row[3].to_s
            @arregloId2 = cadena.split(",")
            if !@arregloId2.include?(@materia)
                cad = "ID:#{row[0]} "+row[1]+" "+row[2]
                @arregloId.push(row[0].to_i)
                @combo.appendItem(cad.to_s)
            end
        end
        @combo.connect(SEL_COMMAND) do
            @type = @combo.text
        end

        btn1 = FXButton.new(self, "|Agregar alumno|",:opts=> LAYOUT_EXPLICIT, :width=>200, :height=>25, :x=>350, :y=>530)

        @bt.connect(SEL_COMMAND) do
            b = Ventana.new(@app)
            b.create
            b.show(PLACEMENT_SCREEN)
            self.close
        end
        #btn2 = FXButton.new(self, "|Agregar promedios|",:opts=> LAYOUT_EXPLICIT, :width=>200, :height=>25, :x=>400, :y=>350)
        btn1.connect(SEL_COMMAND) do
            cad = @type.to_s.chars
            puts "ID: #{cad[3].to_i}"
            puts "IDS: #{@arregloId}"
            res = @arregloId.include?(cad[3].to_i)
            if res
                db.execute( "select materias,nombres,apellidos from alumnos where id='#{cad[3.to_i]}'" ) do |row|
                    @string = row[0].to_s
                    @nn = row[1].to_s+" "+row[2].to_s
                    @string = @string+""+@materia.to_s+","
                end
                
                db.execute("INSERT INTO promedios (iduser,materia) 
                VALUES (?, ?)", ["#{cad[3.to_i]}", "#{@materia}"])
                #actualizar
                db.execute("UPDATE alumnos SET materias='#{@string}' where id='#{cad[3.to_i]}'")

                FXMessageBox.information(app, MBOX_OK, "Genial!", "#{@nn} agregado a su materia") 
                reinicioxD()

            else
                FXMessageBox.information(app, MBOX_OK, "Oh no!", "Selecciona el alumno a agregar") 
            end
            
        end


        ##Boton modificar calificacion
        @boton.connect(SEL_COMMAND) do
            if @cal.text.empty?
                FXMessageBox.information(app, MBOX_OK, "Oh no!", "Agregue calificación") 
            else
                ver = @cal.text.chars
                bool = false
                ver.each do |i|
                    r = /[a-z]|[A-Z]/.match(i)
                    if r
                        bool = true
                    end
                end
                if @cal.text.to_i < 0 || @cal.text.to_i >100 || bool == true
                    FXMessageBox.information(app, MBOX_OK, "Oh no!", "Solo calificaciones de 0-100") 
                else
                    cad = @typew.to_s.chars
                    res = @arregloIdw.include?(cad[3].to_i)
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
        r = Menu2.new(@app, @id)
        r.create
        r.show(PLACEMENT_SCREEN)
        self.close
    end

    def create
        super
        show(PLACEMENT_SCREEN)
    end
end

