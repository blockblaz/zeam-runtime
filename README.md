# zeam-sp1-poc

This is wip and currently won't work in sp1, it needs to get some specific definitions that aren't public afaik.

In order to build the zig lib, run `.build.sh`.

Note that this needs a linker script to actually dump any code, but it still validates the possibility to call zig code from rust, since using a different submachine would cause an error (remove `-mcpu sifive_e76` in `build.sh` to see for yourself).
