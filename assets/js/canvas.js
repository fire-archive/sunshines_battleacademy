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
        this.graph = this.canvas.getContext('2d');
        
        global.canvas = this;
    }
    
    drawgrid(offsetX, offsetY, screenWidth, screenHeight, color='#000000', lineWidth=1, alpha=0.15, numSections=18) {
        this.graph.lineWidth = lineWidth;
        this.graph.strokeStyle = color;
        this.graph.globalAlpha = alpha;
        this.graph.beginPath();
        for (let x = offsetX; x < screenWidth; x += screenHeight / numSections) {
            this.graph.moveTo(x, 0);
            this.graph.lineTo(x, screenHeight);
        }

        for (let y = offsetY; y < screenHeight; y += screenHeight / numSections) {
            this.graph.moveTo(0, y);
            this.graph.lineTo(screenWidth, y);
        }

        this.graph.stroke();
        this.graph.globalAlpha = 1;
    }
    
    drawCircle(centerX, centerY, radius) {
        this.graph.beginPath();
        this.graph.arc(centerX, centerY, radius, 0, 2 * Math.PI, false);

        this.graph.stroke();
        this.graph.fill();
    }
    
    drawPoly(centerX, centerY, radius, sides) {
        let theta = 0,
            x = 0,
            y = 0;

        this.graph.beginPath();

        for(let i = 0; i < sides; i++) {
            theta = (i / sides) * 2 * Math.PI;
            x = centerX + radius * Math.sin(theta);
            y = centerY + radius * Math.cos(theta);
            this.graph.lineTo(x, y);
        }

        this.graph.closePath();
        this.graph.stroke();
        this.graph.fill();
    }
}

module.exports = Canvas;