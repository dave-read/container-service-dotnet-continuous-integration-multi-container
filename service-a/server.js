var os = require('os');
var request = require('request');
var morgan = require('morgan');
var express = require('express');

var app = express();

// Use environment variables to allow Pod deployment in k8
var listenPort = process.env.LISTENPORT || 80;
var backendHostPort= process.env.BACKEND_HOSTPORT || "service-b:80";
var redisHost = process.env.REDIS_HOST || "mycache";
var redis = connectToCache(redisHost);

console.log("[listenPort:"+listenPort+"][backendHostPort:"+backendHostPort+"][redisHost:"+redisHost+"]")
app.use(express.static(__dirname + '/public'));
app.use(morgan("dev"));

// application -------------------------------------------------------------
app.get('/', function (req, res) {
    res.sendFile(__dirname + '/public/index.html');
});

// api ------------------------------------------------------------
app.get('/api', function (req, res) {
    // Increment requestCount each time API is called
    if (!redis) { redis = connectToCache(redisHost); }
    redis.incr('requestCount', function (err, reply) {
        var requestCount = reply;
    });

    // Invoke service-b
    request('http://'+backendHostPort, function (error, response, body) {
        res.send('Hello from service A running on ' + os.hostname() + ' and ' + body);
    });
});

app.get('/metrics', function (req, res) {
    if (!redis) { redis = connectToCache(redisHost); }
    redis.get('requestCount', function (err, reply) {
        res.send({ requestCount: reply });
    });
});


var server = app.listen(listenPort, function () {
    console.log('Listening on port ' + listenPort);
});

process.on("SIGINT", () => {
    process.exit(130 /* 128 + SIGINT */);
});

process.on("SIGTERM", () => {
    console.log("Terminating...");
    server.close();
});

function connectToCache(redisHost) {
    var redis = require('redis').createClient("redis://"+redisHost);
    return redis;
}
