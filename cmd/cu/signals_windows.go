//go:build windows

package main

func setupSignalHandling() {
	// Signal handling not supported on Windows
	// SIGUSR1 is not available on Windows platforms
}