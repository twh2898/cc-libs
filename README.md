# ComputerCraft Libs

Helper functions and programs for computers and turtles.

- [CC:Tweaked Wiki](https://tweaked.cc/)
- [Computer Craft Wiki](https://computercraft.info/wiki/Main_Page)

## Usage

Clone the repo into a computer or turtle directory (`cc-libs` should be in the
root directory). Lua scripts in the project root can be executed on a turtle or
computer, or the `cc-libs` directory can be used in other projects.

```sh
git clone git@github.com:twh2898/cc-libs.git # <computer_or_turtle_dir>
```

## Development

### Test

Testing is performed by the builtin `tests/runtest.lua` using `mock.lua` and
`asserts.lua` for support.

```sh
make test
```

### Linting & Formatting

Linting is performed by a combination of luacheck and stylua.

- [luacheck](https://github.com/mpeterv/luacheck)
- [stylua](https://github.com/JohnnyMorganz/StyLua)

```sh
make lint
```

Stylua is used for formatting in cli and vs-code.

```sh
make format
```

## ComputerCraft Mod Config

There are 2 options for using this library.

```sh
https://github.com/twh2898/cc-libs/blob/main/install/install_cc-libs.lua
```

1. Copy the script [install_cc-libs.lua](install/install_cc-libs.lua) from the `install/`
   folder onto your computer or turtle and run it to get the latest release. Run
   this script again later to install updates from newer releases.
2. Using `wget` on the computer or turtle
    ```sh
    wget https://raw.githubusercontent.com/twh2898/cc-libs/refs/heads/main/install/install_cc-libs.lua
    ```
3. Clone this repo and use it as the computer or turtle directory.

If you choose to clone this repo, there are a few things you will need to do
first.

This repo is too big for the default computer disk size. In your .minecraft
folder, edit the file `.minecraft/config/computercraft-server.toml` and increase
the `computer_space_limit` line. The default is 10000000.

```toml
#The disk space limit for computers and turtles, in bytes.
computer_space_limit = 100000000 # added another 0
```

## Planning

- Need a motion controller independent of rgps
- Motion controller needs to take optional gps or relative gps to track position
- GPS module should be able to operate in place of rgps if a gps signal is available
  - Maybe GPS could have fallback to rgps if signal is lost
- Motion controller needs to have retries of actions up to some limit
- Motion controller should update rgps if in use
- Navigation could take motion controller
  - mocon would have functions for movement
  - navigation would have functions for waypoints and such (no direct motion)

Possible names

- Motion
- MotionController
- MC
- Actions
- TurtleController
- Driver
- Interface
- TurtleInterface


## Motion (Controller)

- Includes max retries
- Motion has optional parameter to allow digging
