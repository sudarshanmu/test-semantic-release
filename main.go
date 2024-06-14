package main

import (
    "fmt"
    "time"
)

func main() {
    go func() {
        for {
            fmt.Println("Hello, World!")
            time.Sleep(1 * time.Second)
        }
    }()

    // Keep the main function running
    select {}
}

