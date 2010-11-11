jQuery(document).oneTime(2000, "notify_box", function() {
	jQuery('.notify-box').fadeOut();
});

jQuery(document).ready(function(){

	jQuery(".hidden-admin_links").hover(
	  function () {
	    jQuery(this).children(".admin-links").show();
	  }, 
	  function () {
	    jQuery(this).children(".admin-links").hide();
	  }
	);

	jQuery(".confirm").live('click',function(){
		var message = jQuery(this).attr('data-confirm');
		if (!confirm(message)){
			return false;
		}
	});
	
	jQuery("#tabs").tabs();
	
	jQuery('.featured-project-link').click(function(){
		jQuery('.featured-project-container').hide();
		jQuery('#' + this.id + '_container').show();
		return false;
	});
	
});

function limitChars(field, limit, info_field)
{
	var text = field.val();
	var textlength = text.length;
	if(textlength > limit) {
 		info_field.html('You cannot write more then '+limit+' characters!');
		field.val(text.substr(0,limit));
		return false;
	} else {
		info_field.html('You have '+ (limit - textlength) +' characters left.');
		return true;
	}
}

function current_time() {
	var a_p = "";
	var d = new Date();
	var curr_hour = d.getHours();
	if (curr_hour < 12) {
	  a_p = "AM"; 
	} else {
	  a_p = "PM";
	}
	if (curr_hour == 0) {
		curr_hour = 12;
	}
	if (curr_hour > 12) {
		curr_hour = curr_hour - 12;
	}
	var curr_min = d.getMinutes();
	curr_min = curr_min + "";
	if (curr_min.length == 1) {
		curr_min = "0" + curr_min;
	}
	return curr_hour + ":" + curr_min + " " + a_p;
}