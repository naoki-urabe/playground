package main
import (
	"fmt"
	"net/http"
	"github.com/gorilla/mux"
	"time"
	"log"
)

func HomeHandler(w http.ResponseWriter, r *http.Request) {
	fmt.Println("hello")
}

func ProductsHandler(w http.ResponseWriter, r *http.Request) {
	fmt.Println("product")
}

func loggingMiddleware1(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		fmt.Println("aaaaaa")
		log.Println(r.RequestURI)
		next.ServeHTTP(w, r)
	})
}

func loggingMiddleware2(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		fmt.Println("bbbbbbb")
		next.ServeHTTP(w, r)
	})
}

func main() {
	r := mux.NewRouter()
	s := r.PathPrefix("/").Subrouter()
	t := r.PathPrefix("/").Subrouter()
	s.Use(loggingMiddleware1)
	t.Use(loggingMiddleware2)
	s.HandleFunc("/", HomeHandler)
	t.HandleFunc("/products", ProductsHandler)
	//r.HandleFunc("/articles", ArticlesHandler)
	// http.Handle("/", r)
	srv := &http.Server{
		Addr: "0.0.0.0:8888",
		WriteTimeout: time.Second * 15,
		ReadTimeout: time.Second *15,
		IdleTimeout: time.Second * 60,
		Handler: r,
	}
	/*go func() {
		if err := srv.ListenAndServe(); err != nil {
			log.Println(err)
		}
	}*/
	fmt.Println("Listen port 8888")
	log.Fatal(srv.ListenAndServe())
}