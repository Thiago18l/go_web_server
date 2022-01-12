package main

import (
	"net/http"
	"net/http/httptest"
	"testing"
)

func TestServer(t *testing.T) {
	req := httptest.NewRequest(http.MethodGet, "localhost:8080/api/v1", nil)
	w := httptest.NewRecorder()
	Handler(w, req)
	if want, got := http.StatusOK, w.Result().StatusCode; want != got {
		t.Fatalf("Expected a %d, insted got: %d", want, got)
	}
}

func Handler(w http.ResponseWriter, r *http.Request) {
	w.Write([]byte(`OK`))
}
