//go:build unix

package main

import (
	"os"
	"os/signal"
	"syscall"
)

func setupSignalHandling() {
	sigs := make(chan os.Signal, 1)
	signal.Notify(sigs, syscall.SIGUSR1)

	go func() {
		for sig := range sigs {
			if sig == syscall.SIGUSR1 {
				dumpStacks()
			}
		}
	}()
}