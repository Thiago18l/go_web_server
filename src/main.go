package main

import (
	"fmt"
	"log"
	"net/http"
)

func main() {
	http.HandleFunc("/api/v1/", ShowContent)
	http.HandleFunc("/", index)
	fmt.Println("Listening in port 8080")
	log.Fatal(http.ListenAndServe(":8080", nil))
}

func index(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "Go to the URL PATH: /api/v1/")
}
