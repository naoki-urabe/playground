package main

import (
	"fmt"
	_ "github.com/go-sql-driver/mysql"
	"github.com/jmoiron/sqlx"
	"log"
)

var schema = `
CREATE TABLE IF NOT EXISTS person (
	first_name text,
	last_name text,
	email text
);
`

type Person struct {
	Id        int    `db:"id"`
	FirstName string `db:"first_name"`
	LastName  string `db:"last_name"`
	Email     string `db:"email"`
}

func main() {
	db, err := sqlx.Connect("mysql", "root:fg47gh62@tcp(mysql:3306)/go_db")
	if err != nil {
		log.Fatalln(err)
	}
	/*if db.MustExec(schema) != nil{
		fmt.Println("already exists")
	}*/
	tx := db.MustBegin()
	tx.MustExec("INSERT INTO person (first_name, last_name, email) VALUES (?, ?, ?)", "Jason", "Manson", "json@gmail.com")
	tx.Commit()
	people := []Person{}
	db.Select(&people, "SELECT * FROM person ORDER BY first_name ASC")
	fmt.Println(people)
}
