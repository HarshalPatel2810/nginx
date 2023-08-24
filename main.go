package main

import (
	"net/http"

	"github.com/gorilla/mux"
)

type Server struct {
	*mux.Router
}

func NewServer() *Server {
	s := &Server{
		Router: mux.NewRouter(),
	}
	s.routes()
	return s
}

func (s *Server) routes() {
	s.HandleFunc("/", s.echoHandler()).Methods("GET")
}

func main() {

	srv := NewServer()

	err := http.ListenAndServeTLS(":8000", "./cert/localhost.crt", "./cert/localhost.key", srv)
	if err != nil {
		panic(err.Error())
	}
	// http.ListenAndServe(":8000",srv)
}

func (s *Server) echoHandler() http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {

		w.Write([]byte("hello world!"))
	}
}
