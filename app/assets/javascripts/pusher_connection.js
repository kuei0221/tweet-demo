console.log("Build pusher connection")
$.ajax({
  url: window.location.origin + "/notification",
  method: "GET",
  dataType: "script"
})
.done(function(){
  console.log("Pusher connected")
})
.fail(function(response){
  console.log("Pusher not connected. Require login first");
  console.log(response.responseText)
  }
);