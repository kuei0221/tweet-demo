console.log("load notification.js")

function UnreadNotification(){
  return Number($("#notification_button span").html())
};

function ClearNotification(){
  $("#notification_button span").html(0)
};

function ReadNotification(){
  console.log("Read Notification");
  if(UnreadNotification() > 0 ){
    console.log("start read");
    ClearNotification();
    $.ajax({
      url: window.location.origin + "/notifications/update",
      method: "PATCH"
    })
  }
};

function LoadMoreNotification(loader){
  $.ajax({
    url: window.location.origin + "/notifications/show" ,
    type: "GET",
    dataType: "script",
    data: {"loader": loader}
  });
};


function GetNotification(){
  $.ajax({
    url: window.location.origin + "/notifications",
    method: "GET",
    dataType: "script"
  });
};

$(document).on("turbolinks:load", function(){
  var loader = 0
  $("#loadmore-button").on("click", function(e){
    e.preventDefault(); 
    e.stopPropagation();
    if($("#loadmore-button").html() != "No More Notification"){
      console.log("loadmore");
      loader += 1;
      LoadMoreNotification(loader);  
    } else {
      console.log("stop load more");
    }
  });
  $("#notification_button").on("click", function(e){
    ReadNotification();
  });
  
  GetNotification();
})
