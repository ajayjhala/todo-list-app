# Variables
APP_URL ?= http://localhost:3000  # Default URL of the Node.js application
LOAD_TEST_DURATION ?= 30         # Test duration in seconds (for k6)
LOAD_TEST_CONNECTIONS ?= 10      # Number of concurrent connections (for ab)
LOAD_TEST_REQUESTS ?= 1000       # Total number of requests (for ab)
LOAD_TEST_OUTPUT ?= results.txt  # Output file for test results

.PHONY: test clean

# Load test using curl
test:
	@echo "Starting load test using curl..."
	@for i in $$(seq 1 $(LOAD_TEST_REQUESTS)); do \
		curl -s -o /dev/null -w "Request $$i: %{http_code}\n" $(APP_URL); \
	done | tee $(LOAD_TEST_OUTPUT)

# Clean up the output file
clean:
	@echo "Cleaning up test results..."
	@rm -f $(LOAD_TEST_OUTPUT)
