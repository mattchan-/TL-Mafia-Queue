$(function() {
  var i = 0;
  $('a.spoiler').attr("onClick", function() {
    return "return toggleShowSpoiler(this, " + i++ + ")"
  });
  
  i = 0;
  $('div.spoiler_content').attr("id", function() {
    return 'spoiler_' + i++;
  });
});

function toggleShowSpoiler(b,c) {
  var a=$(b).children("span");
  if($(a[0]).text()=="+ Show") {
    $("#spoiler_"+c).show();
    $(a[0]).text("- Hide");
    $(a[1]).text(" -")
  }
  else {
    $("#spoiler_"+c).hide();
    $(a[0]).text("+ Show");
    $(a[1]).text(" +")
  }
  return false;
}