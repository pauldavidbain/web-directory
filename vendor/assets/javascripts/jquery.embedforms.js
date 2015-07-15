/*********    jquery.embedforms.js    ***********
 *
 * Author: Ryan Hall - Biola University, IT
 * Date Updated: July 15, 2015
 *
 * This is a jQuery plugin that allows you to list forms from forms.biola.edu on your own website.
 * The forms API automatically filters forms by user permissions.
 *
 * To use:
 *   $('#selector').embedForms();cd
 *
 * Optionally, you may pass department ID, limit, page, and sort
 *   $('#selector').embedForms({
 *     department_id: 2,
 *     limit: 100,
 *     page: 1,
 *     sort: true
 *   });
 *
 * A list of available departments with their IDs can be found at:
 *   https://forms.biola.edu/api/v1/departments
 *
 * ********************************************/

jQuery.fn.embedForms = function(query) {
  // Default to {} if not set
  if (query == null) { query = {}; }

  // Stash caller, this needs to be referenced later.
  var _caller = this;

  // Do API call to get the list of forms.
  return $.getJSON('//forms.biola.edu/api/v1/forms?callback=?', query, function(data) {
    var forms, form, link, ul, _i;
    forms = data.forms;
    ul = $("<ul class='forms-list'></ul>");
    _caller.html(ul);
    for (_i = 0; _i < forms.length; _i++) {
      form = forms[_i];
      link = $("<a>" + form.name + "</a>").attr('href', form.url);
      ul.append($("<li></li>").append(link));
    }
  });
};
