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
import {Socket, LongPoller} from "phoenix"

import Canvas from './canvas';
import global from './global';
import MenuController from './menu';

var nickname = document.getElementById('nickname');

import socket from './socket';

function onGameStart(nickname, type) {
    global.nickname = nickname;
    global.playerType = type;
    
    global.screenWidth = window.innerWidth;
    global.screenHeight = window.innerHeight;
    
    global.gameStart = true;
    
    if(type === 'player')
    {
        spawnPlayer();
    }
    
    if(!global.animLoopHandle)
        animloop();
    
    console.log("Game started in mode: "+type);
    // Deal with socket here
}

window.onload = () => {
    window.menu = new MenuController(onGameStart);
    window.menu.bindEvents();
};

let playerConfig = {
    border: 6,
    textFillColor: '#FFFFFF',
    textStrokeColor: '#000000',
    textStrokeSize: 3,
    defaultSize: 30,
};

let player = {
    id: -1,
    x: global.screenWidth / 2,
    y: global.screenHeight / 2,
    screenWidth: global.screenWidth,
    screenHeight: global.screenHeight,
};

global.player = player;

let users = [];

window.canvas = new Canvas();

let c = window.canvas.canvas,
    graph = c.getContext('2d');

function spawnPlayer() {
    player = {
        name: global.nickname,
        x: global.screenWidth / 2,
        y: global.screenHeight / 2,
    };
    
    global.player = player;
    c.focus();
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
    global.animLoopHandle = window.requestAnimFrame(animloop);
    gameLoop();
}

function gameLoop() {
    if(global.gameStart) {
        graph.fillStyle = global.backgroundColor;
        graph.fillRect(0, 0, global.screenWidth, global.screenHeight);

        global.canvas.drawgrid(-player.x, -player.y, global.screenWidth, global.screenHeight);
        
        // Draw player
        graph.strokeStyle = 'hsl(100, 100%, 45%)';
        graph.fillStyle = 'hsl(100, 100%, 50%)';
        graph.lineWidth = playerConfig.border;
        global.canvas.drawCircle(player.x, player.y, 30);
    }
}
