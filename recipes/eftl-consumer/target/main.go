package main

import (
	"io/ioutil"
	"log"
	"net/http"
)

func main() {
	handler := func(w http.ResponseWriter, r *http.Request) {
		body, err := ioutil.ReadAll(r.Body)
		if err != nil {
			log.Println(err)
		}
		mime := r.Header.Get("Content-Type")
		log.Println(r.RequestURI)
		log.Println(mime)
		log.Println(string(body))
		w.Header().Set("Content-Type", mime)
		_, err = w.Write(body)
		if err != nil {
			log.Println(err)
		}
	}
	http.HandleFunc("/a", handler)
	http.HandleFunc("/b", handler)
	http.HandleFunc("/c", handler)

	log.Fatal(http.ListenAndServe(":8181", nil))
}
