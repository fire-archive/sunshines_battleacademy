# Additional protocol events

## Fire Projectile

An event named "fire" but with no data, the server can use the player's current target vector to calculate the direction, but normalize it first to avoid the magnitude affecting projectile speed.

## Target Heartbeat

A secondary heartbeat which sends the player's target vector so the server can calculate the new position of the player.