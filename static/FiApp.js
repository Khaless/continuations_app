
$(document).ready(function() {
	$('.async_button').bind('click', function() {
		jQuery.post(
			'/app', 
			{'__event': 'click', '__target': this.name},
			function(transport) {
				alert(transport);
			});
	});
});
