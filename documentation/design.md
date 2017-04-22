# Sunshine's Battleacademy design document

For each bucket (8^2) fetch all keys 60 times a second.

## Commands

* connection
* gotit
* pingcheck
* windowresize
* respawn
* disconnect
* playercheck
* pass
* kick
* 0 (heartbeat
* 1 (fire food)
* 2 (split cell)

## Game loops

* move loop repeated 1000ms / 60
  - tick player
  - move food
* game loop repeated 1000ms
* send updates repeated 1000 / network update factor
