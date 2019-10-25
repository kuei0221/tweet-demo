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

function LoadMoreNotification(){
  $.ajax({
    url: window.location.origin + "/notifications/show" ,
    type: "GET",
    dataType: "script",
    data: {"oldest_id": GetOldestNotificationId()}
  });
};


function GetNotification(){
  $.ajax({
    url: window.location.origin + "/notifications",
    method: "GET",
    dataType: "script"
  });
};

function GetOldestNotificationId(){
  return $("#notification_box .notifications").last().attr("id");
}

$(document).on("turbolinks:load", function(){
  $("#loadmore-button").on("click", function(e){
    e.preventDefault(); 
    e.stopPropagation();
    if($("#loadmore-button").html() != "No More Notification"){
      console.log("loadmore");
      LoadMoreNotification();  
    } else {
      console.log("stop load more");
    }
  });
  $("#notification_button").on("click", function(e){
    ReadNotification();
  });
  
  GetNotification();
})
