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

function onGameStart(nickname, type, hue) {
    gameStarted = true;
    
    // Setup canvas
    if(!window.canvas)
        window.canvas = new Canvas(window.innerWidth, window.innerHeight);
    
    // spawn player
    World.spawnPlayer(type === 'spectate', nickname, hue);
    
    // Connect to chat
    chat.connect(gameNetwork.socket, nickname);
    gameNetwork.connect(World.getPlayer());
    
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

function gameLoop() {
    if(gameStarted) {
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