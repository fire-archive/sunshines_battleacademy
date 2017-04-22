var global = require('./global');

class Canvas {
    constructor(params) {
        this.target = global.target;
        
        this.canvas = document.getElementById('game_area');
        this.canvas.width = global.screenWidth;
        this.canvas.height = global.screenHeight;
        this.canvas.addEventListener('mousemove', this.processInput, false);
        this.canvas.addEventListener('mouseout', this.mouseOut, false);
        this.canvas.addEventListener('keypress', this.keyInput, false);
        this.canvas.parent = this;
        global.canvas = this;
    }
    
    
}

module.exports = Canvas;