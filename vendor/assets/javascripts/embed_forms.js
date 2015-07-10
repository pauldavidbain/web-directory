/*********    embed_forms.js    ***********
 *
 * Author: Ryan Hall - Biola University, IT
 * Date Updated: Dec 11, 2012
 *
 * URL: https://gist.github.com/halloffame/c62757d7915160723051
 *
 * This is a jQuery plugin that allows you to list forms from forms.biola.edu on your own website
 *
 * To use:
 *   $('#selector').embedForms();
 *
 * Optionally, you may pass department and audience (group) IDs
 *   $('#selector').embedForms({
 *     department: 2,
 *     audience: 2
 *   });
 *
 * A list of available groups and departments with their IDs can be found at:
 *   https://forms.biola.edu/api/v1/departments
 *   https://forms.biola.edu/api/v1/groups
 *
 * ********************************************/

$.fn.embedForms = function(query) {
  // Default to {} if not set
  if (query == null) { query = {}; }

  // Stash caller, this needs to be referenced later.
  var _caller = this;

  // Map 'department' and 'audience' to what the api is expecting.
  if (query.department !== null) { query.by_department = query.department; }
  if (query.audience !== null) { query.by_group = query.audience; }

  // Do API call to get the list of forms.
  return $.getJSON('//forms.biola.edu/api/v1/forms?callback=?', query, function(data) {
    var form, link, ul, _i;
    ul = $("<ul class='forms-list'></ul>");
    _caller.html(ul);
    for (_i = 0; _i < data.length; _i++) {
      form = data[_i];
      link = $("<a>" + form.name + "</a>").attr('href', "//forms.biola.edu/" + form.slug);
      ul.append($("<li></li>").append(link));
    }
  });
};
