require 'pry'

DB = {:conn => SQLite3::Database.new("db/students.db")}
class Student
attr_reader :id, :name, :grade

def initialize(name ,grade)
  @name = name
  @grade = grade
  @id = nil
end

def self.create_table
  sql =  <<-SQL 
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY AUTOINCREMENT , 
      name TEXT, 
      GRADE TEXT
      );
      SQL
  DB[:conn].execute(sql) 
end

def self.drop_table
  sql = <<-SQL 
    DROP TABLE students;
    SQL
    DB[:conn].execute(sql) 
end
  
def save
  sql = <<-SQL
    INSERT INTO students (name, grade) 
    VALUES (?, ?);
  SQL
  sql2 = <<-SQL
  SELECT COUNT FROM students;
  SQL
  DB[:conn].execute(sql, self.name, self.grade)

  @id = DB[:conn].execute("SELECT COUNT(*) FROM students")[0][0]
end



def self.create(studentHash)
   name = nil
   grade = nil
   id = nil
  studentHash.each do |attribute, value|
      if attribute == :name
        name = studentHash[:name]
      elsif attribute == :grade
        grade = studentHash[:grade]
      end
    end
    student = Student.new(name, grade)
    

    sql = <<-SQL
    INSERT INTO students (name, grade) 
    VALUES (?, ?);
  SQL
  
  DB[:conn].execute(sql, student.name, student.grade)

  @id = DB[:conn].execute("SELECT COUNT(*) FROM students")[0][0]
  student
  
end


end

