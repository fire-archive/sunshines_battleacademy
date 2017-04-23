let chatContainer = document.getElementById('chatContainer'),
    chatMessages = document.getElementById('chatMessages'),
    chatInput = document.getElementById('chatInput'),
    nickname = '';

let channel = undefined, connected = false;

function bindEvents(channel) {
    connected = true;
    chatContainer.style.maxHeight = '200px';
    chatInput.addEventListener('keypress', (e) => {
        let key = e.which || e.keyCode;
        if(key === 13) { // Enter key
            if(chatInput.value.length < 1) return;
            channel.push("new_msg", {user: nickname, body: chatInput.value});
            chatInput.value = "";
            chatMessages.scrollTop = chatMessages.scrollHeight;
        }
    });
}

function connect(socket, nick) {
    nickname = nick
    if(connected) {
        console.debug("Already connected to chat!");
        return; // Don't re-bind events and everything!
    }

    let channel = socket.channel("chat:lobby", {});
    
    channel.on("new_msg", payload => {
        let messageItem = document.createElement("p");
        
        let date = new Date(new Date().getTime()).toLocaleTimeString();
        let dateEle = document.createElement('span');
        dateEle.classList.add('msg_date');
        dateEle.innerText = `[${date}] `;
        messageItem.appendChild(dateEle);
        
        let userEle = document.createElement('span');
        userEle.classList.add('msg_user');
        userEle.innerText = `${payload.user}: `;
        messageItem.appendChild(userEle);
        
        let bodyEle = document.createElement('span');
        bodyEle.classList.add('msg_body');
        bodyEle.innerText = payload.body;
        messageItem.appendChild(bodyEle);
        
        chatMessages.appendChild(messageItem);
        chatMessages.scrollTop = chatMessages.scrollHeight;
    });

    channel.join()
    .receive("ok", resp => { 
        console.log("Joined chat successfully", resp) 
        bindEvents(channel);
    })
    .receive("error", resp => { console.log("Unable to join chat", resp) })
}

export default {
    connect
};