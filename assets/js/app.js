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

var nickname = document.getElementById('nickname');

let socket = new Socket("/socket", {
    logger: ((kind, msg, data) => { console.log(`${kind}: ${msg}`, data) })
})

function start(type) {
    global.nickname = nickname.value.replace(/(<([^>]+)>)/ig, '').substring(0,24);
    global.playerType = type;

    global.screenWidth = window.innerWidth;
    global.screenHeight = window.innerHeight;

    document.getElementById('menuContainer').style.maxHeight = '0px';
    document.getElementById('clientContainer').style.opacity = 1;

    socket.connect(global.nickname)
    socket.onOpen( ev => console.log("OPEN", ev) )
    socket.onError( ev => console.log("ERROR", ev) )
    socket.onClose( e => console.log("CLOSE", e))

    var chan = socket.channel("room:lobby", {})
    chan.join().receive("ignore", () => console.log("auth error"))
        .receive("ok", () => console.log("join ok"))
        .after(10000, () => console.log("Connection interruption"))
    chan.onError(e => console.log("something went wrong", e))
    chan.onClose(e => console.log("channel closed", e))

    if(!global.animLoopHandle)
        animloop();
}

function validNick() {
    var regex = /^\w*$/;
    console.log('Regex Test', regex.exec(nickname.value));
    return regex.exec(nickname.value) !== null;
}

function play() {
    if(validNick()) {
        start('player');
        spawnPlayer();
    } else {
        // display nickname error
    }
}

function loadGame() {
    let getEle = (e) => document.getElementById(e);
    let startBtn = getEle('startGameBtn'),
        spectateBtn = getEle('spectateBtn'),
        settingsBtn = getEle('settingsBtn'),
        settingsContainer = getEle('settings');

    spectateBtn.addEventListener('click', (e) => {
        start('spectate');
    }, false);

    startBtn.addEventListener('click', play, false);

    settingsBtn.addEventListener('click', (e) => {
        if(settings.style.maxHeight == '300px') {
            settings.style.maxHeight = '0px';
        } else {
            settings.style.maxHeight = '300px';
        }
    }, false);

    nickname.addEventListener('keypress', function(e) {
        var key = e.which || e.keyCode;
        if(key === 13) {
            play();
        }
    });
}

window.onload = loadGame;

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
    target: {x: global.screenWidth / 2, y: global.screenHeight / 2}
};

global.player = player;

let foods = [],
    users = [],
    target = {x: player.x, y: player.y};

global.target = target;

window.canvas = new Canvas();

let c = window.canvas.canvas,
    graph = c.getContext('2d');

function spawnPlayer() {
    player = {};
    player.name = global.nickname;
    player.screenWidth = global.screenWidth;
    player.screenHeight = global.screenHeight;
    player.target = window.canvas.target;
    global.player = player;
    global.gameStart = true;
    console.log("Game started at: "+global.gameStart);
    c.focus();
}

function drawCircle(centerX, centerY, radius, sides) {
    let theta = 0,
        x = 0;
        y = 0;

    graph.beginPath();

    for(let i = 0; i < sides; i++) {
        theta = (i / sides) * 2 * Math.PI;
        x = centerX + radius * Math.sin(theta);
        y = centerY + radius * Math.cos(theta);
        graph.lineTo(x, y);
    }

    graph.closePath();
    graph.stroke();
    graph.fill();
}

function drawgrid() {
    graph.lineWidth = 1;
    graph.strokeStyle = global.lineColor;
    graph.globalAlpha = 0.15;
    graph.beginPath();
    for (let x = global.xoffset - player.x; x < global.screenWidth; x += global.screenHeight / 18) {
        graph.moveTo(x, 0);
        graph.lineTo(x, global.screenHeight);
    }

    for (let y = global.yoffset - player.y; y < global.screenHeight; y += global.screenHeight / 18) {
        graph.moveTo(0, y);
        graph.lineTo(global.screenWidth, y);
    }

    graph.stroke();
    graph.globalAlpha = 1;
}

function drawPlayers(order) {
    let start = {
        x: player.x - (global.screenWidth / 2),
        y: player.y - (global.screenHeight / 2)
    };

    for(let n = 0; n < order.length; n++)
    {
        let userCurrent = users[order[n].nCell],
            cellCurrent = userCurrent.cells[order[n].nDiv],
            x = 0, y = 0;

        let points = 30;

        graph.strokeStyle = 'hsl(' + userCurrent.hue + ', 100%, 45%)';
        graph.fillStyle = 'hsl(' + userCurrent.hue + ', 100%, 50%)';
        graph.lineWidth = playerConfig.border;

        let xstore = [], ystore = [];

        global.spin += 0.0;

        let circle = {
            x: cellCurrent.x - start.x,
            y: cellCurrent.y - start.y
        };


    }
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

        drawgrid();
    }
}
