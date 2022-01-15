var http = require('http');
var os = require('os');

var ifaces = os.networkInterfaces( );

var leader = {};

var myIpAddress;
var myHostname;

var cb = function(response) {
    var data = '';
    response.on('data', function(piece) {data = data + piece; });
    response.on('end', function() { leader = JSON.parse(data); })
};

var getNodeIp = function() {
    Object.keys(ifaces).forEach(function (ifname) {
        var alias = 0;
        ifaces[ifname].forEach(function (iface) {
            if ('IPv4' !== iface.family || iface.internal !== false) {
                // skip (i.e. 127.0.0.1) and no ipv4 address
                return;
            }
            if (alias >= 4) {

            } else {
                myIpAddress = iface.address;
                return iface.address;
            }
            ++alias;
        });
    });
};

var updateLeader = function() {
    var req = http.get({host: 'localhost', path: '/', port: 4040}, cb);
    req.on('error', function(e) { console.log('problem with request: ' + e.message)});
    req.end()
}

var handleRequest = function(request, response) {
	// Get the current date object
	let date1 = new Date();

	// Set my hostname
	myHostname = os.hostname();

	//Some logging to the console
	console.log('Received request for URL: ' + request.url);
	//response.writeHead(200);
	response.statusCode = 200; // Send 200 OK
	response.write('<html>');
	response.write('<body>');
	response.write("<h2> My hostname: " + myHostname + "</h2>");
	response.write("<h2> My IP      : "+ myIpAddress  +"</h2>");
	if (myHostname == leader.name) {
		response.write("<h2> I am the current master! </h2>");
	}
	else{
		response.write("<h2> The master is at hostname: "+ leader.name  +"</h2>");
	}

	response.write("<p> Current time: "+ date1.getHours() + ":" + date1.getMinutes() + ":" + date1.getSeconds() + "</p>");
	response.write('</body>');
	response.write('</html>');
	response.end();
};

// Set up regular updates
updateLeader();
setInterval(updateLeader, 3000);
getNodeIp();
setInterval(getNodeIp, 3000);

// Create the server object
var www = http.createServer(handleRequest);
www.listen(8080);
