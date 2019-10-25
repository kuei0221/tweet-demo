console.log("load goolge_login")
var clicked=false

//if not set clicklogin with onclick, onSignIn will auto run if your google is already login(onsuccess)
function ClickLogin(){ clicked=true }

function onSignIn(googleUser) {
  if (clicked){
    profile = googleUser.getBasicProfile();
    id_token = googleUser.getAuthResponse().id_token;
    console.log("setting google status");
    postGoogleSignin();
  }
}
function postGoogleSignin(){
  console.log("google ajax action start");
  $.ajax({
    url: window.location.origin + "/oauth/google",
    type: "POST",
    dataType: "script",
    contentType: "application/json",
    data: JSON.stringify({token: id_token})
  })
  .done(function(){
    console.log("Login by google done. Now redirect to Home");
  })
  .fail(function(){
    console.log("Login by google failed. Now redirect to login page")
  });
}

