#!/usr/bin/ruby

require 'sqlite3'

begin
    
    # Open a database
    db = SQLite3::Database.new "test.db"

    # Create a table
    rows = db.execute <<-SQL
    create table alumnos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        correo varchar(100),
        password varchar(30),
        nombres varchar(50),
        apellidos varchar(100),
        promedio INTEGER,
        materias varchar(1000)
    );
    SQL
    
    db.execute("INSERT INTO alumnos (correo, password, nombres, apellidos, materias) 
        VALUES (?, ?, ?, ?, ?)", ["gio@gmail.com", "12345", "Javier", "Gonzalez","Fisica,Programacion,"])
    db.execute("INSERT INTO alumnos (correo, password, nombres, apellidos, materias) 
        VALUES (?, ?, ?, ?, ?)", ["jesus@gmail.com", "12345", "Jesus", "Lujan","Programacion,"])
    
    db.execute <<-SQL
    create table maestros (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        correo varchar(100),
        password varchar(30),
        nombres varchar(50),
        apellidos varchar(100),
        materia varchar(50)
    );
    SQL
    
    db.execute("INSERT INTO maestros (correo, password, nombres, apellidos, materia) 
        VALUES (?, ?, ?, ?, ?)", ["luz@gmail.com", "12345", "Luz Elvira", "Luna Ayala", "Fisica"])
    db.execute("INSERT INTO maestros (correo, password, nombres, apellidos, materia) 
        VALUES (?, ?, ?, ?, ?)", ["estrellita@gmail.com", "12345", "Estrellita", "Gonzalez Radilla", "Programacion"])

    db.execute <<-SQL
    create table administradores (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        correo varchar(100),
        password varchar(30),
        nombres varchar(50),
        apellidos varchar(100)
    );
    SQL

    db.execute <<-SQL
    create table promedios (
        iduser integer,
        materia varchar(50),
        promedio integer DEFAULT 0
    );
    SQL
    db.execute("INSERT INTO promedios (iduser, materia) 
            VALUES (?, ?)", ["1", "Fisica"])
    db.execute("INSERT INTO promedios (iduser, materia) 
        VALUES (?, ?)", ["1", "Programacion"])
    db.execute("INSERT INTO promedios (iduser, materia) 
        VALUES (?, ?)", ["2", "Programacion"])

    db.execute("INSERT INTO administradores (correo, password, nombres, apellidos) 
            VALUES (?, ?, ?, ?)", ["admin@gmail.com", "12345", "Javier Giovani", "Gonzalez Chavez"])

rescue SQLite3::Exception => e 
    
    puts "Exception occurred"
    puts e
    
ensure
    db.close if db
end