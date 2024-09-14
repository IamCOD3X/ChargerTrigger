#!/sbin/sh

# Directory where the module files are located
MODDIR="/data/adb/modules/${MODID}"

# Function to print messages
ui_print() { echo "$1"; }

# Function to abort the installation with an error message
abort() {
    ui_print "$1"
    exit 1
}

print_modname() {
  ui_print "*******************************"
  ui_print "        Charger Trigger        "
  ui_print "---------By- IamCOD3X----------"
  ui_print "*******************************"
  
}

# Function to apply specific installation actions
on_install() {
    ui_print "- Applying installation steps..."

    # Create the module directory if it doesn't exist
    mkdir -p "$MODDIR"

    # Copy the module files to the target directory
    cp -af "$TMPDIR/system/"* "$MODDIR/system/" || abort "Failed to copy system files!"

    # If the module includes a custom `post-fs-data.sh`, copy it to the module path
    if [ -f "$TMPDIR/post-fs-data.sh" ]; then
        cp -af "$TMPDIR/post-fs-data.sh" "$MODDIR/post-fs-data.sh" || abort "Failed to copy post-fs-data.sh!"
    fi

    # If the module includes a custom `service.sh`, copy it to the module path
    if [ -f "$TMPDIR/service.sh" ]; then
        cp -af "$TMPDIR/service.sh" "$MODDIR/service.sh" || abort "Failed to copy service.sh!"
    fi

    # Additional installation steps can be added here

    ui_print "- Installation completed!"
}

# Function to set permissions for module files
set_permissions() {
    ui_print "- Setting permissions..."

    # Set appropriate permissions for the module directory and files
    chmod 755 "$MODDIR/system/"* || abort "Failed to set permissions for system files!"

    # Set permissions for the scripts
    [ -f "$MODDIR/post-fs-data.sh" ] && chmod 755 "$MODDIR/post-fs-data.sh"
    [ -f "$MODDIR/service.sh" ] && chmod 755 "$MODDIR/service.sh"
}

# Start installation
on_install
set_permissions

ui_print "- Done"
exit 0

