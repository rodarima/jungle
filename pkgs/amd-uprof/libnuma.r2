# Patch arguments to call sym std::string::find(char const*, unsigned long, unsigned long)
# so it matches NixOS:
#
# Change OS name to NixOS
wz NixOS @ 0x00550a43
# And set the length to 5 characters
wa mov ecx, 5 @0x00517930
#
# Then change the argument to dlopen() so it only uses libnuma.so
wz libnuma.so @ 0x00562940
