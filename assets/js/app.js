// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"

import Canvas from './canvas';
import MenuController from './menu';
import World from './world';
import gameNetwork from './socket';
import chat from './chat';

let gameStarted = false, animLoopHandle = undefined;
let interpolation = {snapshots: []};

function onGameStart(nickname, type, hue) {
    gameStarted = true;
    
    // Setup canvas
    if(!window.canvas)
        window.canvas = new Canvas(window.innerWidth, window.innerHeight);
    
    // spawn player
    World.spawnPlayer(type === 'spectate', nickname, hue);
    
    // Connect to chat
    chat.connect(gameNetwork.socket, nickname);
    gameNetwork.connect(World, interpolation);
    
    // start animation loop
    if(!animLoopHandle)
        animloop();
    
    window.canvas.element.focus();
    console.log(`Game started in mode: ${type} with nickname: ${nickname}`);
    // Deal with socket here
}

window.requestAnimFrame = (() => {
    return  window.requestAnimationFrame       ||
            window.webkitRequestAnimationFrame ||
            window.mozRequestAnimationFrame    ||
            window.msRequestAnimationFrame     ||
            ((cb) => window.setTimeout(cb, 1000/60))
})();

window.cancelAnimFrame = ((handle) => {
    return window.cancelAnimationFrame || window.mozCancelAnimationFrame;
})();

function animloop() {
    animLoopHandle = window.requestAnimFrame(animloop);
    gameLoop();
}

let INTERPOLATION_LATENCY = 100;

function lerp(v0, v1, t)
{
    return (1 - t) * v0 + t * v1;
}

function interpolate(deltaTime)
{
    let currentTime = new Date().getTime();
    interpolation.snapshots = interpolation.snapshots.filter((val, ind, array) => {
        return val.time > currentTime - 1000; // Keep snapshots for 1 second;
    });

    let previous_time = currentTime - INTERPOLATION_LATENCY;

    let before = interpolation.snapshots.filter((val) => { return val.time < previous_time; });
    let after = interpolation.snapshots.filter((val) => { return val.time > previous_time; });
    if(!before.length > 0 || !after.length > 0) return; // no snapshots in either direction?
    let before_snapshot = before[before.length-1];
    let after_snapshot = after[0];

    let player = World.getPlayer();
    let dt = after_snapshot.time - before_snapshot.time;
    let t = (previous_time - before_snapshot.time) / dt;
    
    player.x = lerp(before_snapshot.x, after_snapshot.x, t);
    player.y = lerp(before_snapshot.y, after_snapshot.y, t);
    World.setPlayer(player);
}

let oldTime = new Date().getTime();
function gameLoop() {
    if(gameStarted) {
        let delta = new Date().getTime() - oldTime;
        oldTime = new Date().getTime();

        interpolate(delta);

        World.draw();
    }
}

window.onload = () => {
    window.menu = new MenuController(onGameStart);
    window.menu.bindEvents();
};

window.addEventListener('resize', (e) => {
    if(window.canvas)
        window.canvas.resize(window.innerWidth, window.innerHeight)
});