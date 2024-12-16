$(function() {
    $("#container").hide();

    window.addEventListener('message', function(event) {
        var item = event.data;
        if (item.type === "ui") {
            if (item.status) {
                $("#container").show();
            } else {
                $("#container").hide();
            }
        }
    });
});
