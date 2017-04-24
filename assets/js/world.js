let players = {},
    projectiles = [];

let localPlayer = {
    nickname: '',
    id: -1,
    x: 0, // Will be used as our x offset
    y: 0, // will be used as our y offset
    hue: 0,
    isGhost: true,
    target: {x: 0, y: 0}
};
    
function drawPlayers(screenWidth, screenHeight) {
    // draw local player
    if(!localPlayer.isGhost) {
        window.canvas.drawPlayer(
            screenWidth / 2, screenHeight / 2,
            localPlayer.hue,
            localPlayer.nickname,
        );
    }

    for (var k in players) {
        if (players.hasOwnProperty(k)) {
            player = players[k];
            window.canvas.drawPlayer(
                screenWidth / 2 - localPlayer.x + player.x, screenHeight / 2 - localPlayer.y + player.y,
                player.hue,
                player.nickname,
            );
        }
    }
    
    // Loop and draw remote players, ignore local if found
}

function drawGrid() {
    window.canvas.drawGrid(-localPlayer.x, -localPlayer.y);
}

function spawnPlayer(ghost, name, hue) {
    localPlayer.isGhost = ghost;
    localPlayer.nickname = name;
    localPlayer.hue = hue;
    localPlayer.x = window.canvas.width / 2;
    localPlayer.y = window.canvas.height / 2;
}

function draw(bg) {
    window.player = localPlayer;
    let screenWidth = window.canvas.width,
        screenHeight = window.canvas.height;
    
    window.canvas.ctx.fillStyle = '#f2fbff';
    window.canvas.ctx.fillRect(0, 0, screenWidth, screenHeight);

    drawGrid();
    drawPlayers(screenWidth, screenHeight);
}

function getPlayer() {
    return localPlayer;
}

function setPlayer(player) {
    localPlayer = player;
}

function updatePlayers(data) {
    data.forEach(player => {
        if(player.id in players) {
            players[player.id].x = player.position.x;
            players[player.id].y = player.position.y;
        } else {
            players[player.id] = {
                nickname: player.nickname,
                id: player.id,
                x: player.position.x,
                y: player.position.y,
                hue: player.hue,
                isGhost: false
            };
        }
    });
}

export default {
    draw,
    spawnPlayer,
    getPlayer,
    setPlayer,
    updatePlayers,
}