function validNick(nicknameInput) {
    if(nicknameInput.value.length < 1) return false;
    const regex = /^\w*$/;
    return regex.exec(nicknameInput.value) !== null;
}

export default class MenuController {
    constructor(onGameStartCallback) {
        this.onGameStart = onGameStartCallback;
        
        this.startBtn = document.getElementById('startGameBtn'),
        this.spectateBtn = document.getElementById('spectateBtn'),
        this.settingsBtn = document.getElementById('settingsBtn'),
        this.settingsContainer = document.getElementById('settings');
        
        // Inputs
        this.nicknameInput = document.getElementById('nickname');
        
        // Labels
        this.errorLabel = document.getElementById('nicknameError');
        
        // Hue stuff
        this.hueSlider = document.getElementById('hue');
        this.huePreview = document.getElementById('huePreview');
        this.setHue(Math.floor(Math.random() * 360)); // Randomize initial color selection
        
        // Containers
        this.container = document.getElementById('menuContainer');
        this.gameContainer = document.getElementById('clientContainer');
    }
    
    hide() {
        this.container.style.maxHeight = '0px';
        this.gameContainer.style.opacity = 1;
    }
    
    show() {
        this.container.style.maxHeight = '';
        this.gameContainer.style.opacity = 0;
    }
    
    bindEvents() {
        // Buttons
        this.spectateBtn.addEventListener('click', this.startGame.bind(this, 'spectate'));
        this.settingsBtn.addEventListener('click', this.toggleSettings);
        this.startBtn.addEventListener('click', this.playGame.bind(this));
        
        // Hue
        this.hueSlider.addEventListener('input', (e) => {
            this.setHue(this.hueSlider.value);
        });
        
        // Inputs
        this.nicknameInput.addEventListener('keypress', this.onKeyPress.bind(this));
    }
    
    setHue(hue) {
        this.hueSlider.value = hue;
        this.huePreview.style.backgroundColor = `hsl(${hue}, 100%, 50%)`;
    }
    
     onKeyPress(e) {
        var key = e.which || e.keyCode;
        if(key === 13) { // Enter key
            this.playGame();
        }
    }
    
    playGame() {
        if(validNick(this.nicknameInput)) {
            this.startGame('player');
            // hide nickname error
            this.errorLabel.style.display = 'none';
        } else {
            // display nickname error
            this.errorLabel.style.display = 'block';
        }
    }
    
    toggleSettings() {
        let settings = window.document.getElementById('settings');
        if(settings.style.maxHeight == '300px') {
            settings.style.maxHeight = '0px';
        } else {
            settings.style.maxHeight = '300px';
        }
    }
    
    startGame(type) {
        let nickname = this.nicknameInput.value.replace(/(<([^>]+)>)/ig, '').substring(0,24);
        this.hide();
        this.onGameStart(nickname, type, this.hueSlider.value);
    }
}