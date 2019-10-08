function checkLoginState() {               // Called when a person is finished with the Login Button.
  FB.getLoginStatus(function(response) {   // See the onlogin handler
    console.log(response);
    if (response.status === "connected") {
      postFaceBookSignin(response) 
    };
  });
}


window.fbAsyncInit = function() {
  var appid=$("meta[name='facebook-signin-client_id']").attr("content");
  FB.init({
    appId      : appid,
    cookie     : true,                     // Enable cookies to allow the server to access the session.
    xfbml      : true,                     // Parse social plugins on this webpage.
    version    : 'v4.0'           // Use this Graph API version for this call.
  });
  FB.getLoginStatus(function(response) {   // Called after the JS SDK has been initialized.
    console.log(response)
  });
};


(function(d, s, id) {                      // Load the SDK asynchronously
  var js, fjs = d.getElementsByTagName(s)[0];
  if (d.getElementById(id)) return;
  js = d.createElement(s); js.id = id;
  js.src = "https://connect.facebook.net/en_US/sdk.js";
  fjs.parentNode.insertBefore(js, fjs);
}(document, 'script', 'facebook-jssdk'));

var postFaceBookSignin = function(response){
  console.log("facebook ajax action start");
  $.ajax({
    url: window.location.origin + "/oauth/new/facebook",
    type: "GET",
    datatype: "json",
    contentType: "application/json",
    data: {token: response.authResponse.accessToken}
  })
};