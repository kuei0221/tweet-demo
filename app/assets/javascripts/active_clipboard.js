$(document).on('turbolinks:load', function(){
  var clipboard = new ClipboardJS('.clipboard');

  clipboard.on('success', function(e) {
    console.info('Action:', e.action);
    console.info('Text:', e.text);
    console.info('Trigger:', e.trigger);
  
    // e.clearSelection();
  });
  
  clipboard.on('error', function(e) {
    console.error('Action:', e.action);
    console.error('Trigger:', e.trigger);
  });

});