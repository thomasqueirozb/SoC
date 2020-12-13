#!/usr/bin/env python3

html="""<!DOCTYPE html>\
<html>
<head>
<script>
function ledpost(form) {
    const XHR = new XMLHttpRequest();
    XHR.open('POST', '/led');

    // Add the required HTTP header for form data POST requests
    XHR.setRequestHeader( 'Content-Type', 'application/x-www-form-urlencoded' );

    // Finally, send our data.
    let data = "led="
    if (form.led.checked){data+="on"}else{data+="off"}
    XHR.send(data);

}

function butpost() {
    const XHR = new XMLHttpRequest();
    XHR.open('GET', '/but');

    XHR.onload = function() {
        console.log(XHR.response)
        documentdocument..getElementById("butstate").innerText = XHR.response;
    };

    XHR.send();

}

function submitted(e) {
    e.preventDefault()
}
document.addEventListener("DOMContentLoaded", () => {
    var form = document.querySelector("form");
    form.onsubmit = submitted.bind(form);
});
</script>

<body>
<h2>Led</h2>
<form action="/led" method="POST">
<div>
<input type="checkbox" id="led" name="led" onChange="ledpost(this.form)"/><label for="led">LED</label>
</div>
<div>
</div>
</form>

<h2>Button</h2>
<form action="/but" method="POST">
<div>
<button type="button" onclick="butpost()">Click to check button</button>
<p id="butstate">0</p>
</div>
<div>
</div>
</form>
</body>
</html>"""
 
from flask import Flask, request
import socket

host = "/tmp/9Lq7BNBnBycd6nxy.socket"

sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
sock.connect((host))

server = Flask(__name__)

@server.route('/')
def main():
    return html

@server.route('/but')
def but():
    sock.sendall(bytes("2\n", "utf-8"))
    received = str(sock.recv(1024), "utf-8")
    return "0" if received == 0 else "1"

@server.route('/led', methods = ['POST'])
def led():
    on = int(request.form.get('led') == 'on')
    sock.sendall(bytes(str(on) + "\n", "utf-8"))
    return str(on)

if __name__ == '__main__':
    server.run(host='0.0.0.0', port=80)
