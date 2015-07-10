$(document).ready ->
  dept_forms = $('#department_forms')
  if dept_forms.length > 0
    dept_id = dept_forms.data("department-id")
    dept_forms.embedForms({department: dept_id})

  #   url = "https://forms.biola.edu/api/v1/forms?by_department=" + dept_id
  #   $.get url, (data) ->
  #     console.log(data)
