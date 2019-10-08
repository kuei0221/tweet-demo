 var clicked=false

 //if not set clicklogin with onclick, onSignIn will auto run if your google is already login(onsuccess)
 function ClickLogin(){ clicked=true }

 function onSignIn(googleUser) {
   if (clicked){
     profile = googleUser.getBasicProfile();
     id_token = googleUser.getAuthResponse().id_token;
     console.log("setting google status");
     postGoolgeSignin();
   }
 }

 var postGoolgeSignin = function(){
   console.log("google ajax action start");
   $.ajax({
     url: window.location.origin + "/oauth/google",
     type: "POST",
     datatype: "json",
     contentType: "application/json",
     data: JSON.stringify({token: id_token})
   })
 }