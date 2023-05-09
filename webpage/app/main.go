package main

import (
	"html/template"
	"log"
	"net/http"
	"os"
)

type VersionInfo struct {
	Version string
	Colour  string
}

func main() {
	var version, colour string
	if version = os.Getenv("VERSION"); version == "" {
		version = "Version 0"
	}

	if colour = os.Getenv("COLOUR"); colour == "" {
		colour = "red"
	}
	versionInfo := VersionInfo{
		Version: version,
		Colour:  colour,
	}

	log.Println(versionInfo.Version, " ", versionInfo.Colour)

	renderPage(versionInfo)
	servePages()
}

func renderPage(versionInfo VersionInfo) {
	tmpl := template.Must(template.ParseFiles("layout.html"))
	pagePath := "/"
	http.HandleFunc(pagePath, func(w http.ResponseWriter, r *http.Request) {
		if err := tmpl.Execute(w, versionInfo); err != nil {
			log.Fatalln("Failed template execution %v", err)
		}
	})
}

func servePages() {
	if err := http.ListenAndServe(":8080", nil); err != nil {
		log.Fatalln("Receive execute listen and serve failed %v", err)
	}
}
