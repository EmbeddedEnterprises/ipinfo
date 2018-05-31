package main

import (
	"fmt"
	"net/http"
	"os"
	"strings"
	"time"

	"github.com/sebest/xff"
)

func main() {
	// Create handler
	handler := http.HandlerFunc(func(resp http.ResponseWriter, req *http.Request) {
		x := strings.Split(req.RemoteAddr, ":")
		if len(x) == 0 {
			// broken
			fmt.Fprintf(os.Stderr, "Invalid request from: %s\n", req.RemoteAddr)
			resp.WriteHeader(500)
		}
		resp.WriteHeader(200)
		resp.Write([]byte(x[0]))
	})

	// Handle X-Forwarded-For
	xffmw, err := xff.Default()
	if err != nil {
		fmt.Fprintf(os.Stderr, "Failed to create xff mw: %v", err)
		os.Exit(1)
	}

	s := &http.Server{
		Addr:           ":9999",
		Handler:        xffmw.Handler(handler),
		ReadTimeout:    1 * time.Second,
		WriteTimeout:   1 * time.Second,
		MaxHeaderBytes: 1 << 16,
	}

	err = s.ListenAndServe()
	if err != nil {
		fmt.Printf("Failed to serve: %v", err)
		os.Exit(1)
	}
}
