package main

import (
	"fmt"
	"net/http"
)

// ShowContent implementation
func ShowContent(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "URL.Path = %q\n", r.URL.Path)
}
