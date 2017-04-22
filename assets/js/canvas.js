let playerRenderConfig = {
    border: 6,
    textFillColor: '#FFFFFF',
    textStrokeColor: '#000000',
    textStrokeSize: 3,
    defaultSize: 30,
};

let gridRenderConfig = {
     color: '#000000',
     width: 1,
     alpha: 0.15,
     numSections: 18
}

class Canvas {
    constructor(width, height) {
        this.element = document.getElementById('game_area');
        this.resize(width, height);
        
        this.element.addEventListener('mousemove', this.processInput, false);
        this.element.addEventListener('mouseout', this.mouseOut, false);
        this.element.addEventListener('keypress', this.keyInput, false);
        this.element.parent = this;
        this.ctx = this.element.getContext('2d');
    }
    
    resize(width, height) {
        this.element.width = this.width = width;
        this.element.height = this.height = height;
    }
    
    drawGrid(offsetX, offsetY, screenWidth, screenHeight) {
        this.ctx.lineWidth = gridRenderConfig.width;
        this.ctx.strokeStyle = gridRenderConfig.color;
        this.ctx.globalAlpha = gridRenderConfig.alpha;
        this.ctx.beginPath();
        for (let x = offsetX; x < screenWidth; x += screenHeight / gridRenderConfig.numSections) {
            this.ctx.moveTo(x, 0);
            this.ctx.lineTo(x, screenHeight);
        }

        for (let y = offsetY; y < screenHeight; y += screenHeight / gridRenderConfig.numSections) {
            this.ctx.moveTo(0, y);
            this.ctx.lineTo(screenWidth, y);
        }

        this.ctx.stroke();
        this.ctx.globalAlpha = 1;
    }
    
    drawCircle(centerX, centerY, radius) {
        this.ctx.beginPath();
        this.ctx.arc(centerX, centerY, radius, 0, 2 * Math.PI, false);
        this.ctx.closePath();
        this.ctx.stroke();
        this.ctx.fill();
    }
    
    drawPoly(centerX, centerY, radius, sides) {
        let theta = 0,
            x = 0,
            y = 0;

        this.ctx.beginPath();

        for(let i = 0; i < sides; i++) {
            theta = (i / sides) * 2 * Math.PI;
            x = centerX + radius * Math.sin(theta);
            y = centerY + radius * Math.cos(theta);
            this.ctx.lineTo(x, y);
        }

        this.ctx.closePath();
        this.ctx.stroke();
        this.ctx.fill();
    }
    
    drawPlayer(x, y, hue, name, radius=playerRenderConfig.defaultSize) {
        this.ctx.strokeStyle = `hsl(${hue}, 100%, 45%)`;
        this.ctx.fillStyle = `hsl(${hue}, 100%, 50%)`;
        this.ctx.lineWidth = playerRenderConfig.border;
        this.drawCircle(x, y, radius);
        
        this.ctx.lineWidth = 2;
        this.ctx.textAlign = 'center';
        this.ctx.textBaseline = 'middle';
        this.ctx.font = '20px sans serif';
        this.ctx.fillStyle = playerRenderConfig.textFillColor;
        this.ctx.strokeStyle = playerRenderConfig.textStrokeColor;
        this.ctx.strokeText(name, x, y);
        this.ctx.fillText(name, x, y);
    }
}

module.exports = Canvas;