$(document).ready ->
  dept_forms = $('#department_forms')
  if dept_forms.length > 0
    dept_id = dept_forms.data("department-id")
    dept_forms.embedForms
      department_id: dept_id
      limit: 100
      sort: true
