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
		log.Println(r.RequestURI)
		log.Println(string(body))
		_, err = w.Write(body)
		if err != nil {
			log.Println(err)
		}
	}
	http.HandleFunc("/a", handler)
	http.HandleFunc("/b", handler)

	log.Fatal(http.ListenAndServe(":8080", nil))
}
