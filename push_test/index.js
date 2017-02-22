const apn = require("apn");

let users = [
  //{ name: "Wendy", "devices": ["<insert device token>", "<insert device token>"]},
  { name: "Kyungtaek",  "devices": ["c3231fbbb26c109bbc808b89f896e5fe65f4a8dd0cf38af8e29ea317b7a8f795"]},
];

let service = new apn.Provider({
  cert: "keys/cert.pem",
  key: "keys/key.pem",
});

users.forEach( (user) => {

  let note = new apn.Notification();
  note.alert = `Hey ${user.name}, I just sent my first Push Notification`;
  note.payload = {'question':'question', 'questionID':'questionID', 'willItemID':'willItemID'}

  // The topic is usually the bundle identifier of your application.
  //note.topic = "<bundle identifier>";
  note.topic = "com.bezierpaths.dear";

  console.log(`Sending: ${note.compile()} to ${user.devices}`);

  service.send(note, user.devices).then( result => {
      console.log("sent:", result.sent.length);
      console.log("failed:", result.failed.length);
      console.log(result.failed);
  });
});

// For one-shot notification tasks you may wish to shutdown the connection
// after everything is sent, but only call shutdown if you need your
// application to terminate.
service.shutdown();
