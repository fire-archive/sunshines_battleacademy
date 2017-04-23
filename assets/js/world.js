let players = [],
    projectiles = [];

let localPlayer = {
    nickname: '',
    id: -1,
    x: 0, // Will be used as our x offset
    y: 0, // will be used as our y offset
    hue: 0,
    isGhost: true,
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
    
    // Loop and draw remote players, ignore local if found
}

function drawGrid(width, height) {
    window.canvas.drawGrid(-localPlayer.x, -localPlayer.y, width, height);
}

function spawnPlayer(ghost, name, hue) {
    localPlayer.isGhost = ghost;
    localPlayer.nickname = name;
    localPlayer.hue = hue;
    localPlayer.x = window.canvas.width / 2;
    localPlayer.y = window.canvas.height / 2;
}

function draw(bg) {
    let screenWidth = window.canvas.width,
        screenHeight = window.canvas.height;
    
    window.canvas.ctx.fillStyle = '#f2fbff';
    window.canvas.ctx.fillRect(0, 0, screenWidth, screenHeight);

    drawGrid(screenWidth, screenHeight);
    drawPlayers(screenWidth, screenHeight);
}

function getPlayer() {
    return localPlayer;
}

export default {
    draw,
    spawnPlayer,
    getPlayer
}