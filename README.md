# Block spectators

Allows you to block the spectators team at the end of the round or earlier

### Supported Games

* Day of Defeat: Source

### Installation

* Download latest [release](https://github.com/dronelektron/block-spectators/releases) (compiled for SourceMod 1.10)
* Extract "plugins" folder to "addons/sourcemod" folder of your server

### Console Variables

* sm_blockspectators - Enable (1) or disable (0) spectators team blocking [default: "1"]
* sm_blockspectators_notifications_mode - None - 0, Join attempt - 1, Round end - 2, Timer - 4 [default: "7"]
* sm_blockspectators_time_offset - Time offset (in seconds) until the end of the round [default: "0"]

### Notification flags

Use a sum of flags to manage notifications.

For example:

* Mode 7 includes: Join attempt (1) + Round end (2) + Timer (4)
* Mode 5 includes: Join attempt (1) + Timer (4)

Flags description:

* None (0) - notifications disabled
* Join attempt (1) - when the player tries to join the spectators team
* Round end (2) - at the end of the round
* Timer (4) - when the block timer was triggered
